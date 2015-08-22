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

function estimatedRating1Test(testCase)
    recommender = testCase.TestData.recommender;
    % nu x L; nu = 4, L = 3
    M = zeros(4,3);
    % L x nf; nf = 2
    W = zeros(3,2);
    userId = 1;
    itemId = 3;
    % Expected rating
    expected = 0;
    testCase.verifyEqual(recommender.estimatedRating(userId, itemId, M, W), expected,...
        'The estimated rating formula is not size-consistent');
end

function estimatedRating2Test(testCase)
    recommender = testCase.TestData.recommender;
    M = testCase.TestData.M;
    W = testCase.TestData.W;
    userId = 1;
    itemId = 3;
    % Expected rating
    expected = 0.4960;
    testCase.verifyEqual(recommender.estimatedRating(userId, itemId, M, W), expected,...
        'The estimated rating is incorrect');
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    % Used for estimating rating
    % nu x L; nu = 4, L = 3
    M = [
        0.1     0.2     0.7
        1       0       0
        0.3     0.2     0.5
        0       0.7     0.5
	];
    % L x nf; nf = 2
    testCase.TestData.M = M;
    W = [
        1   0
        0   1
        0.8 0.6
	];
    testCase.TestData.W = W;
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
    %    0.8    0.6
    %    0      1
    %    0.6    0.8
    icm = [
        1   1   0.8
        1   2   0.6
        2   2   1
        3   1   0.6
        3   2   0.8
    ];
    contentModel.Icm = spconvert(icm);
    recommender = UfsmRecommender(dataModel, contentModel);
    recommender.train();    
    testCase.TestData.recommender = recommender;
end

