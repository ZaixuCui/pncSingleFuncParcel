
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/Revision');
VariabilityLabel_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLabel.mat'));

SNR_Mask_Mat = readMat(paste0(ReplicationFolder, '/data/SNR_Mask/subjects/fsaverage5/SNR_Mask.mat'));
SNR_Mask_lh = SNR_Mask_Mat$SNR.Mask.lh;
SNR_Mask_rh = SNR_Mask_Mat$SNR.Mask.rh;

WorkingFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel/Corr_Variability_AgePredictionWeights');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

VariabilityLabel_lh_Data = t(VariabilityLabel_Mat$VariabilityLabel.lh);
VariabilityLabel_lh_Data[which(SNR_Mask_lh == 0)] = 100;
VariabilityLabel_rh_Data = t(VariabilityLabel_Mat$VariabilityLabel.rh);
VariabilityLabel_rh_Data[which(SNR_Mask_rh == 0)] = 100;

VariabilityLabel_lh_CSV = data.frame(VariabilityLabel_lh = VariabilityLabel_lh_Data);
write.table(VariabilityLabel_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLabel_rh_CSV = data.frame(VariabilityLabel_rh = VariabilityLabel_rh_Data);
write.table(VariabilityLabel_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_rh.csv'), row.names = FALSE, col.names = FALSE);

