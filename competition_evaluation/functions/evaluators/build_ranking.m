function [ ranking ] = build_ranking( scores )
%BUILD_RANKING converts scores produced by a scorer into a ranking stored
%into a cell array

ranking = cell(size(scores,1),1);

%for each user profile, store the column indices (i.e., the user ids) 
%sorted according to their rating in descending order
for ss = 1:size(scores,1)
    [~, ranking{ss}] = sort(scores(ss,:),'descend');
end

end

