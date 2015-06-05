function [ err_avg, err_stddev ] = k_fold_cv_precision( train_folds, val_folds, val_fold_users, model_fun, model_scorer, error_fun, cv_params )
%K_FOLD_CV_PRECISION Computes the value for an error metric with k-fold
%cross-validation
%cvParams.model: parameters for the model_fun
%cvParams.scorer: parameters for the model_scorer
%cvParams.metric: parameters for the error_fun

n_folds = length(train_folds);
errors = zeros(n_folds,1);

%for each fold
for kk=1:n_folds
    train_mat = train_folds{kk};
    val_mat = val_folds{kk};
    val_users = val_fold_users{kk};
    
    %compute the model over the train fold
    model = model_fun(train_mat, cv_params.model);
    %then evaluate over the validation fold
    val_profiles = train_mat(val_users, :);
    scores = model_scorer(model, val_users, val_profiles, cv_params.scorer);
    errors(kk) = error_fun(val_mat, scores, cv_params.metric);
end

err_avg = mean(errors);
err_stddev = std(errors);

end

