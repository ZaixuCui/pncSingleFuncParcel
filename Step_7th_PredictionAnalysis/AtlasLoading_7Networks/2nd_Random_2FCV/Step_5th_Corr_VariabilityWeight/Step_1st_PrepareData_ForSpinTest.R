
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
Parcellation_7Networks_Folder = paste0(ReplicationFolder, '/Revision/SingleParcellation_7Networks/SingleAtlas_Analysis');
VariabilityLoading_7SystemMean_Mat = readMat(paste0(Parcellation_7Networks_Folder,
                       '/Variability_Visualize/VariabilityLoading_Median_7SystemMean.mat'));

PredictionFolder = paste0(ReplicationFolder, '/Revision/PredictionAnalysis/AtlasLoading_7Networks');
w_Brain_Age_Abs_Sum_Mat = readMat(paste0(PredictionFolder, '/WeightVisualize_Age_RandomCV/w_Brain_Age_Abs_sum.mat'));
w_Brain_EFAccuracy_Abs_Sum_Mat = readMat(paste0(PredictionFolder, '/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy_Abs_sum.mat'));

SNR_Mask_Mat = readMat(paste0(ReplicationFolder, '/data/SNR_Mask/subjects/fsaverage5/SNR_Mask.mat'));
SNR_Mask_lh = SNR_Mask_Mat$SNR.Mask.lh;
SNR_Mask_rh = SNR_Mask_Mat$SNR.Mask.rh;

WorkingFolder = paste0(PredictionFolder, '/Corr_Variability_AgePredictionWeights');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

VariabilityLoading_lh_Data = t(VariabilityLoading_7SystemMean_Mat$VariabilityLoading.Median.7SystemMean.lh);
VariabilityLoading_lh_Data[which(SNR_Mask_lh == 0)] = 100;
VariabilityLoading_rh_Data = t(VariabilityLoading_7SystemMean_Mat$VariabilityLoading.Median.7SystemMean.rh);
VariabilityLoading_rh_Data[which(SNR_Mask_rh == 0)] = 100;

AgePredictionWeight_lh_Data = w_Brain_Age_Abs_Sum_Mat$w.Brain.Age.Abs.sum.lh;
AgePredictionWeight_lh_Data[which(SNR_Mask_lh == 0)] = 100;
AgePredictionWeight_rh_Data = w_Brain_Age_Abs_Sum_Mat$w.Brain.Age.Abs.sum.rh;
AgePredictionWeight_rh_Data[which(SNR_Mask_rh == 0)] = 100;

EFPredictionWeight_lh_Data = w_Brain_EFAccuracy_Abs_Sum_Mat$w.Brain.EFAccuracy.Abs.sum.lh;
EFPredictionWeight_lh_Data[which(SNR_Mask_lh == 0)] = 100;
EFPredictionWeight_rh_Data = w_Brain_EFAccuracy_Abs_Sum_Mat$w.Brain.EFAccuracy.Abs.sum.rh;
EFPredictionWeight_rh_Data[which(SNR_Mask_rh == 0)] = 100;

VariabilityLoading_7SystemMean_lh_CSV = data.frame(VariabilityLoading_lh = VariabilityLoading_lh_Data);
write.table(VariabilityLoading_7SystemMean_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLoading_7SystemMean_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLoading_7SystemMean_rh_CSV = data.frame(VariabilityLoading_rh = VariabilityLoading_rh_Data);
write.table(VariabilityLoading_7SystemMean_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLoading_7SystemMean_rh.csv'), row.names = FALSE, col.names = FALSE);

w_Brain_Age_Abs_Sum_lh_CSV = data.frame(w_Brain_Age_Abs_Sum_lh = AgePredictionWeight_lh_Data);
write.table(w_Brain_Age_Abs_Sum_lh_CSV, paste0(SpinTest_Folder, '/w_Brain_Age_Abs_Sum_lh.csv'), row.names = FALSE, col.names = FALSE);
w_Brain_Age_Abs_Sum_rh_CSV = data.frame(w_Brain_Age_Abs_Sum_rh = AgePredictionWeight_rh_Data);
write.table(w_Brain_Age_Abs_Sum_rh_CSV, paste0(SpinTest_Folder, '/w_Brain_Age_Abs_Sum_rh.csv'), row.names = FALSE, col.names = FALSE);

w_Brain_EFAccuracy_Abs_Sum_lh_CSV = data.frame(w_Brain_EFAccuracy_Abs_Sum_lh = EFPredictionWeight_lh_Data);
write.table(w_Brain_EFAccuracy_Abs_Sum_lh_CSV, paste0(SpinTest_Folder, '/w_Brain_EFAccuracy_Abs_Sum_lh.csv'), row.names = FALSE, col.names = FALSE);
w_Brain_EFAccuracy_Abs_Sum_rh_CSV = data.frame(w_Brain_EFAccuracy_Abs_Sum_rh = EFPredictionWeight_rh_Data);
write.table(w_Brain_EFAccuracy_Abs_Sum_rh_CSV, paste0(SpinTest_Folder, '/w_Brain_EFAccuracy_Abs_Sum_rh.csv'), row.names = FALSE, col.names = FALSE);

