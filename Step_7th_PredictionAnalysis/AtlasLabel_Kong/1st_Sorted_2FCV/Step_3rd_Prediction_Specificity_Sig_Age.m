
clear

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
AgePrediction_ResFolder = [PredictionFolder '/AtlasLabel_Kong/2Fold_Sort_Age'];
Prediction_Fold0 = load([AgePrediction_ResFolder '/Fold_0_Score.mat']);
Corr_Actual_Fold0 = Prediction_Fold0.Corr;
MAE_Actual_Fold0 = Prediction_Fold0.MAE;
Index_Fold0 = Prediction_Fold0.Index + 1;
Prediction_Fold1 = load([AgePrediction_ResFolder '/Fold_1_Score.mat']);
Corr_Actual_Fold1 = Prediction_Fold1.Corr;
MAE_Actual_Fold1 = Prediction_Fold1.MAE;
Index_Fold1 = Prediction_Fold1.Index + 1;

Behavior = load([PredictionFolder '/Behavior_693.mat']);
% Fold 0
Age_Fold0 = Behavior.AgeYears(Index_Fold0);
Sex_Fold0 = Behavior.Sex(Index_Fold0);
Motion_Fold0 = Behavior.Motion(Index_Fold0);
% Fold 1
Age_Fold1 = Behavior.AgeYears(Index_Fold1);
Sex_Fold1 = Behavior.Sex(Index_Fold1);
Motion_Fold1 = Behavior.Motion(Index_Fold1);

[ParCorr_Actual_Fold0, ~] = partialcorr(Prediction_Fold0.Predict_Score', Age_Fold0, ...
    [double(Sex_Fold0) double(Motion_Fold0)]);
[ParCorr_Actual_Fold1, ~] = partialcorr(Prediction_Fold1.Predict_Score', Age_Fold1, ...
    [double(Sex_Fold1) double(Motion_Fold1)]);
mean([ParCorr_Actual_Fold0 ParCorr_Actual_Fold1]);

%% Significance
AgePrediction_PermutationFolder = [PredictionFolder '/AtlasLabel_Kong/2Fold_Sort_Permutation_Age'];
% Fold 0
Permutation_Fold0_Cell = g_ls([AgePrediction_PermutationFolder '/Time_*/Fold_0_Score.mat']);
for i = 1:1000
  tmp = load(Permutation_Fold0_Cell{i});
  ParCorr_Rand_Fold0(i) = partialcorr(tmp.Predict_Score', Age_Fold0, ...
            [double(Sex_Fold0) double(Motion_Fold0)]);
  MAE_Rand_Fold0(i) = tmp.MAE;
end
ParCorr_Fold0_Sig = length(find(ParCorr_Rand_Fold0 >= ParCorr_Actual_Fold0)) / 1000;
MAE_Fold0_Sig = length(find(MAE_Rand_Fold0 <= MAE_Actual_Fold0)) / 1000;
save([PredictionFolder '/AtlasLabel_Kong/2Fold_Sort_Fold0_Specificity_Sig_Age.mat'], 'ParCorr_Actual_Fold0', 'ParCorr_Rand_Fold0', 'ParCorr_Fold0_Sig', 'MAE_Actual_Fold0', 'MAE_Rand_Fold0', 'MAE_Fold0_Sig');
% Fold 1
Permutation_Fold1_Cell = g_ls([AgePrediction_PermutationFolder '/Time_*/Fold_1_Score.mat']);
for i = 1:1000
  tmp = load(Permutation_Fold1_Cell{i});
  ParCorr_Rand_Fold1(i) = partialcorr(tmp.Predict_Score', Age_Fold1, ...
             [double(Sex_Fold1) double(Motion_Fold1)]);
  MAE_Rand_Fold1(i) = tmp.MAE;
end
ParCorr_Fold1_Sig = length(find(ParCorr_Rand_Fold1 >= ParCorr_Actual_Fold1)) / 1000;
MAE_Fold1_Sig = length(find(MAE_Rand_Fold1 <= MAE_Actual_Fold1)) / 1000;
save([PredictionFolder '/AtlasLabel_Kong/2Fold_Sort_Fold1_Specificity_Sig_Age.mat'], 'ParCorr_Actual_Fold1', 'ParCorr_Rand_Fold1', 'ParCorr_Fold1_Sig', 'MAE_Actual_Fold1', 'MAE_Rand_Fold1', 'MAE_Fold1_Sig');


