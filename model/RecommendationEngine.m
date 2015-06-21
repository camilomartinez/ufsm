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
        % Number of recommendations lines
        % buffered before writing
        % Resulting matrix occupies
        % 8 x 3 x n =~ 24 MB
        WriteEachNumLines = 1000000;
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
        
        function recommendFolds(obj, nFolds, nRecommendationsPerUser)
            if nargin <= 2
                % Default
                nRecommendationsPerUser = 100;
            end
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
                disp('Content model created')
            end
            for iFold = 1:nFolds
                obj.recommendFold(iFold, nRecommendationsPerUser);
            end
            totalTime = toc(recommendFoldsTime);
            obj.RecommendFoldsTime = totalTime;
            fprintf('All folds completed in %g s.\n', totalTime)
        end
    end
    
    methods(Access = private)
        function recommendFold(obj, iFold, nRecommendationsPerUser)
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
            writeRecommendations(obj, recommender, iFold, nRecommendationsPerUser)
        end
        
        function writeRecommendations(obj, recommender, iFold, nRecommendationsPerUser)
            dataModel = recommender.DataModel;
            recFilePath = obj.recFilePathForFold(iFold);
            recommendationTime = 0;
            writingTime = 0;
            nextLine = 1;
            writeEachNumLines = obj.WriteEachNumLines;
            allRecommendations = zeros(writeEachNumLines, 3);
            recommendationsBuffer = [];
            firstWrite = true;
            % Recommend
            for i = 1:dataModel.NumUsers
                recStopwatch = tic;
                % Process previous iteration data
                if ~isempty(recommendationsBuffer)
                    nRecommendations = size(recommendationsBuffer,1);
                    allRecommendations(1:nRecommendations, :) = ...
                        recommendationsBuffer;
                    recommendationsBuffer = [];
                    nextLine = nRecommendations + 1;
                end
                % Get current user recommendations
                userId = dataModel.Users(i);
                recommendations = recommender.recommendForUser(userId, nRecommendationsPerUser);
                nRecommendations = size(recommendations,1);
                %Recommendations for this user
                %The first column is the user id
                userRecommendations = ...
                    [repmat(userId, nRecommendations,1) recommendations];
                % Where to fit the current recommendations lines
                finishLine = nextLine+nRecommendations-1;
                if finishLine > writeEachNumLines
                    lineRange = nextLine:writeEachNumLines;
                    remaining = finishLine - writeEachNumLines;
                    keepTillIndex = nRecommendations - remaining;
                    allRecommendations(lineRange,:) = ...
                        userRecommendations(1:keepTillIndex,:);
                    remainingRange = (keepTillIndex+1):nRecommendations;
                    recommendationsBuffer = ...
                        userRecommendations(remainingRange,:);
                    nextLine = finishLine + 1;
                else
                    lineRange = nextLine:finishLine;
                    allRecommendations(lineRange,:) = userRecommendations;
                    nextLine = finishLine + 1;    
                end
                % Accumulate recommendation time
                recommendationTime = recommendationTime + toc(recStopwatch);
                writeStopwatch = tic;
                % Check if we need to flush
                if finishLine >= writeEachNumLines 
                    fprintf('Fold %d: Flushing recommendations. Progress %4.2f%%\n',...
                        iFold, 100*i/dataModel.NumUsers)
                    obj.writeMatrix(recFilePath,allRecommendations,~firstWrite)
                    firstWrite = false;
                    % Matrix flushed
                    nextLine = 1;
                end
                isLastUser = i == dataModel.NumUsers;
                if isLastUser
                    %Write any pending recommendations only if not done
                    alreadyWritten = finishLine >= writeEachNumLines;                    
                    if ~alreadyWritten
                        obj.writeMatrix(recFilePath,...
                            allRecommendations(1:finishLine,:),~firstWrite)
                    end
                    %Don't leave buffer unwritten
                    obj.writeMatrix(recFilePath,recommendationsBuffer,true)
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
        
        function writeMatrix(~, filepath, recommendations, useAppend)
            if useAppend
                dlmwrite(filepath, recommendations,...
                    'precision','%g','delimiter','\t', '-append');
            else
                dlmwrite(filepath, recommendations,...
                    'precision','%g','delimiter','\t');
            end
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

