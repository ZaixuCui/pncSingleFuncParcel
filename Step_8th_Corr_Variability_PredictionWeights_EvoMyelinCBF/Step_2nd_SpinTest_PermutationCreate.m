
clear
SpinTest_Folder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu/Corr_EvoMyelinCBF/PermuteData_SpinTest';

% Variability, 17 systems mean
Variability_lh_CSV_Path = [SpinTest_Folder '/VariabilityLoading_17SystemMean_lh.csv'];
Variability_rh_CSV_Path = [SpinTest_Folder '/VariabilityLoading_17SystemMean_rh.csv'];
Variability_Perm_File = [SpinTest_Folder '/VariabilityLoading_17SystemMean_Perm.mat'];
SpinPermuFS(Variability_lh_CSV_Path, Variability_rh_CSV_Path, 1000, Variability_Perm_File);

% Age Prediction
AgePrediction_lh_CSV_Path = [SpinTest_Folder '/AgePredictionWeight_lh.csv'];
AgePrediction_rh_CSV_Path = [SpinTest_Folder '/AgePredictionWeight_rh.csv'];
AgePrediction_Perm_File = [SpinTest_Folder '/AgePredictionWeight_Perm.mat'];
SpinPermuFS(AgePrediction_lh_CSV_Path, AgePrediction_rh_CSV_Path, 1000, AgePrediction_Perm_File);

% EF Prediction
EFPrediction_lh_CSV_Path = [SpinTest_Folder '/EFPredictionWeight_lh.csv'];
EFPrediction_rh_CSV_Path = [SpinTest_Folder '/EFPredictionWeight_rh.csv'];
EFPrediction_Perm_File = [SpinTest_Folder '/EFPredictionWeight_Perm.mat'];
SpinPermuFS(EFPrediction_lh_CSV_Path, EFPrediction_rh_CSV_Path, 1000, EFPrediction_Perm_File);

