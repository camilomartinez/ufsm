classdef RecommendationEngine < handle
    %RECOMMENDATIONENGINE Generates recommendations for given inputs
    %   Manages recommendation workflow
    
    properties
        %Handle that returns a recommender given a data model
        RecommenderBuilder
    end
    
    properties (Access = private, Constant)
        FileFormat = '%s\\%s_%i.csv';
        RecFileName = 'recs';
        TrainFileName = 'train';
    end
    
    methods
        %Constructor
        function obj = RecommendationEngine(builder)
            obj.RecommenderBuilder = builder;
        end
        
        function recommendFolds(obj, nFolds, trainFolder, recommendationFolder)
            trainFilePath = obj.trainFilePathForFold(trainFolder, 1);
            dataModel = DataModel(trainFilePath);
            recommender = obj.RecommenderBuilder(dataModel);
            recommender.train();
            recommender.recommend();
            recFilePath = obj.recFilePathForFold(recommendationFolder, 1);
            dlmwrite(recFilePath, recommender.Recommendations, '\t');
        end
    end
    
    methods(Access = private)
        function path = trainFilePathForFold(obj, trainFolder, i)
            path = sprintf(obj.FileFormat,...
                trainFolder, obj.TrainFileName, i-1);
        end
        
        function path = recFilePathForFold(obj, recFolder, i)
            path = sprintf(obj.FileFormat,...
                recFolder, obj.RecFileName, i-1);
        end
    end
end

