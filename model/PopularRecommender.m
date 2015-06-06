classdef PopularRecommender < Recommender
    %POPULARRECOMMENDER Suggest the most popular items not seen by the
    %user
    %   Popularity is measured by counting how many times the items has
    %   been seen
    
    properties
        ItemCount
    end
    
    methods
        %Constructor
        function obj = PopularRecommender(dataModel)
            obj@Recommender(dataModel);
        end
        
        % Allow the recommender to train its internal model
        function train(obj)
            urm = obj.DataModel.Urm;
            [~, seenItems, ~] = find(urm);
            % countValues expects a row vector
            obj.ItemCount = countValues(seenItems');
        end
        
        % Generate recommendations for the given user
        items = recommendForUser(obj, userId)
    end
    
end

