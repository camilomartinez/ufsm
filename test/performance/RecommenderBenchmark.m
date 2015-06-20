%% Setup
clear;
clc;
%% Test files
sampleDataFolder = 'C:\Code\Polimi\thesis\Matlab\evaluation\data\netflix\';
trainFolder = strcat(sampleDataFolder, 'model');
recFolder = strcat(sampleDataFolder, 'recommendations');
filesToDelete = strcat(recFolder,'\recs_*.csv');
delete(filesToDelete);
%% Recommendation benchmark
engine = RecommendationEngine(@CoSimRecommender);
engine.recommendFolds(5, trainFolder, recFolder);
disp('Training time per fold:')
disp(engine.TrainingTimePerFold)
disp('Recommendation time per fold:')
disp(engine.RecommendationTimePerFold)
disp('Writing time per fold:')
disp(engine.WritingTimePerFold)
disp('Baseline CoSimRecommender')
meanStats = sum([...
    engine.TrainingTimePerFold',...
    engine.RecommendationTimePerFold',...
    engine.WritingTimePerFold']);
fprintf(...
    'Avg. training time %g\nAvg. recommendation time %g\nAvg. writing time %g\n',...
    meanStats(1),meanStats(2),meanStats(3))