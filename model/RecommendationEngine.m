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
    end
    
    properties (Access = private, Constant)
        FileFormat = '%s_%i.csv';
        RecFileName = 'recs';
        TrainFileName = 'train';
        ContentFileName = 'icm';
    end
    
    methods
        %Constructor
        function obj = RecommendationEngine(builder)
            obj.RecommenderBuilder = builder;
            % Does the builder requires two input arguments
            obj.IsContentBased = nargin(builder) == 2;
        end
        
        function recommendFolds(obj, nFolds, trainFolder, recommendationFolder)
            disp('Starting recommendFolds')
            recommendFoldsTime = tic;
            obj.TrainingTimePerFold = zeros(1,nFolds);
            obj.RecommendationTimePerFold = zeros(1,nFolds);
            obj.WritingTimePerFold = zeros(1,nFolds);
            % Make sure the output folder exists
            if ~isequal(exist(recommendationFolder, 'dir'),7)
                mkdir(recommendationFolder);
            end
            % Create content model if required
            if obj.IsContentBased
                contentFilePath = obj.contentFilePath(trainFolder);
                contentModel = ContentModel(contentFilePath);
            end
            disp('Content model created')
            for iFold = 1:nFolds
                fprintf('Fold %d: Starting\n', iFold)
                trainFilePath = obj.trainFilePathForFold(trainFolder, iFold);
                dataModel = DataModel(trainFilePath);
                fprintf('Fold %d: Data model created\n', iFold)
                if obj.IsContentBased
                    recommender = obj.RecommenderBuilder(dataModel, contentModel);
                else
                    recommender = obj.RecommenderBuilder(dataModel);
                end
                fprintf('Fold %d: Recommender created\n', iFold)
                recommender.train();
                % Save times for benchmark
                trainingTime = recommender.TrainingTime;
                obj.TrainingTimePerFold(iFold) = trainingTime;
                fprintf('Fold %d: Recommender trained in %g s.\n',...
                    iFold, trainingTime)
                recommender.recommend();
                % Save times for benchmark
                recommendationTime = recommender.RecommendationTime;
                obj.RecommendationTimePerFold(iFold) = recommendationTime;
                fprintf('Fold %d: Recommendations done in %g s.\n',...
                    iFold, recommendationTime)
                recFilePath = obj.recFilePathForFold(recommendationFolder, iFold);
                tic;
                dlmwrite(recFilePath, recommender.Recommendations,...
                    'precision','%g','delimiter','\t');
                writingTime = toc;
                obj.WritingTimePerFold(iFold) = writingTime;
                fprintf('Fold %d: Recommendations written in %g s.\n',...
                    iFold, writingTime)
            end
            totalTime = toc(recommendFoldsTime);
            obj.RecommendFoldsTime = totalTime;
            fprintf('All folds completed in %g s.\n', totalTime)
        end
    end
    
    methods(Access = private)
        function path = trainFilePathForFold(obj, trainFolder, i)
            fileName = sprintf(obj.FileFormat, obj.TrainFileName, i-1);
            path = fullfile(trainFolder, fileName);
        end
        
        function path = contentFilePath(obj, trainFolder)
            % Check if file is .mat
            datFile = fullfile(trainFolder,...
                sprintf('%s.dat', obj.ContentFileName));
            if isequal(exist(datFile, 'file'),2)
                path = datFile;
            else
                path = fullfile(trainFolder,...
                    sprintf('%s.mat', obj.ContentFileName));
            end
        end
        
        function path = recFilePathForFold(obj, recFolder, i)
            fileName = sprintf(obj.FileFormat, obj.RecFileName, i-1);
            path = fullfile(recFolder, fileName);
        end 
    end
end

