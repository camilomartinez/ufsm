function [ model ] = item_item_cosine_model( train_matrix, ~ )
%ITEM_ITEM_COSINE_MODEL Model builder for ItemItem cosine similarity
    train_normalized = normalize_cols(train_matrix);
    model = train_normalized'*train_normalized;

end

function [normalized] = normalize_cols(mat)
%NORMALIZE_COLS normalize the columns of a matrix (i.e. divide each column
%by its 2-norm)
    inv_col_norms = 1./sqrt(diag(mat'*mat));
    normalized = mat * diag(inv_col_norms);
end