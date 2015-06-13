classdef RecommendationEngine < handle
    %RECOMMENDATIONENGINE Generates recommendations for given inputs
    %   Manages recommendation workflow
    
    properties
        %Handle that returns a recommender given a data model
        RecommenderBuilder
        %Benchmark times
        TrainingTimePerFold
        RecommendationTimePerFold        
        WritingTimePerFold
    end
    
    properties (Access = private, Constant)
        FileFormat = '%s_%i.csv';
        RecFileName = 'recs';
        TrainFileName = 'train';
    end
    
    methods
        %Constructor
        function obj = RecommendationEngine(builder)
            obj.RecommenderBuilder = builder;
        end
        
        function recommendFolds(obj, nFolds, trainFolder, recommendationFolder)
            obj.TrainingTimePerFold = zeros(1,nFolds);
            obj.RecommendationTimePerFold = zeros(1,nFolds);
            obj.WritingTimePerFold = zeros(1,nFolds);
            % Make sure the output folder exists
            if ~isequal(exist(recommendationFolder, 'dir'),7)
                mkdir(recommendationFolder);
            end
            for iFold = 1:nFolds
                trainFilePath = obj.trainFilePathForFold(trainFolder, iFold);
                dataModel = DataModel(trainFilePath);
                recommender = obj.RecommenderBuilder(dataModel);
                recommender.train();
                % Save times for benchmark
                obj.TrainingTimePerFold(iFold) = recommender.TrainingTime;
                recommender.recommend();
                % Save times for benchmark
                obj.RecommendationTimePerFold(iFold) =...
                    recommender.RecommendationTime;
                recFilePath = obj.recFilePathForFold(recommendationFolder, iFold);
                tic;
                dlmwrite(recFilePath, recommender.Recommendations, '\t');
                obj.WritingTimePerFold(iFold) = toc;
            end
        end
    end
    
    methods(Access = private)
        function path = trainFilePathForFold(obj, trainFolder, i)
            fileName = sprintf(obj.FileFormat, obj.TrainFileName, i-1);
            path = fullfile(trainFolder, fileName);
        end
        
        function path = recFilePathForFold(obj, recFolder, i)
            fileName = sprintf(obj.FileFormat, obj.RecFileName, i-1);
            path = fullfile(recFolder, fileName);
        end
    end
end

