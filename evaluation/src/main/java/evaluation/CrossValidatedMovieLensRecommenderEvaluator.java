package evaluation;

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;
import matlabcontrol.MatlabProxyFactoryOptions;
import net.recommenders.rival.core.DataModel;
import net.recommenders.rival.core.DataModelUtils;
import net.recommenders.rival.core.Parser;
import net.recommenders.rival.core.SimpleParser;
import net.recommenders.rival.evaluation.metric.ranking.NDCG;
import net.recommenders.rival.evaluation.metric.ranking.Precision;
import net.recommenders.rival.evaluation.strategy.EvaluationStrategy;
import net.recommenders.rival.examples.DataDownloader;
import net.recommenders.rival.split.parser.MovielensParser;
import net.recommenders.rival.split.splitter.CrossValidationSplitter;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

import net.recommenders.rival.evaluation.metric.error.RMSE;

/**
 * RiVal Movielens100k Matlab call Example
 *
 * @author <a href="http://github.com/camilomartinez">Camilo</a>
 */
public class CrossValidatedMovieLensRecommenderEvaluator {

    public static void main(String[] args) {
        String url = "http://files.grouplens.org/datasets/movielens/ml-100k.zip";
        String folder = "data/ml-100k";
        String modelPath = "data/ml-100k/model/";
        String recPath = "data/ml-100k/recommendations/";
        int nFolds = 5;
        prepareSplits(url, nFolds, "data/ml-100k/u.data", folder, modelPath);
        recommend(nFolds, modelPath, recPath);
        // the strategy files are (currently) being ignored
        prepareStrategy(nFolds, modelPath, recPath, modelPath);
        evaluate(nFolds, modelPath, recPath);
    }

    public static void prepareSplits(String url, int nFolds, String inFile, String folder, String outPath) {
        DataDownloader dd = new DataDownloader(url, folder);
        dd.downloadAndUnzip();

        boolean perUser = true;
        long seed = 2048;
        Parser parser = new MovielensParser();

        DataModel<Long, Long> data = null;
        try {
            data = parser.parseData(new File(inFile));
        } catch (IOException e) {
            e.printStackTrace();
        }

        DataModel<Long, Long>[] splits = new CrossValidationSplitter(nFolds, perUser, seed).split(data);
        File dir = new File(outPath);
        if (!dir.exists()) {
            dir.mkdir();
        }
        for (int i = 0; i < splits.length / 2; i++) {
            DataModel<Long, Long> training = splits[2 * i];
            DataModel<Long, Long> test = splits[2 * i + 1];
            String trainingFile = outPath + "train_" + i + ".csv";
            String testFile = outPath + "test_" + i + ".csv";
            System.out.println("train: " + trainingFile);
            System.out.println("test: " + testFile);
            boolean overwrite = true;
            try {
//                training.saveDataModel(trainingFile, overwrite);
//                test.saveDataModel(testFile, overwrite);
                DataModelUtils.saveDataModel(training, trainingFile, overwrite);
                DataModelUtils.saveDataModel(test, testFile, overwrite);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    public static void recommend(int nFolds, String inPath, String outPath) {
    	// Uses MatlabControl library available at
    	// https://code.google.com/p/matlabcontrol/
    	// Prepare command
    	String recommender = "@PopularRecommender";
    	String inFullPath, outFullPath, command = null;
		try {
			inFullPath = new File(inPath).getCanonicalPath();
			outFullPath = new File(outPath).getCanonicalPath();
			command = String.format("recommend(%s, %d, '%s', '%s')",
	    			recommender,
	    			nFolds,
	    			inFullPath,
	    			outFullPath);	    	
		} catch (IOException e) {
			e.printStackTrace();
		}
    	// Run Matlab only showing results
    	// Faster to start
    	MatlabProxyFactoryOptions options = new MatlabProxyFactoryOptions.Builder().setHidden(true).build();
    	//Create a proxy, which we will use to control MATLAB
    	MatlabProxyFactory factory = new MatlabProxyFactory(options);
        MatlabProxy proxy;
		try {
			proxy = factory.getProxy();
			proxy.eval(command);
			//Disconnect the proxy from MATLAB
	        proxy.disconnect(); 
		} catch (MatlabConnectionException e) {
			e.printStackTrace();
		} catch (MatlabInvocationException e) {
			e.printStackTrace();
		}        
    }

    @SuppressWarnings("unchecked")
    public static void prepareStrategy(int nFolds, String splitPath, String recPath, String outPath) {
        for (int i = 0; i < nFolds; i++) {
            File trainingFile = new File(splitPath + "train_" + i + ".csv");
            File testFile = new File(splitPath + "test_" + i + ".csv");
            File recFile = new File(recPath + "recs_" + i + ".csv");
            DataModel<Long, Long> trainingModel = null;
            DataModel<Long, Long> testModel = null;
            DataModel<Long, Long> recModel = null;
            try {
                trainingModel = new SimpleParser().parseData(trainingFile);
                testModel = new SimpleParser().parseData(testFile);
                recModel = new SimpleParser().parseData(recFile);
            } catch (IOException e) {
                e.printStackTrace();
            }

            Double threshold = 2.0;
            String strategyClassName = "net.recommenders.rival.evaluation.strategy.UserTest";
            EvaluationStrategy<Long, Long> strategy = null;
            try {
                strategy = (EvaluationStrategy<Long, Long>) (Class.forName(strategyClassName)).getConstructor(DataModel.class, DataModel.class, double.class).newInstance(trainingModel, testModel, threshold);
                // Alternatively
                // strategy = new UserTest(trainingModel,testModel,threshold);
            } catch (InstantiationException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

            DataModel<Long, Long> modelToEval = new DataModel<Long, Long>();

            for (Long user : recModel.getUsers()) {
                for (Long item : strategy.getCandidateItemsToRank(user)) {
                    if (recModel.getUserItemPreferences().get(user).containsKey(item)) {
                        modelToEval.addPreference(user, item, recModel.getUserItemPreferences().get(user).get(item));
                    }
                }
            }
            try {
//                modelToEval.saveDataModel(outPath + "strategymodel_" + i + ".csv", true);
                DataModelUtils.saveDataModel(modelToEval, outPath + "strategymodel_" + i + ".csv", true);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    public static void evaluate(int nFolds, String splitPath, String recPath) {
        double ndcgRes = 0.0;
        double precisionRes = 0.0;
        double rmseRes = 0.0;
        for (int i = 0; i < nFolds; i++) {
            File testFile = new File(splitPath + "test_" + i + ".csv");
            File recFile = new File(recPath + "recs_" + i + ".csv");
            DataModel<Long, Long> testModel = null;
            DataModel<Long, Long> recModel = null;
            try {
                testModel = new SimpleParser().parseData(testFile);
                recModel = new SimpleParser().parseData(recFile);
            } catch (IOException e) {
                e.printStackTrace();
            }
            NDCG ndcg = new NDCG(recModel, testModel, new int[]{10});
            ndcg.compute();
            ndcgRes += ndcg.getValueAt(10);

            RMSE rmse = new RMSE(recModel, testModel);
            rmse.compute();
            rmseRes += rmse.getValue();

            Precision precision = new Precision(recModel, testModel, 3.0, new int[]{10});
            precision.compute();
            precisionRes += precision.getValueAt(10);
        }
        System.out.println("NDCG@10: " + ndcgRes / nFolds);
        System.out.println("RMSE: " + rmseRes / nFolds);
        System.out.println("P@10: " + precisionRes / nFolds);

    }
}
