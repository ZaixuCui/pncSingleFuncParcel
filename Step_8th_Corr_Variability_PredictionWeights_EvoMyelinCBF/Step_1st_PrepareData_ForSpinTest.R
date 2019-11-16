
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/Revision');
VariabilityLabel_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLabel.mat'));
VariabilityLoading_17SystemMean_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLoading_Median_17SystemMean.mat'));
AgePredictionWeight_Mat = readMat(paste0(ResultsFolder, '/PredictionAnalysis/AtlasLoading/WeightVisualize_Age_RandomCV/w_Brain_Age_Abs_sum.mat'));
EFPredictionWeight_Mat = readMat(paste0(ResultsFolder, '/PredictionAnalysis/AtlasLoading/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy_Abs_sum.mat'));

SNR_Mask_Mat = readMat(paste0(ReplicationFolder, '/data/SNR_Mask/subjects/fsaverage5/SNR_Mask.mat'));
SNR_Mask_lh = SNR_Mask_Mat$SNR.Mask.lh;
SNR_Mask_rh = SNR_Mask_Mat$SNR.Mask.rh;

VariabilityLoading_lh_Data = VariabilityLoading_17SystemMean_Mat$VariabilityLoading.Median.17SystemMean.lh;
VariabilityLoading_lh_Data[which(SNR_Mask_lh == 0)] = 100;
VariabilityLoading_rh_Data = VariabilityLoading_17SystemMean_Mat$VariabilityLoading.Median.17SystemMean.rh;
VariabilityLoading_rh_Data[which(SNR_Mask_rh == 0)] = 100;

AgePredictionWeight_lh_Data = AgePredictionWeight_Mat$w.Brain.Age.Abs.sum.lh;
AgePredictionWeight_lh_Data[which(SNR_Mask_lh == 0)] = 100;
AgePredictionWeight_rh_Data = AgePredictionWeight_Mat$w.Brain.Age.Abs.sum.rh;
AgePredictionWeight_rh_Data[which(SNR_Mask_rh == 0)] = 100;

EFPredictionWeight_lh_Data = EFPredictionWeight_Mat$w.Brain.EFAccuracy.Abs.sum.lh;
EFPredictionWeight_lh_Data[which(SNR_Mask_lh == 0)] = 100;
EFPredictionWeight_rh_Data = EFPredictionWeight_Mat$w.Brain.EFAccuracy.Abs.sum.rh;
EFPredictionWeight_rh_Data[which(SNR_Mask_rh == 0)] = 100;

WorkingFolder = paste0(ResultsFolder, '/Corr_EvoMyelinCBF');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

VariabilityLoading_17SystemMean_lh_CSV = data.frame(VariabilityLoading_lh = t(VariabilityLoading_lh_Data));
write.table(VariabilityLoading_17SystemMean_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLoading_17SystemMean_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLoading_17SystemMean_rh_CSV = data.frame(VariabilityLoading_rh = t(VariabilityLoading_rh_Data));
write.table(VariabilityLoading_17SystemMean_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLoading_17SystemMean_rh.csv'), row.names = FALSE, col.names = FALSE);

AgePredictionWeight_lh_CSV = data.frame(AgePredictionWeight_lh = t(AgePredictionWeight_lh_Data));
write.table(AgePredictionWeight_lh_CSV, paste0(SpinTest_Folder, '/AgePredictionWeight_lh.csv'), row.names = FALSE, col.names = FALSE);
AgePredictionWeight_rh_CSV = data.frame(AgePredictionWeight_rh = t(AgePredictionWeight_rh_Data));
write.table(AgePredictionWeight_rh_CSV, paste0(SpinTest_Folder, '/AgePredictionWeight_rh.csv'), row.names = FALSE, col.names = FALSE);

EFPredictionWeight_lh_CSV = data.frame(EFPredictionWeight_lh = t(EFPredictionWeight_lh_Data));
write.table(EFPredictionWeight_lh_CSV, paste0(SpinTest_Folder, '/EFPredictionWeight_lh.csv'), row.names = FALSE, col.names = FALSE);
EFPredictionWeight_rh_CSV = data.frame(EFPredictionWeight_rh = t(EFPredictionWeight_rh_Data));
write.table(EFPredictionWeight_rh_CSV, paste0(SpinTest_Folder, '/EFPredictionWeight_rh.csv'), row.names = FALSE, col.names = FALSE);

