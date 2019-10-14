
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/Revision');
VariabilityLabel_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLabel.mat'));
VariabilityLoading_17SystemMean_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLoading_Median_17SystemMean.mat'));

WorkingFolder = paste0(ResultsFolder, '/Corr_EvoMyelinCBF');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

VariabilityLoading_17SystemMean_lh_CSV = data.frame(VariabilityLoading_lh = 
                                  t(VariabilityLoading_17SystemMean_Mat$VariabilityLoading.Median.17SystemMean.lh));
write.table(VariabilityLoading_17SystemMean_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLoading_17SystemMean_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLoading_17SystemMean_rh_CSV = data.frame(VariabilityLoading_rh = 
                                  t(VariabilityLoading_17SystemMean_Mat$VariabilityLoading.Median.17SystemMean.rh));
write.table(VariabilityLoading_17SystemMean_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLoading_17SystemMean_rh.csv'), row.names = FALSE, col.names = FALSE);

