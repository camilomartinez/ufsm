%% Main function to generate tests
function tests = RecommendationEngineTest
tests = functiontests(localfunctions);
end

%% Test Functions
function builderTest(testCase)
    engine = testCase.TestData.engine;
    testMatrix = [1 1 1];
    dataModel = DataModel();
    dataModel.Urm = spconvert(testMatrix);
    recommender = engine.RecommenderBuilder(dataModel);
    testCase.verifyInstanceOf(recommender, ?Recommender);
end

function recommendFoldsTest(testCase)
    engine = testCase.TestData.engine;
    recFolder = testCase.TestData.recommendationFolder;
    engine.recommendFolds(1,...
        testCase.TestData.trainFolder, recFolder);
    recFilePath = strcat(recFolder,'\recs_0.csv');
    % Use java as interface is simpler
    % returns bool coded as 1 if true
    recFileExists = java.io.File(recFilePath).exists() == 1;
    testCase.verifyTrue(recFileExists,...
        'The recommendation file is not generated');
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    sampleDataFolder = 'C:\Code\Polimi\thesis\Matlab\data\rivalsample\';
	testCase.TestData.trainFolder = strcat(sampleDataFolder, 'model');
    testCase.TestData.recommendationFolder =...
        strcat(sampleDataFolder, 'recommendations');
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
	builder = @PopularRecommender;
    engine = RecommendationEngine(builder);    
    testCase.TestData.engine = engine;
    % Clear recommendation files if any
    filesToDelete = strcat(testCase.TestData.recommendationFolder,...
        '\recs_*.csv');
    delete(filesToDelete);
end

