classdef CoSimRecommender < ContentBasedRecommender
    %COSIMRECOMMENDER Recommend based on cosine similarity between item
    %features
    %   Based on the description done in UFSM paper
    
    properties(SetAccess = private)
        % Computed similarities among all items
        % Size nItems x nItems
        ItemItemSimilarity
    end
    
    methods
        %Constructor
        function obj = CoSimRecommender(dataModel, contentModel)
            obj@ContentBasedRecommender(dataModel, contentModel);
        end
        
        % Train its internal model
        function trainModel(obj)
            icm = obj.ContentModel.Icm';
            % Item features are icm row vectors
            nItems = obj.DataModel.NumItems;
            % Initialize diagonal to one
            similarities = diag(ones(1,nItems));
            for iRow = 1:(nItems-1)
                for jCol = (iRow+1):nItems
                    sim = obj.similarity(icm(iRow,:), icm(jCol,:));
                    similarities(iRow, jCol) = sim;
                    % Symmetric  similarities
                    similarities(jCol, iRow) = sim;
                end
            end
            obj.ItemItemSimilarity = similarities;
        end
        
        % Generate recommendations for the given user
        function itemsWithScore = recommendForUser(obj, userId)
        end
    end
    
    methods(Access = private)        
        % a and b are expected to be vectors
        function sim = similarity(obj, a, b)
            sim = dot(a, b) / (norm(a) * norm(b));
        end
    end
    
end

