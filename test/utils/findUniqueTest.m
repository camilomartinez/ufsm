%% Main function to generate tests
function tests = findUniqueTest
tests = functiontests(localfunctions);
end

%% Test Functions
function correctUniqueCountTest(testCase)
    uniqueRows = findUnique(testCase.TestData.testMatrix, 1);
    verifyEqual(testCase,length(uniqueRows),3)
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    testMatrix = [ 
        1   1   1
        2   2   2
        3   3   3
        1   3   4
        2   1   5
        2   3   1
    ];
    testCase.TestData.testMatrix = spconvert(testMatrix);
end

function teardownOnce(testCase)  % do not change function name
% change back to original path, for example
end

%% Optional fresh fixtures  
function setup(testCase)  % do not change function name
% open a figure, for example
end

function teardown(testCase)  % do not change function name
% close figure, for example
end