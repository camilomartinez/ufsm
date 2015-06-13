%% Setup
clear;
clc;
%% Test files
sampleDataFolder = 'C:\Code\Polimi\thesis\Matlab\data\rivalsample\';
trainFolder = strcat(sampleDataFolder, 'model');
recFolder = strcat(sampleDataFolder, 'recommendations');
filesToDelete = strcat(recFolder,'\recs_*.csv');
delete(filesToDelete);
%% Recommendation benchmark
engine = RecommendationEngine(@PopularRecommender);
engine.recommendFolds(1, trainFolder, recFolder);
disp(engine.TrainingTimePerFold)
disp(engine.RecommendationTimePerFold)
disp(engine.WritingTimePerFold)