%% Test1: count of lines of a delimited file
% setup
testFile = 'test_0.csv';

% preconditions
assert(exist(testFile,'file')==2, 'Test file does not exist')

testFilePath = which(testFile);
numlines = countLines(testFilePath);
correct = 20000;
assert(numlines == 20000, sprintf('The number of lines of the test file is %i not %i', correct, numlines))
