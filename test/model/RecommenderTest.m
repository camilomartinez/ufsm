%% Main function to generate tests
function tests = RecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function trainTimeTest(testCase)
    recommender = testCase.TestData.recommender;
    testCase.verifyEmpty(recommender.TrainTime,...
        'The train time is not initially undefined');
    recommender.train();
    testCase.verifyGreaterThan(recommender.TrainTime,0,...
        'The train time was not measured');
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