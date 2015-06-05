%load input data
[R, testUsers] = load_data('train.csv', 'test.csv', 1);
[nUsers, nItems] = size(R);

%temporarily remove test users from the training matrix
R_no_test = R(setdiff(1:nUsers, testUsers), :);

%perform the k-fold split (1-fold is equivalent to hold-out)
[T,V,Vu] = k_fold_split(R, 5, 5);

%set the model and scorer parameters for global effects
modelParams.shrinkage_items = 25;
modelParams.shrinkage_users = 10;

scorerParams.exclude_already_rated = 1;
scorerParams.min_rating = min(R(R>0));
scorerParams.max_rating = max(R(R>0));%a bit unefficient :)
scorerParams.clip_ratings = 0;

%pass them to the cross validation evaluator for rmse
cvParams.model = modelParams;
cvParams.scorer = scorerParams;
cvParams.metric = 0;    %rmse metric has no parameters
[rmse, rmse_std] = k_fold_cv_precision(T, V, Vu, @global_effects_model, @global_effects_scorer, @rmse_err, cvParams)
% [rmse, rmse_std] = k_fold_cv_precision(T, V, Vu, @item_item_cosine_model, @item_item_cosine_scorer, @rmse_err, cvParams)


cvParams.metric.k = 5;    %k for map-at-k metric
cvParams.metric.relevance_min_th = 4;    %threshold for relevance of items in the validation set
[map, map_std] = k_fold_cv_accuracy(T, V, Vu, @global_effects_model, @global_effects_scorer, @map_at_k, cvParams)
% [map, map_std] = k_fold_cv_accuracy(T, V, Vu, @item_item_cosine_model, @item_item_cosine_scorer, @map_at_k, cvParams)


%TODO: use global_effects as baseline predictor for item-item. Does the
%rmse decrease? And what about the map?