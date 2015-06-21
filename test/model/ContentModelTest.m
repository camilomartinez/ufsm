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
        'Content model was not build from a .mat file');
end

function buildFromDatTest(testCase)
    testFile = 'icm.dat';
    model = ContentModel(testFile);
    testCase.verifyClass(model, 'ContentModel',...
        'Content model was not build from a .dat file');
end

function icmTest(testCase)
    icm = testCase.TestData.contentModel.Icm;
    testCase.verifyTrue(issparse(icm),...
        'The item content matrix is not assigned as sparse');
end

function icmFromDatTest(testCase)
    testFile = 'icm.dat';
    model = ContentModel(testFile);
    expected = spconvert([
        1	2	1
        1	3	1
        1	4	1
        1	5	1
        1	9	1
        2	2	1
        2	4	1
        2	9	1
        3	5	1
    ]);
    testCase.verifyEqual(model.Icm, expected,...
        'Item content matrix not load correctly from .dat file');
end

function numFeaturesTest(testCase)
    model = ContentModel();
    % Full icm matrix
    %    0   1   0
    %    1   0   0        
    icm = sparse([1 2], [2 1], [1 1], 2, 3);
    model.Icm = icm;
    testCase.verifyEqual(model.NumFeatures, 3,...
        'Incorrect number of features');
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
