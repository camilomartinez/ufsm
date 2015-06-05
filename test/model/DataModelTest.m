%% Test1: count of lines of a delimited file
% setup
testFile = 'test_0.csv';

% preconditions
assert(exist(testFile,'file')==2, 'Test file does not exist')

dataModel = DataModel(testFile);
correct = 20000;
assert(dataModel.NumPreferences == correct, sprintf('The number of preferences in the test file is %i not %i', correct, dataModel.NumPreferences))