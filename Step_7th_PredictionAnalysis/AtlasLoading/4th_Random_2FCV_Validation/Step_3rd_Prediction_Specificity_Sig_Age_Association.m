
clear

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
AgePrediction_ResFolder = [PredictionFolder ...
    '/AtlasLoading_RandomCV_Validation/2Fold_RandomCV_Age_Association'];
Behavior = load([PredictionFolder '/Behavior_693.mat']);
AgePrediction_SomatoSensory_ResFolder = [PredictionFolder ...
    '/AtlasLoading_RandomCV_Validation/2Fold_RandomCV_Age_SomatoSensory'];
for i = 0:99
    i
    Prediction_Fold0 = load([AgePrediction_ResFolder '/Time_' num2str(i) '/Fold_0_Score.mat']);
    MAE_Actual_Fold0 = Prediction_Fold0.MAE;
    Index_Fold0 = Prediction_Fold0.Index + 1;
    Prediction_Fold1 = load([AgePrediction_ResFolder '/Time_' num2str(i) '/Fold_1_Score.mat']);
    MAE_Actual_Fold1 = Prediction_Fold1.MAE;
    Index_Fold1 = Prediction_Fold1.Index + 1;

    AgePrediction_Fold0_SomatoSensory = load([AgePrediction_SomatoSensory_ResFolder '/Time_' num2str(i) '/Fold_0_Score.mat']);
    AgePrediction_Fold1_SomatoSensory = load([AgePrediction_SomatoSensory_ResFolder '/Time_' num2str(i) '/Fold_1_Score.mat']);
 
    % Fold 0
    Age_Fold0 = Behavior.AgeYears(Index_Fold0);
    Sex_Fold0 = Behavior.Sex(Index_Fold0);
    Motion_Fold0 = Behavior.Motion(Index_Fold0);
    % Fold 1
    Age_Fold1 = Behavior.AgeYears(Index_Fold1);
    Sex_Fold1 = Behavior.Sex(Index_Fold1);
    Motion_Fold1 = Behavior.Motion(Index_Fold1);

    [ParCorr_Actual_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', Age_Fold0, ...
          [double(Sex_Fold0) double(Motion_Fold0) double(AgePrediction_Fold0_SomatoSensory.Predict_Score')]);
    [ParCorr_Actual_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', Age_Fold1, ...
          [double(Sex_Fold1) double(Motion_Fold1) double(AgePrediction_Fold1_SomatoSensory.Predict_Score')]);

    ParCorr_Actual_Mean(i + 1) = mean([ParCorr_Actual_Fold0 ParCorr_Actual_Fold1]);
end
save([AgePrediction_ResFolder '/ParCorr.mat'], 'ParCorr_Actual_Mean');

