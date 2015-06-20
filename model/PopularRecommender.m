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
        function trainModel(obj)
            urm = obj.DataModel.Urm;
            [~, seenItems, ~] = find(urm);
            % countValues expects a row vector
            obj.ItemCount = countValues(seenItems');
        end
        
        % Generate recommendations for the given user
        function items = recommendForUser(obj, userId, numRecommendations)
            if nargin <= 2
                % Default
                numRecommendations = 100;
            end            
            notSeen = obj.DataModel.itemsNotSeenByUser(userId);
            itemCount = obj.ItemCount;
            mask = ismember(itemCount(:,1), notSeen);
            items = obj.ItemCount(mask, :);
            % Limit number of recommendations
            if size(items,1) > numRecommendations
                items = items(1:numRecommendations, :);
            end
        end
    end
    
end

