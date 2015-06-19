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
            for iFold = 1:nFolds
                trainFilePath = obj.trainFilePathForFold(trainFolder, iFold);
                dataModel = DataModel(trainFilePath);
                if obj.IsContentBased
                    recommender = obj.RecommenderBuilder(dataModel, contentModel);
                else
                    recommender = obj.RecommenderBuilder(dataModel);
                end
                recommender.train();
                % Save times for benchmark
                obj.TrainingTimePerFold(iFold) = recommender.TrainingTime;
                recommender.recommend();
                % Save times for benchmark
                obj.RecommendationTimePerFold(iFold) =...
                    recommender.RecommendationTime;
                recFilePath = obj.recFilePathForFold(recommendationFolder, iFold);
                tic;
                dlmwrite(recFilePath, recommender.Recommendations,...
                    'precision','%g','delimiter','\t');
                obj.WritingTimePerFold(iFold) = toc;
            end
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

