
clear

% Motion prediction
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
MotionPrediction_ResFolder_100LeastMotion = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading/2Fold_RandomCV_Motion_100LeastMotion_2FCV'];
Behavior = load([MotionPrediction_ResFolder_100LeastMotion '/data.mat']);
for i = 0:99
    i
    Prediction_Fold0 = load([MotionPrediction_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_0_Score.mat']);
    MAE_Actual_Fold0 = Prediction_Fold0.MAE;
    Index_Fold0 = Prediction_Fold0.Index + 1;
    Prediction_Fold1 = load([MotionPrediction_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_1_Score.mat']);
    MAE_Actual_Fold1 = Prediction_Fold1.MAE;
    Index_Fold1 = Prediction_Fold1.Index + 1;

    % Fold 0
    Age_Fold0 = Behavior.AgeYears(Index_Fold0)';
    Sex_Fold0 = Behavior.Sex(Index_Fold0)';
    Motion_Fold0 = Behavior.Motion(Index_Fold0)';
    % Fold 1
    Age_Fold1 = Behavior.AgeYears(Index_Fold1)';
    Sex_Fold1 = Behavior.Sex(Index_Fold1)';
    Motion_Fold1 = Behavior.Motion(Index_Fold1)';

    [ParCorr_Actual_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', Motion_Fold0, [double(Age_Fold0) double(Sex_Fold0)]);
    [ParCorr_Actual_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', Motion_Fold1, [double(Age_Fold1) double(Sex_Fold1)]);
    
    ParCorr_Actual_RandomCV(i + 1) = mean([ParCorr_Actual_Fold0, ParCorr_Actual_Fold1]);
    MAE_Actual_RandomCV(i + 1) = mean([MAE_Actual_Fold0, MAE_Actual_Fold1]);
end
ParCorr_Actual_RandomCV_Mean = mean(ParCorr_Actual_RandomCV);
MAE_Actual_RandomCV_Mean = mean(MAE_Actual_RandomCV);
save([MotionPrediction_ResFolder_100LeastMotion '/2Fold_RandomCV_ParCorr_MAE_Actual.mat'], 'ParCorr_Actual_RandomCV', 'MAE_Actual_RandomCV', 'ParCorr_Actual_RandomCV_Mean', 'MAE_Actual_RandomCV_Mean');

% Permutation test
MotionPrediction_Permutation_ResFolder_100LeastMotion = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading/2Fold_RandomCV_Permutation_Motion_100LeastMotion_2FCV'];
for i = 0:999
    i
    Prediction_Fold0 = load([MotionPrediction_Permutation_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_0_Score.mat']);
    MAE_Permutation_Fold0 = Prediction_Fold0.MAE;
    Index_Fold0 = Prediction_Fold0.Index + 1;
    Prediction_Fold1 = load([MotionPrediction_Permutation_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_1_Score.mat']);
    MAE_Permutation_Fold1 = Prediction_Fold1.MAE;
    Index_Fold1 = Prediction_Fold1.Index + 1;

    % Fold 0
    Age_Fold0 = Behavior.AgeYears(Index_Fold0)';
    Sex_Fold0 = Behavior.Sex(Index_Fold0)';
    Motion_Fold0 = Behavior.Motion(Index_Fold0)';
    % Fold 1
    Age_Fold1 = Behavior.AgeYears(Index_Fold1)';
    Sex_Fold1 = Behavior.Sex(Index_Fold1)';
    Motion_Fold1 = Behavior.Motion(Index_Fold1)';

    [ParCorr_Permutation_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', Motion_Fold0, [double(Age_Fold0) double(Sex_Fold0)]);
    [ParCorr_Permutation_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', Motion_Fold1, [double(Age_Fold1) double(Sex_Fold1)]);

    ParCorr_Permutation_RandomCV(i + 1) = mean([ParCorr_Permutation_Fold0, ParCorr_Permutation_Fold1]);
    MAE_Permutation_RandomCV(i + 1) = mean([MAE_Permutation_Fold0, MAE_Permutation_Fold1]);
end
ParCorr_Permutation_RandomCV_Mean = mean(ParCorr_Permutation_RandomCV);
MAE_Permutation_RandomCV_Mean = mean(MAE_Permutation_RandomCV);
save([MotionPrediction_Permutation_ResFolder_100LeastMotion '/2Fold_RandomCV_ParCorr_MAE_Permutation.mat'], 'ParCorr_Permutation_RandomCV', 'MAE_Permutation_RandomCV', 'ParCorr_Permutation_RandomCV_Mean', 'MAE_Permutation_RandomCV_Mean');


% Age prediction
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
AgePrediction_ResFolder_100LeastMotion = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading/2Fold_RandomCV_Age_100LeastMotion_2FCV'];
Behavior = load([AgePrediction_ResFolder_100LeastMotion '/data.mat']);
for i = 0:99
    i
    Prediction_Fold0 = load([AgePrediction_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_0_Score.mat']);
    MAE_Actual_Fold0 = Prediction_Fold0.MAE;
    Index_Fold0 = Prediction_Fold0.Index + 1;
    Prediction_Fold1 = load([AgePrediction_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_1_Score.mat']);
    MAE_Actual_Fold1 = Prediction_Fold1.MAE;
    Index_Fold1 = Prediction_Fold1.Index + 1;

    % Fold 0
    Age_Fold0 = Behavior.AgeYears(Index_Fold0)';
    Sex_Fold0 = Behavior.Sex(Index_Fold0)';
    Motion_Fold0 = Behavior.Motion(Index_Fold0)';
    % Fold 1
    Age_Fold1 = Behavior.AgeYears(Index_Fold1)';
    Sex_Fold1 = Behavior.Sex(Index_Fold1)';
    Motion_Fold1 = Behavior.Motion(Index_Fold1)';

    [ParCorr_Actual_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', Age_Fold0, [double(Motion_Fold0) double(Sex_Fold0)]);
    [ParCorr_Actual_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', Age_Fold1, [double(Motion_Fold1) double(Sex_Fold1)]);

    ParCorr_Actual_RandomCV(i + 1) = mean([ParCorr_Actual_Fold0, ParCorr_Actual_Fold1]);
    MAE_Actual_RandomCV(i + 1) = mean([MAE_Actual_Fold0, MAE_Actual_Fold1]);
end
ParCorr_Actual_RandomCV_Mean = mean(ParCorr_Actual_RandomCV);
MAE_Actual_RandomCV_Mean = mean(MAE_Actual_RandomCV);
save([AgePrediction_ResFolder_100LeastMotion '/2Fold_RandomCV_ParCorr_MAE_Actual.mat'], 'ParCorr_Actual_RandomCV', 'MAE_Actual_RandomCV', 'ParCorr_Actual_RandomCV_Mean', 'MAE_Actual_RandomCV_Mean');

% Permutation test
AgePrediction_Permutation_ResFolder_100LeastMotion = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading/2Fold_RandomCV_Permutation_Age_100LeastMotion_2FCV'];
for i = 0:999
    i
    Prediction_Fold0 = load([AgePrediction_Permutation_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_0_Score.mat']);
    MAE_Permutation_Fold0 = Prediction_Fold0.MAE;
    Index_Fold0 = Prediction_Fold0.Index + 1;
    Prediction_Fold1 = load([AgePrediction_Permutation_ResFolder_100LeastMotion '/Time_' num2str(i) '/Fold_1_Score.mat']);
    MAE_Permutation_Fold1 = Prediction_Fold1.MAE;
    Index_Fold1 = Prediction_Fold1.Index + 1;

    % Fold 0
    Age_Fold0 = Behavior.AgeYears(Index_Fold0)';
    Sex_Fold0 = Behavior.Sex(Index_Fold0)';
    Motion_Fold0 = Behavior.Motion(Index_Fold0)';
    % Fold 1
    Age_Fold1 = Behavior.AgeYears(Index_Fold1)';
    Sex_Fold1 = Behavior.Sex(Index_Fold1)';
    Motion_Fold1 = Behavior.Motion(Index_Fold1)';

    [ParCorr_Permutation_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', Age_Fold0, [double(Motion_Fold0) double(Sex_Fold0)]);
    [ParCorr_Permutation_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', Age_Fold1, [double(Motion_Fold1) double(Sex_Fold1)]);

    ParCorr_Permutation_RandomCV(i + 1) = mean([ParCorr_Permutation_Fold0, ParCorr_Permutation_Fold1]);
    MAE_Permutation_RandomCV(i + 1) = mean([MAE_Permutation_Fold0, MAE_Permutation_Fold1]);
end
ParCorr_Permutation_RandomCV_Mean = mean(ParCorr_Permutation_RandomCV);
MAE_Permutation_RandomCV_Mean = mean(MAE_Permutation_RandomCV);
save([AgePrediction_Permutation_ResFolder_100LeastMotion '/2Fold_RandomCV_ParCorr_MAE_Permutation.mat'], 'ParCorr_Permutation_RandomCV', 'MAE_Permutation_RandomCV', 'ParCorr_Permutation_RandomCV_Mean', 'MAE_Permutation_RandomCV_Mean');


