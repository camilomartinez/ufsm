function [ acc_avg, acc_stddev ] = k_fold_cv_accuracy( train_folds, val_folds, val_fold_users, model_fun, model_scorer, accuracy_fun, cv_params )
%K_FOLD_CV_ACCURACY Computes the value for an accuracy metric with k-fold
%cross-validation
%cvParams.model: parameters for the model_fun
%cvParams.scorer: parameters for the model_scorer
%cvParams.metric: parameters for the accuracy_fun

n_folds = length(train_folds);
accuracies = zeros(n_folds,1);

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
    
    ranking = build_ranking(scores);%ranking is required for accuracy metrics
    accuracies(kk) = accuracy_fun(val_mat, ranking, cv_params.metric);
end

acc_avg = mean(accuracies);
acc_stddev = std(accuracies);
end

