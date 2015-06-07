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

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
	builder = @PopularRecommender;
    engine = RecommendationEngine(builder);    
    testCase.TestData.engine = engine;
end

