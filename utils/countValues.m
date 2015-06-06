function [ valueCount ] = countValues( values )
%COUNTVALUES Gives a matrix with the frequency of each value in the input
%   Firt column is the list of unique values ordered by the corresponding
%   count in the second column
    % On empty input, empty output
    if isempty(values)
        valueCount = [];
        return
    end
    % Non empty input
    uniqueValues = unique(values);
    count = histc(values, uniqueValues);
    % Sort the values obtained by count in descending order
    valueCount = sortrows([ uniqueValues', count' ], -2);
end

