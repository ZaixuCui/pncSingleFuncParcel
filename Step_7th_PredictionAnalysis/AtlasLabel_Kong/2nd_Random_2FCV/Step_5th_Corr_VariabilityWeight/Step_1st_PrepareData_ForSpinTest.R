
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/Revision');
VariabilityLabel_Mat = readMat(paste0(ResultsFolder, '/SingleParcellation_Kong/WorkingFolder/Variability_Visualize/Variability.mat'));

WorkingFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel_Kong/Corr_Variability_AgePredictionWeights');
SpinTest_Folder = paste0(WorkingFolder, '/PermuteData_SpinTest');
dir.create(SpinTest_Folder, recursive = TRUE);

# Variability
VariabilityLabel_lh_CSV = data.frame(VariabilityLabel_lh = 
                                  t(VariabilityLabel_Mat$Variability.lh));
write.table(VariabilityLabel_lh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_Kong_lh.csv'), row.names = FALSE, col.names = FALSE);
VariabilityLabel_rh_CSV = data.frame(VariabilityLabel_rh = 
                                  t(VariabilityLabel_Mat$Variability.rh));
write.table(VariabilityLabel_rh_CSV, paste0(SpinTest_Folder, '/VariabilityLabel_Kong_rh.csv'), row.names = FALSE, col.names = FALSE);

# Age weights
AgeWeights_Mat = readMat(paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel_Kong/WeightVisualize_Age_RandomCV/w_Brain_Age.mat'));
AgeWeights_lh_CSV = data.frame(AgeWeights_lh = t(AgeWeights_Mat$w.Brain.Age.lh));
write.table(AgeWeights_lh_CSV, paste0(SpinTest_Folder, '/AgeWeights_Kong_lh.csv'), row.names = FALSE, col.names = FALSE);
AgeWeights_rh_CSV = data.frame(AgeWeights_rh = t(AgeWeights_Mat$w.Brain.Age.rh));
write.table(AgeWeights_rh_CSV, paste0(SpinTest_Folder, '/AgeWeights_Kong_rh.csv'), row.names = FALSE, col.names = FALSE);

# EF weights
EFWeights_Mat = readMat(paste0(ResultsFolder, '/PredictionAnalysis/AtlasLabel_Kong/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy.mat'));
EFWeights_lh_CSV = data.frame(EFWeights_lh = t(EFWeights_Mat$w.Brain.EFAccuracy.lh));
write.table(EFWeights_lh_CSV, paste0(SpinTest_Folder, '/EFWeights_Kong_lh.csv'), row.names = FALSE, col.names = FALSE);
EFWeights_rh_CSV = data.frame(EFWeights_rh = t(EFWeights_Mat$w.Brain.EFAccuracy.rh));
write.table(EFWeights_rh_CSV, paste0(SpinTest_Folder, '/EFWeights_Kong_rh.csv'), row.names = FALSE, col.names = FALSE);


