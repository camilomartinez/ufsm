function [train_mat, validation_mat, validation_users] = hold_out(urm, train_percentage, ratings_to_keep)
%HOLD_OUT Returns a hold-out split of the input User Rating Matrix
%   This function does not guarantee that there will be at least one

[n_users, ~] = size(urm);
user_ids = 1:n_users;

%sample randomly train_percentage*n_users users from the urm
train_users = randsample(user_ids, int64(train_percentage*n_users));
%remaining users go into the validation set
validation_users = setdiff(user_ids, train_users);

train_mat = urm;
validation_mat = urm(validation_users, :);
%for each user in the validation set, keep only ratings_to_keep ratings
%into the training matrix. The remaining ratings will be put into the
%validation matrix


for uu = 1:length(validation_users)
    vuser = validation_users(uu);
    %find returns the indices of elements in a vector which fulfill the
    %predicate(nonzeros by default)
    rated_items = find(urm(vuser,:));
    kept_items = randsample(rated_items, ratings_to_keep);
    discarded_items = setdiff(rated_items, kept_items);
    train_mat(vuser, discarded_items) = 0; %remove discarded items from the train set
    validation_mat(uu, kept_items) = 0; %remove kept items from the validation set   
end

