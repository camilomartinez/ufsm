%% Main function to generate tests
function tests = RecommendationEngineTest
tests = functiontests(localfunctions);
end

%% Test Functions
function recommendFoldsTest(testCase)
    engine = testCase.TestData.engine;
    recFolder = testCase.TestData.recommendationFolder;
    engine.recommendFolds(2, 100);
    % Verify all recommendations files are created
    for i=1:2
        recFilePath = sprintf('%s\\recs_%i.csv',recFolder,i-1);
        % Use java as interface is simpler
        % returns bool coded as 1 if true
        recFileExists = java.io.File(recFilePath).exists() == 1;
        testCase.verifyTrue(recFileExists,...
            sprintf('The recommendation file %i was not generated', i));
    end
end

function isContentBasedFalseTest(testCase)
    builder = @PopularRecommender;
    engine = RecommendationEngine(builder,...
        testCase.TestData.trainFolder,...
        testCase.TestData.recommendationFolder);    
    testCase.verifyFalse(engine.IsContentBased,...
        'Popular recommender is not content based')
end

function isContentBasedTrueTest(testCase)
    builder = @CoSimRecommender;
    engine = RecommendationEngine(builder,...
        testCase.TestData.trainFolder,...
        testCase.TestData.recommendationFolder);    
    testCase.verifyTrue(engine.IsContentBased,...
        'Cosine similarity recommender is content based')
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    sampleDataFolder = 'C:\Code\Polimi\thesis\Matlab\test\data\';
	testCase.TestData.trainFolder = strcat(sampleDataFolder, 'model');
    testCase.TestData.recommendationFolder =...
        strcat(sampleDataFolder, 'recommendations');
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
	builder = @PopularRecommender;
    engine = RecommendationEngine(builder,...
        testCase.TestData.trainFolder,...
        testCase.TestData.recommendationFolder);    
    testCase.TestData.engine = engine;
    % Clear recommendation files if any
    filesToDelete = strcat(testCase.TestData.recommendationFolder,...
        '\recs_*.csv');
    delete(filesToDelete);
end

