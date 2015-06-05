%% Main function to generate tests
function tests = DataModelTest
tests = functiontests(localfunctions);
end

%% Test Functions
function countPreferencesTest(testCase)
    dataModel = DataModel(testCase.TestData.testFile);
    correct = 20000;
    testCase.verifyEqual(dataModel.NumPreferences, correct, ...
        sprintf('The number of preferences in the test file is %i not %i',...
            correct, dataModel.NumPreferences))
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    testFile = 'test_0.csv';
    % preconditions
    assert(exist(testFile,'file')==2, 'Test file does not exist')
    testCase.TestData.testFile = testFile;
end