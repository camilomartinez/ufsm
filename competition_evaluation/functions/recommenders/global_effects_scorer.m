function [ scores ] = global_effects_scorer(ge_model, test_users, profiles, params)
%GLOBAL_EFFECTS_SCORER returns scores for all test_users for a given
%ge_model. profiles contains the rating vectors of each user in test_users.

if exist('params','var') == 0 
    params.exclude_already_rated = 1;
    params.min_rating = 1;
    params.max_rating = 5;
    params.clip_ratings = 1; 
else
    if ~isfield(params, 'exclude_already_rated')
        params.exclude_already_rated = 1;
    end
    if ~isfield(params, 'min_rating')
        params.min_rating = 1;
    end
    if ~isfield(params, 'max_rating')
        params.max_rating = 5;
    end
    if ~isfield(params, 'clip_ratings')
        params.clip_ratings = 1;
    end
end

n_users = length(test_users);  
n_items = length(ge_model.item_bias);

%model.user_bias(test_users) is used to take the user_bias for each test
%user
scores = ge_model.global_avg + repmat(full(ge_model.item_bias), [n_users 1]) ...
    + repmat(full(ge_model.user_bias(test_users)), [1 n_items]);

%clip scores to fit into the rating range of the domain
if params.clip_ratings ~= 0
    scores(scores < params.min_rating) = params.min_rating;
    scores(scores > params.max_rating) = params.max_rating;
end

if params.exclude_already_rated ~= 0
    %for each user assign 0 score to each already rated item
    scores(profiles>0) = 0;
end


end

