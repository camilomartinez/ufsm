function [ relevant ] = keep_relevant( urm, relevance_min_threshold )
%KEEP_RELEVANT returns a cell array with indices of relevant items for each
%user profile in the User Rating Matrix. By default
%relevance_min_threshold=4.

if exist('relevance_min_threshold','var') == 0
    relevance_min_threshold = 4;
end

[n_users, ~] = size(urm);
relevant = cell(n_users,1);
for uu = 1:n_users
   relevant{uu} = find(urm(uu,:) >= relevance_min_threshold); 
end

end

