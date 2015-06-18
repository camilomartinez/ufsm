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
import java.nio.file.Path;

import org.apache.commons.io.FilenameUtils;

import net.recommenders.rival.evaluation.metric.error.RMSE;

/**
 * RiVal Movielens100k Matlab call Example
 *
 * @author <a href="http://github.com/camilomartinez">Camilo</a>
 */
public class CrossValidatedNetflixRecommenderEvaluator {

    public static void main(String[] args) {
        String sourceFolder = FilenameUtils.normalize(new File("../data/").getAbsolutePath());
        String modelPath = "data/netflix/model/";
        String recPath = "data/netflix/recommendations/";
        String matlabRecommender = "@CoSimRecommender";
        int nFolds = 5;
        prepareSplits(nFolds, "details/urmCache_short.dat", sourceFolder, modelPath);
        recommend(nFolds, modelPath, recPath, matlabRecommender);
        // the strategy files are (currently) being ignored
        prepareStrategy(nFolds, modelPath, recPath, modelPath);
        evaluate(nFolds, modelPath, recPath);
    }

    public static void prepareSplits(int nFolds, String inFile, String sourceFolder, String outPath) {
    	String urmFile = new File(sourceFolder, inFile).getPath();
        String icmFile = new File(sourceFolder, "ICM_IDF.mat").getPath();
        Path icmPath = new java.io.File(icmFile).toPath();
        String icmCopy = new File(outPath, "icm.mat").getAbsolutePath();
        Path copyPath = new java.io.File(icmCopy).toPath();
        
        // Copy item content model
        File dir = new File(outPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        try {
			java.nio.file.Files.copy( 
					icmPath, 
					copyPath,
			        java.nio.file.StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException e) {
			e.printStackTrace();
		}
        
        // Generate splits
        boolean perUser = true;
        long seed = 2048;
        SimpleParser parser = new SimpleParser();

        DataModel<Long, Long> data = null;
        try {
            data = parser.parseData(new File(urmFile), "\\|");
        } catch (IOException e) {
            e.printStackTrace();
        }

        DataModel<Long, Long>[] splits = new CrossValidationSplitter(nFolds, perUser, seed).split(data);
        for (int i = 0; i < splits.length / 2; i++) {
            DataModel<Long, Long> training = splits[2 * i];
            DataModel<Long, Long> test = splits[2 * i + 1];
            String trainingFile = outPath + "train_" + i + ".csv";
            String testFile = outPath + "test_" + i + ".csv";
            System.out.println("train: " + trainingFile);
            System.out.println("test: " + testFile);
            boolean overwrite = true;
            try {
                DataModelUtils.saveDataModel(training, trainingFile, overwrite);
                DataModelUtils.saveDataModel(test, testFile, overwrite);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
        }
        
        
    }

    public static void recommend(int nFolds, String inPath, String outPath, String matlabRecommender) {
    	// Uses MatlabControl library available at
    	// https://code.google.com/p/matlabcontrol/
    	// Prepare command
    	String inFullPath, outFullPath, command = null;
		try {
			inFullPath = new File(inPath).getCanonicalPath();
			outFullPath = new File(outPath).getCanonicalPath();
			command = String.format("recommend(%s, %d, '%s', '%s')",
					matlabRecommender,
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
