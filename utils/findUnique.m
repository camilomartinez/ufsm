function [ uniqueIndices ] = findUnique( sparseMatrix, dim )
%FINDUNIQUE Return the unique indices of a sparse matrix on a given
%dimension
%   Dimension should be between 1 and 3
[i, j, v] = find( sparseMatrix );
switch dim
    case 1
       indices = i;
    case 2
       indices = j;
    case 3
       indices = v;
    otherwise
       error('findUnique:InputOutOfRange',...
           'Dimension %i is not between 1 and 3',dim);
end
uniqueIndices = unique(indices);
end

