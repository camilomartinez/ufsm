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
        function items = recommendForUser(obj, userId)
            notSeen = obj.DataModel.itemsNotSeenByUser(userId);
            itemCount = obj.ItemCount;
            mask = ismember(itemCount(:,1), notSeen);
            items = obj.ItemCount(mask, :);
            % Recommend up to 100 items
            sizeLimit = min(100, length(items));
            items = items(1:sizeLimit);
        end
    end
    
end

