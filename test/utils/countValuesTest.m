%% Main function to generate tests
function tests = countValuesTest
tests = functiontests(localfunctions);
end

%% Test Functions
function allDifferentCountTest(testCase)
    values = [1 3 2 3 2 3];
    expected = [ 3 3; 2 2; 1 1 ];
    actual = countValues(values);
    testCase.verifyEqual(actual, expected,...
        'The value count for different counts is not correct');
end

function singleValueTest(testCase)
    values = [10];
    expected = [ 10 1 ];
    actual = countValues(values);
    testCase.verifyEqual(actual, expected,...
        'The value count for a single value is not correct');
end

function emptyTest(testCase)
    values = [];
    expected = [];
    actual = countValues(values);
    testCase.verifyEqual(actual, expected,...
        'The value count for empty values is not correct');
end
