%% Initialization
clear;
clc;
if ~(exist('data','dir'))
    addpath('data');
end
%% Load data
if ~(exist('icm_idf','var'))
    load('data\ICM_IDF.mat');
end
if ~(exist('urm','var'))
    load('data\urm.mat');
end

%% Check URM
clc
disp('URM')
[rows,columns,values] = find(urm);

disp('First ten values')
for i = 1:10
    fprintf('%i, %i, %.2f\n', rows(i), columns(i), values(i));
end

[nu, ni] = size(urm);
fprintf('Number of users: %i\n', nu);
fprintf('Number of items: %i\n', ni);
nr = nnz(urm);
fprintf('Number of ratings: %i\n', nr);
urmEntries = nu * ni;
density = (nr / urmEntries) *100;
fprintf('Density: %.2f %%\n', density);
