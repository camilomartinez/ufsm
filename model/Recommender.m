classdef Recommender < handle
    %RECOMMENDER Base for providing recommendations for users
    %   Detailed explanation goes here
    
    properties
        DataModel
    end
    
    properties (SetAccess = private)
        TrainingTime
        RecommendationTime        
        %Recommendations
        %nUsers x 3 matrix with userId in column 1, itemId in column 2
        %and score in column 3. The items within each user are ordered by
        %score
        Recommendations
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
            obj.TrainingTime = toc;
        end
        
        function recommend(obj)
            tic;
            obj.Recommendations = [];
            for i = 1:obj.DataModel.NumUsers
                userId = obj.DataModel.Users(i);
                userRecommendations = obj.recommendForUser(userId);
                nRecommendations = size(userRecommendations,1);
                %Append the recommendations for this user
                %The first column is the user id
                obj.Recommendations = [obj.Recommendations;...
                    userId * ones(nRecommendations,1), userRecommendations];
            end
            obj.RecommendationTime = toc;
        end
    end
    
    methods (Abstract)
        % Allow the recommender to train its internal model
        trainModel(obj)
        % Generate recommendations for the given user
        itemsWithScore = recommendForUser(obj, userId)
    end
    
end

