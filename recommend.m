function recommend( recommender, nFolds, inPath, outPath)
%RECOMMEND Wrapper function to call implemented recommenders
%   recommender should be the recommender constructor to use
%   nFolds how many folds are being evaluated
%   inPath Folder where the input files are located
%   outPath Folder where recommendation files will be written
%% Setup
% Make sure needed files are on path
rootPath = 'C:\Code\Polimi\thesis\Matlab\';
addpath(genpath(fullfile(rootPath,'model')));
addpath(genpath(fullfile(rootPath,'utils')));
%% Complete recommendations
engine = RecommendationEngine(recommender);
disp(inPath);
disp(outPath);
engine.recommendFolds(nFolds, inPath, outPath);
end

