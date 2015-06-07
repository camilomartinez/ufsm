classdef RecommendationEngine
    %RECOMMENDATIONENGINE Generates recommendations for given inputs
    %   Manages recommendation workflow
    
    properties
        %Handle that returns a recommender given a data model
        RecommenderBuilder
    end
    
    methods
        %Constructor
        function obj = RecommendationEngine(builder)
            obj.RecommenderBuilder = builder;
        end
        
        function recommendFolds(nFolds, trainFolder, recommendationFolder)
            
        end
    end
    
end

