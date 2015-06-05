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

function correctUniqueElements1Test(testCase)
    actual = findUnique(testCase.TestData.testMatrix, 1);
    expected = [1; 2; 3];
    verifyEqual(testCase,actual,expected)
end

function correctUniqueElements2Test(testCase)
    actual = findUnique(testCase.TestData.testMatrix, 2);
    expected = [1; 9];
    verifyEqual(testCase,actual,expected)
end

function correctUniqueElements3Test(testCase)
    actual = findUnique(testCase.TestData.testMatrix, 3);
    expected = [1; 2; 3; 5; 6];
    verifyEqual(testCase,actual,expected)
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
        2   9   2
        3   1   3
        1   9   6
        2   1   5
        3   9   1
    ];
    testCase.TestData.testMatrix = spconvert(testMatrix);
end