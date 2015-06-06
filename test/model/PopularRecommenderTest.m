%% Main function to generate tests
function tests = PopularRecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function trainItemCountTest(testCase)
    recommender = testCase.TestData.recommender;
    recommender.train();
    actual = recommender.ItemCount;
    expected = [ 2 2; 1 1; 3 1 ];
    testCase.verifyEqual(actual, expected,...
        'The item count is not correct after training');
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    dataModel = DataModel();
    testMatrix = [
        1   1   1
        1   2   2
        2   2   1
        4   3   4
    ];
    dataModel.Urm = spconvert(testMatrix);
    recommender = PopularRecommender(dataModel);
    testCase.TestData.recommender = recommender;
end