classdef ContentBasedRecommender < Recommender
    %CONTENTBASEDRECOMMENDER Uses additional side information content
    %   to produce recommendations
    
    properties
        ContentModel
    end
    
    methods
        %Constructor
        function obj = ContentBasedRecommender(dataModel, contentModel)
            obj@Recommender(dataModel);
            obj.ContentModel = contentModel;
        end
    end
    
end

