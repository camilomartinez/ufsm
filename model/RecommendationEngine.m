classdef RecommendationEngine < handle
    %RECOMMENDATIONENGINE Generates recommendations for given inputs
    %   Manages recommendation workflow
    
    properties
        %Handle that returns a recommender given the arguments
        RecommenderBuilder
        %Whether the recommender is content based
        IsContentBased
        %Benchmark times
        TrainingTimePerFold
        RecommendationTimePerFold        
        WritingTimePerFold
        RecommendFoldsTime
        %Input output folders
        TrainFolder
        RecommendationFolder
    end
    
    properties (Access = private, Constant)
        FileFormat = '%s_%i.csv';
        RecFileName = 'recs';
        TrainFileName = 'train';
        ContentFileName = 'icm';
    end
    
    properties (Access = private)
        ContentModelCache
    end    
    
    methods
        %Constructor
        function obj = RecommendationEngine(builder, trainFolder,...
                recommendationFolder)
            obj.RecommenderBuilder = builder;
            obj.TrainFolder = trainFolder;
            obj.RecommendationFolder = recommendationFolder;
            % Does the builder requires two input arguments
            obj.IsContentBased = nargin(builder) == 2;
        end
        
        function recommendFolds(obj, nFolds)
            disp('Starting recommendFolds')
            recommendFoldsTime = tic;
            obj.TrainingTimePerFold = zeros(1,nFolds);
            obj.RecommendationTimePerFold = zeros(1,nFolds);
            obj.WritingTimePerFold = zeros(1,nFolds);
            % Make sure the output folder exists
            recommendationFolder = obj.RecommendationFolder;
            if ~isequal(exist(recommendationFolder, 'dir'),7)
                mkdir(recommendationFolder);
            end
            % Create content model if required
            if obj.IsContentBased
                contentFilePath = obj.contentFilePath();
                obj.ContentModelCache = ContentModel(contentFilePath);
            end
            disp('Content model created')
            for iFold = 1:nFolds
                obj.recommendFold(iFold);
            end
            totalTime = toc(recommendFoldsTime);
            obj.RecommendFoldsTime = totalTime;
            fprintf('All folds completed in %g s.\n', totalTime)
        end
    end
    
    methods(Access = private)
        function recommendFold(obj, iFold)
            fprintf('Fold %d: Starting\n', iFold)
            trainFilePath = obj.trainFilePathForFold(iFold);
            dataModel = DataModel(trainFilePath);
            fprintf('Fold %d: Data model created\n', iFold)
            if obj.IsContentBased
                recommender = obj.RecommenderBuilder(dataModel,...
                    obj.ContentModelCache);
            else
                recommender = obj.RecommenderBuilder(dataModel);
            end
            fprintf('Fold %d: Recommender created\n', iFold)
            % Train
            recommender.train();
            trainingTime = recommender.TrainingTime;
            obj.TrainingTimePerFold(iFold) = trainingTime;
            fprintf('Fold %d: Recommender trained in %g s.\n',...
                iFold, trainingTime)
            % Recommend
            writeRecommendations(obj, recommender, iFold)
        end
        
        function writeRecommendations(obj, recommender, iFold)
            dataModel = recommender.DataModel;
            recFilePath = obj.recFilePathForFold(iFold);
            recommendationTime = 0;
            writingTime = 0;
            writeEachNumLines = 10000;
            firstWrite = true;
            userRecommendations = [];
            % Recommend
            for i = 1:dataModel.NumUsers
                userId = dataModel.Users(i);
                recStopwatch = tic;
                recommendations = recommender.recommendForUser(userId);
                nRecommendations = size(recommendations,1);
                %Append the recommendations for this user
                %The first column is the user id
                userRecommendations =...
                    [userRecommendations;...
                    repmat(userId, nRecommendations,1) recommendations];
                % Accumulate recommendation time
                recommendationTime = recommendationTime + toc(recStopwatch);
                writeStopwatch = tic;
                nLines = size(userRecommendations,1);
                isLastUser = i == dataModel.NumUsers;
                if nLines > writeEachNumLines || isLastUser
                    if firstWrite
                        % Don't append for first user
                        dlmwrite(recFilePath, userRecommendations,...
                            'precision','%g','delimiter','\t');
                        firstWrite = false;
                    else
                        dlmwrite(recFilePath, userRecommendations,...
                        'precision','%g','delimiter','\t', '-append');                        
                    end
                    userRecommendations = [];
                end
                % Accumulate writing time
                writingTime = writingTime + toc(writeStopwatch);                
            end
            obj.RecommendationTimePerFold(iFold) = recommendationTime;
            fprintf('Fold %d: Recommendations done in %g s.\n',...
                iFold, recommendationTime)
            obj.WritingTimePerFold(iFold) = writingTime;
            fprintf('Fold %d: Recommendations written in %g s.\n',...
                iFold, writingTime)
        end
        
        function path = trainFilePathForFold(obj, i)
            fileName = sprintf(obj.FileFormat, obj.TrainFileName, i-1);
            path = fullfile(obj.TrainFolder, fileName);
        end
        
        function path = contentFilePath(obj)
            % Check if file is .mat
            datFile = fullfile(obj.TrainFolder,...
                sprintf('%s.dat', obj.ContentFileName));
            if isequal(exist(datFile, 'file'),2)
                path = datFile;
            else
                path = fullfile(obj.TrainFolder,...
                    sprintf('%s.mat', obj.ContentFileName));
            end
        end
        
        function path = recFilePathForFold(obj, i)
            fileName = sprintf(obj.FileFormat, obj.RecFileName, i-1);
            path = fullfile(obj.RecommendationFolder, fileName);
        end 
    end
end

