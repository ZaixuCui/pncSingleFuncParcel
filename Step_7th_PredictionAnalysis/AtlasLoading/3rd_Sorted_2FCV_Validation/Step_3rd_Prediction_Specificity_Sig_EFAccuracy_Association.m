
clear

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
EFPrediction_ResFolder = [PredictionFolder ...
    '/AtlasLoading_Validation/2Fold_Sort_EFAccuracy_Association'];

Prediction_Fold0 = load([EFPrediction_ResFolder '/Fold_0_Score.mat']);
Corr_Actual_Fold0 = Prediction_Fold0.Corr;
MAE_Actual_Fold0 = Prediction_Fold0.MAE;
Index_Fold0 = Prediction_Fold0.Index + 1;
Prediction_Fold1 = load([EFPrediction_ResFolder '/Fold_1_Score.mat']);
Corr_Actual_Fold1 = Prediction_Fold1.Corr;
MAE_Actual_Fold1 = Prediction_Fold1.MAE;
Index_Fold1 = Prediction_Fold1.Index + 1;

EFPrediction_VisualMotor = [PredictionFolder ...
    '/AtlasLoading_Validation/2Fold_Sort_EFAccuracy_VisualMotor'];
Prediction_Fold0_VisualMotor = load([EFPrediction_VisualMotor '/Fold_0_Score.mat']);
Prediction_Fold1_VisualMotor = load([EFPrediction_VisualMotor '/Fold_1_Score.mat']);

Behavior = load([PredictionFolder '/Behavior_693.mat']);
% Fold 0
Age_Fold0 = Behavior.AgeYears(Index_Fold0);
Sex_Fold0 = Behavior.Sex(Index_Fold0);
Motion_Fold0 = Behavior.Motion(Index_Fold0);
EF_Fold0 = Behavior.F1_Exec_Comp_Res_Accuracy(Index_Fold0);
% Fold 1
Age_Fold1 = Behavior.AgeYears(Index_Fold1);
Sex_Fold1 = Behavior.Sex(Index_Fold1);
Motion_Fold1 = Behavior.Motion(Index_Fold1);
EF_Fold1 = Behavior.F1_Exec_Comp_Res_Accuracy(Index_Fold1);
 
[ParCorr_Actual_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', EF_Fold0, ...
        [double(Age_Fold0) double(Sex_Fold0) double(Motion_Fold0) double(Prediction_Fold0_VisualMotor.Predict_Score')]);
[ParCorr_Actual_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', EF_Fold1, ...
        [double(Age_Fold1) double(Sex_Fold1) double(Motion_Fold1) double(Prediction_Fold1_VisualMotor.Predict_Score')]);
ParCorr_Actual_Mean = mean([ParCorr_Actual_Fold0 ParCorr_Actual_Fold1]);
save([EFPrediction_ResFolder '/ParCorr.mat'], 'ParCorr_Actual_Fold0', 'ParCorr_Actual_Fold1', ...
        'ParCorr_Actual_Mean');

%% Significance
EFAccuracyPrediction_PermutationFolder = [PredictionFolder ...
    '/AtlasLoading_Validation/2Fold_Sort_Permutation_EFAccuracy_Association'];
EFAccuracyPrediction_PermutationFolder_VisualMotor = [PredictionFolder ...
    '/AtlasLoading_Validation/2Fold_Sort_Permutation_EFAccuracy_VisualMotor'];
% Fold 0
Permutation_Fold0_Cell = g_ls([EFAccuracyPrediction_PermutationFolder '/Time_*/Fold_0_Score.mat']);
Permutation_Fold0_Cell_VisualMotor = g_ls([EFAccuracyPrediction_PermutationFolder_VisualMotor '/Time_*/Fold_0_Score.mat']);
for i = 1:1000
  tmp = load(Permutation_Fold0_Cell{i});
  tmp_VisualMotor = load(Permutation_Fold0_Cell_VisualMotor{i});
  ParCorr_Rand_Fold0(i) = partialcorr(tmp.Predict_Score', EF_Fold0, ...
            [double(Age_Fold0) double(Sex_Fold0) double(Motion_Fold0) double(tmp_VisualMotor.Predict_Score')]);
  MAE_Rand_Fold0(i) = tmp.MAE;
end
ParCorr_Fold0_Sig = length(find(ParCorr_Rand_Fold0 >= ParCorr_Actual_Fold0)) / 1000;
MAE_Fold0_Sig = length(find(MAE_Rand_Fold0 <= MAE_Actual_Fold0)) / 1000;
save([EFPrediction_ResFolder '/2Fold_Sort_Fold0_Specificity_Sig_EFAccuracy.mat'], 'ParCorr_Actual_Fold0', 'ParCorr_Rand_Fold0', 'ParCorr_Fold0_Sig', 'MAE_Actual_Fold0', 'MAE_Rand_Fold0', 'MAE_Fold0_Sig');
% Fold 1
Permutation_Fold1_Cell = g_ls([EFAccuracyPrediction_PermutationFolder '/Time_*/Fold_1_Score.mat']);
Permutation_Fold1_Cell_VisualMotor = g_ls([EFAccuracyPrediction_PermutationFolder_VisualMotor '/Time_*/Fold_1_Score.mat']);
for i = 1:1000
  tmp = load(Permutation_Fold1_Cell{i});
  tmp_VisualMotor = load(Permutation_Fold1_Cell_VisualMotor{i});
  ParCorr_Rand_Fold1(i) = partialcorr(tmp.Predict_Score', EF_Fold1, ...
            [double(Age_Fold1) double(Sex_Fold1) double(Motion_Fold1) double(tmp_VisualMotor.Predict_Score')]);
  MAE_Rand_Fold1(i) = tmp.MAE;
end
ParCorr_Fold1_Sig = length(find(ParCorr_Rand_Fold1 >= ParCorr_Actual_Fold1)) / 1000;
MAE_Fold1_Sig = length(find(MAE_Rand_Fold1 <= MAE_Actual_Fold1)) / 1000;
save([EFPrediction_ResFolder '/2Fold_Sort_Fold1_Specificity_Sig_EFAccuracy.mat'], 'ParCorr_Actual_Fold1', 'ParCorr_Rand_Fold1', 'ParCorr_Fold1_Sig', 'MAE_Actual_Fold1', 'MAE_Rand_Fold1', 'MAE_Fold1_Sig');

