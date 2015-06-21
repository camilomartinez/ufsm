%% Setup
clear;
clc;
%% Test files
nFolds = 5;
nRecommendationsPerUser = 10;
sampleDataFolder = 'C:\Code\Polimi\thesis\Matlab\evaluation\data\ml-hr\';
trainFolder = strcat(sampleDataFolder, 'model');
recFolder = strcat(sampleDataFolder, 'recommendations');
filesToDelete = strcat(recFolder,'\recs_*.csv');
delete(filesToDelete);
%% Recommendation benchmark
disp('-----------Starting benchmark----------')
% Activate profiling to record function calls
profile on
% Generate recommendations for all five folds, 100 per user
engine = recommend( @CoSimRecommender, nFolds,...
    trainFolder, recFolder, nRecommendationsPerUser);
% Display UI
profile viewer
p = profile('info');
% Save results to avoid losing them
profsave(p,'profile_results')
disp('-----------Results per fold----------')
disp('Training time per fold:')
disp(engine.TrainingTimePerFold)
disp('Recommendation time per fold:')
disp(engine.RecommendationTimePerFold)
disp('Writing time per fold:')
disp(engine.WritingTimePerFold)
meanStats = sum([...
    engine.TrainingTimePerFold',...
    engine.RecommendationTimePerFold',...
    engine.WritingTimePerFold']);
disp('-----------Summary----------')
fprintf('Total training time %g (%4.2f%%)\n',meanStats(1),100*meanStats(1)/engine.RecommendFoldsTime)
fprintf('Total recommendation time %g (%4.2f%%)\n',meanStats(2),100*meanStats(2)/engine.RecommendFoldsTime)
fprintf('Total writing time %g (%4.2f%%)\n',meanStats(3),100*meanStats(3)/engine.RecommendFoldsTime)
fprintf('Total execution time %g\n',engine.RecommendFoldsTime)