%% Main function to generate tests
function tests = CoSimRecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function trainModelTest(testCase)
	recommender = testCase.TestData.recommender;
    % Expected item to item similarities
    %expected = [
    %    1   0   0
    %    0   1   1
    %    0   1   1
    %];
    expected = spconvert([
        1   1   1
        2   2   1
        3   2   1
        2   3   1
        3   3   1
    ]);
    testCase.verifyEqual(recommender.ItemItemSimilarity, expected,...
        'Computed item item similarities are not correct');
end

function recommendForUser1Test(testCase)
    recommender = testCase.TestData.recommender;
    % As rating for item 1 is 0 it doesn't appear
    expected = [ 3 1 ];
    testCase.verifyEqual(recommender.recommendForUser(2), expected,...
        'The items recommended are not correct');
end

% Test when items in train are less than icm
function recommendForUser2Test(testCase)
    dataModel = DataModel();
    urm = [
        1   1   1
        1   7   2
        2   7   1
        4   4   4
    ];
    dataModel.Urm = spconvert(urm);
    contentModel = ContentModel();
    % Icm full matrix
    %    0   1   2.7
    %    0.5 0   0
    icm = [
        7   1   1
        4   1   2.7
        1   2   0.5
        3   2   0.2
        5   2   0.3
        6   1   0.4
        2   2   0.9
        8   1   1
    ];
    contentModel.Icm = spconvert(icm);
    recommender = CoSimRecommender(dataModel, contentModel);
    recommender.train();    
    testCase.TestData.recommender = recommender;
    recommender = testCase.TestData.recommender;
    % As rating for item 1 is 0 it doesn't appear
    expected = [ 4 1 ];
    testCase.verifyEqual(recommender.recommendForUser(2), expected,...
        'The items recommended are not correct');
end
%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    dataModel = DataModel();
    urm = [
        1   1   1
        1   2   2
        2   2   1
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
    recommender = CoSimRecommender(dataModel, contentModel);
    recommender.train();    
    testCase.TestData.recommender = recommender;
end

