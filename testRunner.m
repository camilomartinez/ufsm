%% Initialization
clear;
clc;
%% Setup
% Make sure needed files are on path
rootPath = 'C:\Code\Polimi\thesis\Matlab\';
addpath(genpath(fullfile(rootPath,'model')));
addpath(genpath(fullfile(rootPath,'utils')));
addpath(genpath(fullfile(rootPath,'test')));
%% Run test suite
results = runtests('test','Recursively',true);
table(results)