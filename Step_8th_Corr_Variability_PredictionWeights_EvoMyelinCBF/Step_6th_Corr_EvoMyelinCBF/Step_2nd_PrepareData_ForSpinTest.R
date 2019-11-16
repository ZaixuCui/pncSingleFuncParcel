
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
WorkingFolder = paste0(ReplicationFolder, '/Revision/Corr_EvoMyelinCBF/BetweenCorr_MyelinCBF');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

SNR_Mask_Mat = readMat(paste0(ReplicationFolder, '/data/SNR_Mask/subjects/fsaverage5/SNR_Mask.mat'));
SNR_Mask_lh = SNR_Mask_Mat$SNR.Mask.lh;
SNR_Mask_rh = SNR_Mask_Mat$SNR.Mask.rh;

Myelin_Mat = readMat(paste0(WorkingFolder, '/Myelin.mat'));
Myelin_lh_Data = Myelin_Mat$Myelin.lh;
Myelin_lh_Data[which(SNR_Mask_lh == 0)] = 100;
Myelin_rh_Data = Myelin_Mat$Myelin.rh;
Myelin_rh_Data[which(SNR_Mask_rh == 0)] = 100;

Myelin_lh_CSV = data.frame(Myelin_lh = Myelin_lh_Data);
write.table(Myelin_lh_CSV, paste0(SpinTest_Folder, '/Myelin_lh.csv'), row.names = FALSE, col.names = FALSE);
Myelin_rh_CSV = data.frame(Myelin_rh = Myelin_rh_Data);
write.table(Myelin_rh_CSV, paste0(SpinTest_Folder, '/Myelin_rh.csv'), row.names = FALSE, col.names = FALSE);

MeanCBF_Mat = readMat(paste0(WorkingFolder, '/MeanCBF.mat'));
MeanCBF_lh_Data = MeanCBF_Mat$MeanCBF.lh;
MeanCBF_lh_Data[which(SNR_Mask_lh == 0)] = 100;
MeanCBF_rh_Data = MeanCBF_Mat$MeanCBF.rh;
MeanCBF_rh_Data[which(SNR_Mask_rh == 0)] = 100;

MeanCBF_lh_CSV = data.frame(MeanCBF_lh = MeanCBF_lh_Data);
write.table(MeanCBF_lh_CSV, paste0(SpinTest_Folder, '/MeanCBF_lh.csv'), row.names = FALSE, col.names = FALSE);
MeanCBF_rh_CSV = data.frame(MeanCBF_rh = MeanCBF_rh_Data);
write.table(MeanCBF_rh_CSV, paste0(SpinTest_Folder, '/MeanCBF_rh.csv'), row.names = FALSE, col.names = FALSE);

