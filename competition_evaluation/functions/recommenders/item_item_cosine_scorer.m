function [ scores ] = item_item_cosine_scorer( ii_model, ~, profiles, ~ )
%ITEM_ITEM_COSINE_SCORER Scorer for ItemItem cosine similarity

    scores = profiles * ii_model;
    %normalize scores
    norm_coeffs = (profiles>0) * ii_model;
    norm_coeffs(norm_coeffs==0) = 1;
    scores = scores ./ norm_coeffs;
    
end

