function [model] = global_effects_model(train_matrix, params)
%GLOBAL_EFFECTS_MODEL builds a model based upon the global effects computed
%over the train_matrix in input
%params.shrinkage_items: shrinkage coefficient for items
%params.shrinkage_users: shrinkage coefficient for users


if exist('params','var') == 0
%default shrinkage values taken from "Factor in Neighbors: Scalable and Accurate
%Collaborative Filtering", Y. Koren, 2010

%Notice that this values have been proven to be accurate enough ONLY for the Netflix dataset.
%On other datasets, they may not be the best choice at all!
    params.shrinkage_items = 25;
    params.shrinkage_users = 10;
else
    if ~isfield(params, 'shrinkage_items')
        params.shrinkage_items = 25;
    end
    if ~isfield(params, 'shrinkage_users')         
        params.shrinkage_users = 10;
    end
end


%compute the global average
model.global_avg = mean(train_matrix(train_matrix>0));

%indicator matrix for the training matrix 
train_matrix_ind = train_matrix>0;

%subtract the global average from each rating
train_matrix_unbiased = train_matrix - model.global_avg*train_matrix_ind;

%compute the item bias
item_pop = sum(train_matrix_ind, 1);
model.item_bias = sum(train_matrix_unbiased,1)./(params.shrinkage_items + item_pop);

%subtract the item bias from the unbiased training matrix
train_matrix_unbiased = train_matrix_unbiased - train_matrix_ind*diag(model.item_bias);

%compute the user bias
user_pop = sum(train_matrix_ind, 2);
model.user_bias = sum(train_matrix_unbiased,2)./(params.shrinkage_users + user_pop);

%if you want to plot the biases, uncomment these lines (change plot with
%hist if you want to output the histograms
% figure;hist(model.item_bias);
% figure;hist(model.user_bias);

%if you to include the unbiased items in the model, uncomment the last row
%subtract the user bias from the unbiased training matrix
% model.train_matrix_unbiased = train_matrix_unbiased - diag(model.user_bias)*train_matrix_ind;

end