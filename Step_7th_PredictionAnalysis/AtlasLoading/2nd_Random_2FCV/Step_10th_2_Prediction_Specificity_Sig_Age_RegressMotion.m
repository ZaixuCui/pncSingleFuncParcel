
clear

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
AgePrediction_RegressMotion_ResFolder = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading/2Fold_RandomCV_Age_RegressMotion'];
Behavior = load([ReplicationFolder '/Revision/PredictionAnalysis/Behavior_693.mat']);
for i = 0:99
    i
    Prediction_Fold0 = load([AgePrediction_RegressMotion_ResFolder '/Time_' num2str(i) '/Fold_0_Score.mat']);
    Prediction_Fold1 = load([AgePrediction_RegressMotion_ResFolder '/Time_' num2str(i) '/Fold_1_Score.mat']);

    ParCorr_Actual_RandomCV(i + 1) = mean([Prediction_Fold0.Corr Prediction_Fold1.Corr]);
    MAE_Actual_RandomCV(i + 1) = mean([Prediction_Fold0.MAE Prediction_Fold1.MAE]);
end
ParCorr_Actual_RandomCV_Mean = mean(ParCorr_Actual_RandomCV);
MAE_Actual_RandomCV_Mean = mean(MAE_Actual_RandomCV);
save([AgePrediction_RegressMotion_ResFolder '/2Fold_RandomCV_ParCorr_MAE_Actual.mat'], 'ParCorr_Actual_RandomCV', 'MAE_Actual_RandomCV', 'ParCorr_Actual_RandomCV_Mean', 'MAE_Actual_RandomCV_Mean');

% Permutation test
AgePrediction_RegressMotion_Permutation_ResFolder = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading/2Fold_RandomCV_Permutation_Age_RegressMotion'];
for i = 0:999
    i
    Prediction_Fold0 = load([AgePrediction_RegressMotion_Permutation_ResFolder '/Time_' num2str(i) '/Fold_0_Score.mat']);
    Prediction_Fold1 = load([AgePrediction_RegressMotion_Permutation_ResFolder '/Time_' num2str(i) '/Fold_1_Score.mat']);

    ParCorr_Permutation_RandomCV(i + 1) = mean([Prediction_Fold0.Corr Prediction_Fold1.Corr]);
    MAE_Permutation_RandomCV(i + 1) = mean([Prediction_Fold0.MAE Prediction_Fold1.MAE]);
end
ParCorr_Permutation_RandomCV_Mean = mean(ParCorr_Permutation_RandomCV);
MAE_Permutation_RandomCV_Mean = mean(MAE_Permutation_RandomCV);
save([AgePrediction_RegressMotion_Permutation_ResFolder '/2Fold_RandomCV_ParCorr_MAE_Permutation.mat'], 'ParCorr_Permutation_RandomCV', 'MAE_Permutation_RandomCV', 'ParCorr_Permutation_RandomCV_Mean', 'MAE_Permutation_RandomCV_Mean');

