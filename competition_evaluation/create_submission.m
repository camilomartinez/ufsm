%load input data
[R, testUsers] = load_data('train.csv', 'test.csv', 1);
[nUsers, nItems] = size(R);

%temporarily remove test users from the training matrix
R_no_test = R(setdiff(1:nUsers, testUsers), :);

%split the dataset into train and validation sets using hold_out (other
%techniques will follow ;) )
[trainMat, validationMat, validationUsers] = hold_out_fast(R_no_test, 0.8, 5);

%build the model
geModelParams.shrinkage_items = 25;
geModelParams.shrinkage_users = 10;
geModel = global_effects_model(trainMat, geModelParams);

%compute scores for validation users
validationProfiles = trainMat(validationUsers,:);

geScorerParams.exclude_already_rated = 1;
geScorerParams.min_rating = min(R(R>0));
geScorerParams.max_rating = max(R(R>0));
geScorerParams.clip_ratings = 1;
geScores = global_effects_scorer(geModel, validationUsers, validationProfiles, geScorerParams);


%evaluate the RMSE over the predicted ratings
err = rmse_err(validationMat, geScores)

%then compute rankings
geRanking = build_ranking(geScores);

%evaluate the MAP@K over the validation set
map = map_at_k(validationMat, geRanking, 5, 4)

%for you :-) : use above functions to generate rankings for the users in testUsers




