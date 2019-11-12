
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/Revision');
VariabilityLabel_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation_Kong/WorkingFolder/Variability_Visualize/Variability.mat'));
AgeWeights_Mat = readMat(paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel_Kong/WeightVisualize_Age_RandomCV/w_Brain_Age.mat'));
EFWeights_Mat = readMat(paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel_Kong/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy.mat'));

SNR_Mask_Mat = readMat(paste0(ReplicationFolder, '/data/SNR_Mask/subjects/fsaverage5/SNR_Mask.mat'));
SNR_Mask_lh = SNR_Mask_Mat$SNR.Mask.lh;
SNR_Mask_rh = SNR_Mask_Mat$SNR.Mask.rh;

WorkingFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel_Kong/Corr_Variability_AgePredictionWeights');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

VariabilityLabel_lh_Data = t(VariabilityLabel_Mat$Variability.lh);
VariabilityLabel_lh_Data[which(SNR_Mask_lh == 0)] = 100;
VariabilityLabel_rh_Data = t(VariabilityLabel_Mat$Variability.rh);
VariabilityLabel_rh_Data[which(SNR_Mask_rh == 0)] = 100;

AgePredictionWeight_lh_Data = t(AgeWeights_Mat$w.Brain.Age.lh);
AgePredictionWeight_lh_Data[which(SNR_Mask_lh == 0)] = 100;
AgePredictionWeight_rh_Data = t(AgeWeights_Mat$w.Brain.Age.rh);
AgePredictionWeight_rh_Data[which(SNR_Mask_rh == 0)] = 100;

EFPredictionWeight_lh_Data = t(EFWeights_Mat$w.Brain.EFAccuracy.lh);
EFPredictionWeight_lh_Data[which(SNR_Mask_lh == 0)] = 100;
EFPredictionWeight_rh_Data = t(EFWeights_Mat$w.Brain.EFAccuracy.rh);
EFPredictionWeight_rh_Data[which(SNR_Mask_rh == 0)] = 100;

# Variability
VariabilityLabel_lh_CSV = data.frame(VariabilityLabel_lh = VariabilityLabel_lh_Data);
write.table(VariabilityLabel_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_Kong_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLabel_rh_CSV = data.frame(VariabilityLabel_rh = VariabilityLabel_rh_Data);
write.table(VariabilityLabel_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_Kong_rh.csv'), row.names = FALSE, col.names = FALSE);

# Age weights
AgeWeights_lh_CSV = data.frame(AgeWeights_lh = AgePredictionWeight_lh_Data);
write.table(AgeWeights_lh_CSV, paste0(SpinTest_Folder, '/AgeWeights_Kong_lh.csv'), row.names = FALSE, col.names = FALSE);
AgeWeights_rh_CSV = data.frame(AgeWeights_rh = AgePredictionWeight_rh_Data);
write.table(AgeWeights_rh_CSV, paste0(SpinTest_Folder, '/AgeWeights_Kong_rh.csv'), row.names = FALSE, col.names = FALSE);

# EF weights
EFWeights_lh_CSV = data.frame(EFWeights_lh = EFPredictionWeight_lh_Data);
write.table(EFWeights_lh_CSV, paste0(SpinTest_Folder, '/EFWeights_Kong_lh.csv'), row.names = FALSE, col.names = FALSE);
EFWeights_rh_CSV = data.frame(EFWeights_rh = EFPredictionWeight_rh_Data);
write.table(EFWeights_rh_CSV, paste0(SpinTest_Folder, '/EFWeights_Kong_rh.csv'), row.names = FALSE, col.names = FALSE);

