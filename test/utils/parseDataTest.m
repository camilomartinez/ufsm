%% Test1: Test file parsing correctly done
% setup
testFile = 'test_0.csv';

% preconditions
assert(exist(testFile,'file')==2, 'Test file does not exist')

urm = parseData(testFile, '\t');
nPreferences = nnz(urm);
correct = nnz(urm);
assert(nPreferences == correct, sprintf('The number of preferences in the test file is %i not %i', correct, nPreferences))