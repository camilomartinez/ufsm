function [] = print_statistics(urm)
%PRINT_STATISTICS prints useful statistics over the User Rating Matrix in
%input
    fprintf('User rating matrix of size: %dx%d\n', size(urm,1), size(urm,2));
    fprintf('Density: %f\n', density(urm));
    
    avg_rating = mean(urm(urm>0));
    fprintf('Average rating: %f\n', full(avg_rating));  %full required to get rid of sparse error of fprintd
    
    %popularity analysis
    item_pop = sum(urm>0,1);
    user_pop = sum(urm>0,2);
    [popularity, top_pop_item] = sort(item_pop, 'descend');
    figure;plot(popularity);
    title('item popularity');
    fprintf('There exist %d items with no ratings (min:%d, max:%d)\n',...
        full(sum(item_pop==0)), full(min(item_pop)), full(max(item_pop)));
    fprintf('There exist %d users with no ratings (min:%d, max:%d)\n',...
        full(sum(user_pop==0)), full(min(user_pop)), full(max(user_pop)));
    fprintf('The most popular item is %d with %d ratings\n', full(top_pop_item(1)), full(popularity(1)));
    
    %item rating analysis
    item_avg_rating = sum(urm,1)./item_pop;
    figure;hist(item_avg_rating);
    title('item average rating');
    
    %user rating analysis
    user_avg_rating = sum(urm,2)./sum(urm>0,2);
    figure;hist(user_avg_rating);
    title('user average rating');
end

function [sp] = density(urm)
    sp = nnz(urm)/numel(urm);
end