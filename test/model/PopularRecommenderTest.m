%% Main function to generate tests
function tests = PopularRecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function trainItemCountTest(testCase)
    recommender = testCase.TestData.recommender;
    actual = recommender.ItemCount;
    expected = [ 2 2; 1 1; 3 1 ];
    testCase.verifyEqual(actual, expected,...
        'The item count is not correct after training');
end

function recommend1Test(testCase)
    recommender = testCase.TestData.recommender;
    actual = recommender.recommendForUser(1);
    expected = [ 3 1 ];
    testCase.verifyEqual(actual, expected,...
        'The items recommended are not correct');
end

function recommend2Test(testCase)
    recommender = testCase.TestData.recommender;
    actual = recommender.recommendForUser(2);
    expected = [ 1 1; 3 1 ];
    testCase.verifyEqual(actual, expected,...
        'The items recommended are not correct');
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
    recommender.train();    
    testCase.TestData.recommender = recommender;
end