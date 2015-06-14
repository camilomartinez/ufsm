%% Main function to generate tests
function tests = ContentModelTest
tests = functiontests(localfunctions);
end

%% Test Functions
function buildParameterlessTest(testCase)
    model = ContentModel();
    testCase.verifyClass(model, 'ContentModel');
end

function buildFromMatTest(testCase)
    model = ContentModel(testCase.TestData.testFile);
    testCase.verifyClass(model, 'ContentModel');
end 

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
	testCase.TestData.testFile = 'ICM_IDF.mat';
end

