%% Main function to generate tests
function tests = RecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function trainingTimeTest(testCase)
    recommender = testCase.TestData.recommender;
    testCase.verifyEmpty(recommender.TrainingTime,...
        'The training time is not initially undefined');
    recommender.train();
    testCase.verifyGreaterThan(recommender.TrainingTime,0,...
        'The training time was not measured');
end

function recommendationTimeTest(testCase)
    recommender = testCase.TestData.recommender;
    recommender.train();    
    testCase.verifyEmpty(recommender.RecommendationTime,...
        'The recommendation time is not initially undefined');
    recommender.recommend();
    testCase.verifyGreaterThan(recommender.RecommendationTime,0,...
        'The recommendation time was not measured');
end

function recommendationsTest(testCase)
    recommender = testCase.TestData.recommender;
    recommender.train();    
    testCase.verifyEmpty(recommender.Recommendations,...
        'The recommendations are not initially undefined');
    recommender.recommend();
    testCase.verifyNotEmpty(recommender.Recommendations,...
        'The recommendations are not done');
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    dataModel = DataModel();
    testMatrix = [
        1   1   1
        1   2   2
        2   2   1
        3   3   4
    ];
    dataModel.Urm = spconvert(testMatrix);
    recommender = PopularRecommender(dataModel);
    testCase.TestData.recommender = recommender;
end