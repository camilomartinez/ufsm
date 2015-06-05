function [ rmse ] = rmse_err( expectedRatings, predictedRatings, ~ )
%RMSE Computes the Root Mean Squared Error for the given predicted ratings
%against the expected ones
rmse = expectedRatings-predictedRatings.*(expectedRatings>0);
rmse = rmse.*rmse;
rmse = sqrt(sum(rmse(:))/nnz(rmse));
end

