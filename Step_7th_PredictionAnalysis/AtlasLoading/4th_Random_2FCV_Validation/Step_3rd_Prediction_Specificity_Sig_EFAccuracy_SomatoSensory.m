
clear

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
EFAccuracyPrediction_ResFolder = [PredictionFolder ...
    '/AtlasLoading_RandomCV_Validation/2Fold_RandomCV_EFAccuracy_SomatoSensory'];
Behavior = load([PredictionFolder '/Behavior_693.mat']);
EFAccuracyPrediction_Association_ResFolder = [PredictionFolder ...
    '/AtlasLoading_RandomCV_Validation/2Fold_RandomCV_EFAccuracy_Association'];
for i = 0:99
    i
    Prediction_Fold0 = load([EFAccuracyPrediction_ResFolder '/Time_' num2str(i) '/Fold_0_Score.mat']);
    MAE_Actual_Fold0 = Prediction_Fold0.MAE;
    Index_Fold0 = Prediction_Fold0.Index + 1;
    Prediction_Fold1 = load([EFAccuracyPrediction_ResFolder '/Time_' num2str(i) '/Fold_1_Score.mat']);
    MAE_Actual_Fold1 = Prediction_Fold1.MAE;
    Index_Fold1 = Prediction_Fold1.Index + 1;

    EFAccuracyPrediction_Fold0_Association = load([EFAccuracyPrediction_Association_ResFolder '/Time_' num2str(i) '/Fold_0_Score.mat']);
    EFAccuracyPrediction_Fold1_Association = load([EFAccuracyPrediction_Association_ResFolder '/Time_' num2str(i) '/Fold_1_Score.mat']);
 
    % Fold 0
    EFAccuracy_Fold0 = Behavior.F1_Exec_Comp_Res_Accuracy(Index_Fold0);
    Age_Fold0 = Behavior.AgeYears(Index_Fold0);
    Sex_Fold0 = Behavior.Sex(Index_Fold0);
    Motion_Fold0 = Behavior.Motion(Index_Fold0);
    % Fold 1
    EFAccuracy_Fold1 = Behavior.F1_Exec_Comp_Res_Accuracy(Index_Fold1);
    Age_Fold1 = Behavior.AgeYears(Index_Fold1);
    Sex_Fold1 = Behavior.Sex(Index_Fold1);
    Motion_Fold1 = Behavior.Motion(Index_Fold1);

    [ParCorr_Actual_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', EFAccuracy_Fold0, ...
          [double(Age_Fold0) double(Sex_Fold0) double(Motion_Fold0) double(EFAccuracyPrediction_Fold0_Association.Predict_Score')]);
    [ParCorr_Actual_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', EFAccuracy_Fold1, ...
          [double(Age_Fold1) double(Sex_Fold1) double(Motion_Fold1) double(EFAccuracyPrediction_Fold1_Association.Predict_Score')]);

    ParCorr_Actual_Mean(i + 1) = mean([ParCorr_Actual_Fold0 ParCorr_Actual_Fold1]);
end
save([EFAccuracyPrediction_ResFolder '/ParCorr.mat'], 'ParCorr_Actual_Mean');

