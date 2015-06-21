function engine = recommend( recommender, nFolds, inPath, outPath, nRecommendationsPerUser)
%RECOMMEND Wrapper function to call implemented recommenders
%   recommender should be the recommender constructor to use
%   nFolds how many folds are being evaluated
%   inPath Folder where the input files are located
%   outPath Folder where recommendation files will be written
%   nRecommendationsPerUser How many recommendations are generated for each
%   user
%   Return  the engine used for recommendations to extract time measures
%% Setup
if nargin <= 4
    % default
    nRecommendationsPerUser = 100;
end 
% Make sure needed files are on path
rootPath = 'C:\Code\Polimi\thesis\Matlab\';
addpath(genpath(fullfile(rootPath,'model')));
addpath(genpath(fullfile(rootPath,'utils')));
%% Complete recommendations
engine = RecommendationEngine(recommender, inPath, outPath);
disp(inPath);
disp(outPath);
engine.recommendFolds(nFolds, nRecommendationsPerUser);
end

