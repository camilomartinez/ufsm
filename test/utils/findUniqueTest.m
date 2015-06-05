%% Main function to generate tests
function tests = findUniqueTest
tests = functiontests(localfunctions);
end

%% Test Functions
function correctUniqueCount1Test(testCase)
    uniqueRows = findUnique(testCase.TestData.testMatrix, 1);
    verifyEqual(testCase,length(uniqueRows),3)
end

function correctUniqueCount2Test(testCase)
    uniqueColumns = findUnique(testCase.TestData.testMatrix, 2);
    verifyEqual(testCase,length(uniqueColumns),2)
end

function correctUniqueCount3Test(testCase)
    uniqueValues = findUnique(testCase.TestData.testMatrix, 3);
    verifyEqual(testCase,length(uniqueValues),5)
end

function errorInputOutOfRange1Test(testCase)
    testCase.verifyError(@() findUnique(speye(3), 4),'findUnique:InputOutOfRange')
end

function errorInputOutOfRange2Test(testCase)
    testCase.verifyError(@() findUnique(speye(3), 0),'findUnique:InputOutOfRange')
end

function errorInputOutOfRange3Test(testCase)
    testCase.verifyError(@() findUnique(speye(3), -1),'findUnique:InputOutOfRange')
end

%% Optional file fixtures  
function setupOnce(testCase)  % do not change function name
    testMatrix = [ 
        1   1   1
        2   2   2
        3   1   3
        1   2   4
        2   1   5
        3   2   1
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