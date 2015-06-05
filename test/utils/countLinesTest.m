%% Test1: count of lines of a delimited file
% setup
testFile = 'test_0.csv';

% preconditions
assert(exist(testFile,'file')==2, 'Test file does not exist')

numlines = countLines(testFile);
correct = 20000;
assert(numlines == correct, sprintf('The number of lines of the test file is %i not %i', correct, numlines))
