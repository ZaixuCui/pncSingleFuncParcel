
clear
SpinTest_Folder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu/PredictionAnalysis/AtlasLabel_Kong/Corr_Variability_AgePredictionWeights/PermuteData_SpinTest';

% Variability, LabelAtlas
Variability_lh_CSV_Path = [SpinTest_Folder '/VariabilityLabel_Kong_lh.csv'];
Variability_rh_CSV_Path = [SpinTest_Folder '/VariabilityLabel_Kong_rh.csv'];
Variability_Perm_File = [SpinTest_Folder '/VariabilityLabel_Perm_Kong.mat'];
SpinPermuFS(Variability_lh_CSV_Path, Variability_rh_CSV_Path, 1000, Variability_Perm_File);

% Age weights, Kong
AgeWeights_Kong_lh_CSV_Path = [SpinTest_Folder '/AgeWeights_Kong_lh.csv'];
AgeWeights_Kong_rh_CSV_Path = [SpinTest_Folder '/AgeWeights_Kong_rh.csv'];
AgeWeights_Kong_Perm_File = [SpinTest_Folder '/AgeWeights_Perm_Kong.mat'];
SpinPermuFS(AgeWeights_Kong_lh_CSV_Path, AgeWeights_Kong_rh_CSV_Path, 1000, AgeWeights_Kong_Perm_File);

% EF weights, Kong
EFWeights_Kong_lh_CSV_Path = [SpinTest_Folder '/EFWeights_Kong_lh.csv'];
EFWeights_Kong_rh_CSV_Path = [SpinTest_Folder '/EFWeights_Kong_rh.csv'];
EFWeights_Kong_Perm_File = [SpinTest_Folder '/EFWeights_Perm_Kong.mat'];
SpinPermuFS(EFWeights_Kong_lh_CSV_Path, EFWeights_Kong_rh_CSV_Path, 1000, EFWeights_Kong_Perm_File);

