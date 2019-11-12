
clear
SpinTest_Folder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu/PredictionAnalysis/AtlasLabel/Corr_Variability_AgePredictionWeights/PermuteData_SpinTest';

% Variability, LabelAtlas
Variability_lh_CSV_Path = [SpinTest_Folder '/VariabilityLabel_lh.csv'];
Variability_rh_CSV_Path = [SpinTest_Folder '/VariabilityLabel_rh.csv'];
Variability_Perm_File = [SpinTest_Folder '/VariabilityLabel_Perm.mat'];
SpinPermuFS(Variability_lh_CSV_Path, Variability_rh_CSV_Path, 1000, Variability_Perm_File);

