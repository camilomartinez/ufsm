classdef Recommender < handle
    %RECOMMENDER Base for providing recommendations for users
    %   Detailed explanation goes here
    
    properties
        DataModel
    end
    
    properties (SetAccess = private)
        TrainTime
    end
    
    methods
        %Constructor
        function obj = Recommender(dataModel)
            obj.DataModel = dataModel;
        end
        
        %Wrap train method
        function train(obj)
            tic;
            obj.trainModel();
            obj.TrainTime = toc;
        end
    end
    
    methods (Abstract)
        % Allow the recommender to train its internal model
        trainModel(obj)
        % Generate recommendations for the given user
        itemsWithScore = recommendForUser(obj, userId)
    end
    
end

