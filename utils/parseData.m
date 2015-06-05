function [ urm ] = parseData( filename, delimiter )
%PARSEDATA Parse a user item rating delimited file to a sparse matrix
%   by using dlmread and spconvert
%   based in load_data from competition_evaluation
numlines = countLines(filename);
%read the delimited file for the urm file
urm_input = dlmread(filename, delimiter, [0,0,numlines-1,2]);
%convert the (row, col, rating) format into sparse matrix
urm = spconvert(urm_input);
end

