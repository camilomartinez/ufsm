function [urm, testUsers] = load_data(urm_filename, test_filename, skip_header)
%LOAD_DATA function that imports a User Rating Matrix in the forma

%header is not skipped by default
row_start = 0;
if nargin > 2 %check for skip_header argument
    if skip_header ~= 0
        row_start = 1;
    end
end

%read the comma-delimited file for the urm file skipping the textual header
urm_input = dlmread(urm_filename, ',', row_start, 0);
%convert the (row, col, rating) format into sparse matrix
urm = spconvert(urm_input);
%then read the test users and keep it as a column vector
testUsers = dlmread(test_filename, ',', row_start, 0);
end