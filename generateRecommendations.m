%% Setup
clear;
clc;
addpath(genpath('C:\Code\Polimi\thesis\Matlab\model'));
addpath(genpath('C:\Code\Polimi\thesis\Matlab\utils'));
%% Test files
dataFolder = 'C:\Code\Polimi\thesis\rival\rival-examples\data\ml-100k\';
trainFolder = strcat(dataFolder, 'model');
recFolder = strcat(dataFolder, 'recommendations');
filesToDelete = strcat(recFolder,'\recs_*.csv');
delete(filesToDelete);
%% Recommendation benchmark
engine = RecommendationEngine(@PopularRecommender);
engine.recommendFolds(5, trainFolder, recFolder);
disp(engine.TrainingTimePerFold)
disp(engine.RecommendationTimePerFold)
disp(engine.WritingTimePerFold)