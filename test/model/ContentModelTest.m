%% Main function to generate tests
function tests = ContentModelTest
tests = functiontests(localfunctions);
end

%% Test Functions
function buildParameterlessTest(testCase)
    model = ContentModel();
    testCase.verifyClass(model, 'ContentModel',...
        'Content model was not build without parameters');
end

function buildFromMatTest(testCase)
    model = ContentModel(testCase.TestData.testFile);
    testCase.verifyClass(model, 'ContentModel',...
        'Content model was not build from a file');
end

function icmTest(testCase)
    icm = testCase.TestData.contentModel.Icm;
    testCase.verifyTrue(issparse(icm),...
        'The item content matrix is not assigned as sparse');
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
	testCase.TestData.testFile = 'ICM_IDF.mat';
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
    model = ContentModel(testCase.TestData.testFile);
    testCase.TestData.contentModel = model;
end
