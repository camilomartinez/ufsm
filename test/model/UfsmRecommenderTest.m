%% Main function to generate tests
function tests = UfsmRecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function lossFunctionTest(testCase)
    recommender = testCase.TestData.recommender;
    % As rating for item 1 is 0 it doesn't appear
    expected = 1;
    testCase.verifyEqual(recommender.lossFunction([],[]), expected,...
        'The computed cost is incorrect');
end

function positiveFeedbackFromUser1Test(testCase)
    recommender = testCase.TestData.recommender;
    % User expressed positive feedback only for 2
    userId = 1;
    expected = 2;
    testCase.verifyEqual(recommender.positiveFeedbackFromUser(userId), expected,...
        'The items with positive feedback do not match');
end

function positiveFeedbackFromUser2Test(testCase)
    recommender = testCase.TestData.recommender;
    userId = 2;
    % Items with positive feedback from the user
    expected = [2 3];
    testCase.verifyEqual(recommender.positiveFeedbackFromUser(userId), expected,...
        'The items with positive feedback do not match');
end

function positiveFeedbackFromUser3Test(testCase)
    recommender = testCase.TestData.recommender;
    userId = 4;
    % Items with positive feedback from the user
    expected = 3;
    testCase.verifyEqual(recommender.positiveFeedbackFromUser(userId), expected,...
        'The items with positive feedback do not match');
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    dataModel = DataModel();
    urm = [
        1   1   1
        1   2   5
        2   2   4
        2   3   5
        4   3   4
    ];
    dataModel.Urm = spconvert(urm);
    contentModel = ContentModel();
    % Icm full matrix
    %    0   0.5
    %    1   0
    %    2.7 0
    icm = [
        2   1   1
        3   1   2.7
        1   2   0.5
    ];
    contentModel.Icm = spconvert(icm);
    recommender = UfsmRecommender(dataModel, contentModel);
    recommender.train();    
    testCase.TestData.recommender = recommender;
end

