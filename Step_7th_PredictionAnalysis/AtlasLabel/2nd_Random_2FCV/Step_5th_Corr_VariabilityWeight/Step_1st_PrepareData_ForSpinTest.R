
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/Revision');
VariabilityLabel_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLabel.mat'));

WorkingFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel/Corr_Variability_AgePredictionWeights');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

VariabilityLabel_lh_CSV = data.frame(VariabilityLabel_lh = 
                                  t(VariabilityLabel_Mat$VariabilityLabel.lh));
write.table(VariabilityLabel_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLabel_rh_CSV = data.frame(VariabilityLabel_rh = 
                                  t(VariabilityLabel_Mat$VariabilityLabel.rh));
write.table(VariabilityLabel_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_rh.csv'), row.names = FALSE, col.names = FALSE);

