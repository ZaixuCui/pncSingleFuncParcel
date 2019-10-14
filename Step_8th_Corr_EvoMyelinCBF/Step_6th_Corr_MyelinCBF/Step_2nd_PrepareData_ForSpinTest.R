
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
WorkingFolder = paste0(ReplicationFolder, '/Revision/Corr_EvoMyelinCBF/Corr_MyelinCBF');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

Myelin_Mat = readMat(paste0(WorkingFolder, '/Myelin.mat'));

Myelin_lh_CSV = data.frame(Myelin_lh = Myelin_Mat$Myelin.lh);
write.table(Myelin_lh_CSV, paste0(SpinTest_Folder, '/Myelin_lh.csv'), row.names = FALSE, col.names = FALSE);
Myelin_rh_CSV = data.frame(Myelin_rh = Myelin_Mat$Myelin.rh);
write.table(Myelin_rh_CSV, paste0(SpinTest_Folder, '/Myelin_rh.csv'), row.names = FALSE, col.names = FALSE);


