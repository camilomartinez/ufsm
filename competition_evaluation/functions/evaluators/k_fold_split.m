function [ train_folds, validation_folds, validation_fold_users ] = k_fold_split( urm, n_folds, ratings_to_keep )
%K_FOLD Summary of this function goes here
%   Detailed explanation goes here

[n_users, ~] = size(urm);
fold_size = ceil(n_users/n_folds);

%random shuffle row indices
sh_rows = randperm(n_users);

train_folds = cell(n_folds, 1);
validation_folds = cell(n_folds, 1);
validation_fold_users = cell(n_folds, 1);

    
%get the indices of non-zero entries of the urm
UI = urm>0;

fold_end = 0;



for ff=1:n_folds
    fold_begin = fold_end+1;
    fold_end = min(fold_end+fold_size, n_users);
    
    %fetch fold rows for the validation set
    fold_rows = sh_rows(fold_begin:fold_end);
    validation_users = fold_rows;

    %same as hold_out_fast follows
    %create two binary masks (one for training and one for validation)
    train_mask = UI;
    train_mask(validation_users, :) = 0;
    val_mask = UI(validation_users, :);

    for uu = 1:length(validation_users)
        vuser = validation_users(uu);
        rated_items = find(urm(vuser,:));
        kept_items = randsample(rated_items, ratings_to_keep);

        %set masks' values properly
        train_mask(vuser, kept_items) = 1;
        val_mask(uu, kept_items) = 0;
    end

    %then apply masks (cwise-product is efficient enough in MATLAB)
    train_folds{ff} = urm .* train_mask;
    validation_folds{ff} = urm(validation_users, :) .* val_mask;
    validation_fold_users{ff} = validation_users;
end

end