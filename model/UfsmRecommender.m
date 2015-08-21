classdef UfsmRecommender < ContentBasedRecommender
    %UFSMRECOMMENDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Regularization
        Lambda = 3e-3;
        Mu1 = 5e-3;
        Mu2 = 1e-4;
        % Number of global similarity functions
        L = 3;
        % Learning rates (just testing not optimal)
        Alfa1 = 0.01;
        Alfa2 = 0.01;
        % Error tolerance (testing, not even mentioned)
        Tolerance = 0.1;
        % Used to binarize urm
        % All ratings equal or greater are set to 1
        Threshold = 4;
    end
    
    properties (Access=private)
        % Binary urm
        BinUrm;
    end
    
    methods
        %Constructor
        function obj = UfsmRecommender(dataModel, contentModel)
            obj@ContentBasedRecommender(dataModel, contentModel);
        end
        
        % Train its internal model
        function trainModel(obj)
            %% Initialize
            nUsers = obj.DataModel.NumUsers;
            l = obj.L;
            % Binarize urm
            obj.BinUrm = obj.DataModel.Urm >= obj.Threshold;
            % User membership vector
            M = randn(nUsers, l);
            nFeatures = obj.ContentModel.NumFeatures;
            % Similarity weights
            W = randn(l, nFeatures);
            %% Iterate till convergence
%             while (obj.costFunction(M,W) > obj.Tolerance)
%                 for iUser = 1:obj.DataModel.NumUsers
%                     userId = obj.DataModel.Users(iUser);
%                     icm = obj.ContentModel.Icm;
%                     [itemPositive, itemNegative] =...
%                         obj.sampleItemPairForUser(userId);
%                     featuresPositive = icm(itemPositive, :);
%                     featuresNegative = icm(itemNegative, :);
%                     % Compute items with positive feedback from the user
%                     [~, otherPositiveItems, ~] = find(obj.BinUrm(userId,:));
%                     % Remove estimated one
%                     otherPositiveItems(otherPositiveItems == itemPositive) = [];
%                     featuresOthers = icm(otherPositiveItems, :);
%                     % 1 x nFeatures
%                     sumFeaturesOthers = sum(featuresOthers, 1);
%                     % Gradients
%                     deltaW = M(userId, :)' *...
%                         (featuresPositive - featuresNegative) * ...
%                         sumFeaturesOthers;
%                     deltaM = W * sumFeaturesOthers' *...
%                         (featuresPositive - featuresNegative);
%                 end
%            end            
        end
        
        % Generate recommendations for the given user
        function itemsOrderedByRating = recommendForUser(obj, userId, numRecommendations)
            if nargin <= 2
                % Default
                numRecommendations = 100;
            end
        end
        
        % Cost function of the recommender
        function error = lossFunction(obj, M, W)
            error = 1;
        end
        
        function rating = estimatedRating(obj, userId, itemId, M, W)
            F = obj.ContentModel.Icm;
            % (1 x l) * (l x nf) * (nf x 1)
            rating = M(userId,:) * W * (F(itemId,:) .* sum(F(positive,:)))';
        end
        
        function positives = positiveFeedbackFromUser(obj, userId)
            [~, positives, ~] = find(obj.BinUrm(userId,:));
        end
    end
    
    methods (Access = private)                
        
        % Sample any two items for which the user expressed
        % positive feedback and negative feedback
        function [positive, negative] = sampleItemPairForUser(obj, userId)
            [~, positives, ~] = find(obj.BinUrm(userId,:));
            % negative items as complement
            negatives = setdiff(obj.DataModel.Items, positives);
            % sample one item from each set
            positive = datasample(positives, 1);
            negative = datasample(negatives, 1);
        end
    end
    
end

