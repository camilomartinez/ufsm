classdef Recommender < handle
    %RECOMMENDER Base for providing recommendations for users
    %   Detailed explanation goes here
    
    properties
        DataModel
    end
    
    methods
        %Constructor
        function obj = Recommender(dataModel)
            obj.DataModel = dataModel;
        end
    end
    
    methods (Abstract)
        % Allow the recommender to train its internal model
        train(obj)
        % Generate recommendations for the given user
        itemsWithScore = recommendForUser(obj, userId)
    end
    
end

