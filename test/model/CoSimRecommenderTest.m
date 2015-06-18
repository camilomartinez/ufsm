%% Main function to generate tests
function tests = CoSimRecommenderTest
tests = functiontests(localfunctions);
end

%% Test Functions
function trainModelTest(testCase)
	recommender = testCase.TestData.recommender;
    % Expected item to item similarities
    expected = [
        1   0   0
        0   1   1
        0   1   1
    ];
    testCase.verifyEqual(recommender.ItemItemSimilarity, expected,...
        'Computed item item similarities are not correct');
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
    %    0   1   2.7
    %    0.5 0   0
    icm = [
        1   2   1
        1   3   2.7
        2   1   0.5
    ];
    contentModel.Icm = spconvert(icm);
    recommender = CoSimRecommender(dataModel, contentModel);
    recommender.train();    
    testCase.TestData.recommender = recommender;
end

