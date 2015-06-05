function [train_mat, validation_mat, validation_users] = hold_out_fast(urm, train_percentage, ratings_to_keep)
%HOLD_OUT_FAST Returns a hold-out split of the input User Rating Matrix
%Faster than HOLD_OUT function since it makes clever usage of MATLAB
%matrix-matrix operations

[n_users, ~] = size(urm);
user_ids = 1:n_users;

%sample randomly train_percentage*n_users users from the urm
train_users = randsample(user_ids, int64(train_percentage*n_users));
%remaining users go into the validation set
validation_users = setdiff(user_ids, train_users);

%get the indices of non-zero entries of the urm
UI = urm>0;

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
train_mat = urm .* train_mask;
validation_mat = urm(validation_users, :) .* val_mask;

end

