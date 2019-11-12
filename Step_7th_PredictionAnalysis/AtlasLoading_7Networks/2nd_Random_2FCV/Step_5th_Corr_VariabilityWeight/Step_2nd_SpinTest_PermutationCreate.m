
clear
SpinTest_Folder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu/PredictionAnalysis/AtlasLoading_7Networks/Corr_Variability_AgePredictionWeights/PermuteData_SpinTest';

% Variability, 7 systems mean
Variability_lh_CSV_Path = [SpinTest_Folder '/VariabilityLoading_7SystemMean_lh.csv'];
Variability_rh_CSV_Path = [SpinTest_Folder '/VariabilityLoading_7SystemMean_rh.csv'];
Variability_Perm_File = [SpinTest_Folder '/VariabilityLoading_7SystemMean_Perm.mat'];
SpinPermuFS(Variability_lh_CSV_Path, Variability_rh_CSV_Path, 1000, Variability_Perm_File);

% Age Weight
w_Brain_Age_Abs_Sum_lh_CSV_Path = [SpinTest_Folder '/w_Brain_Age_Abs_Sum_lh.csv'];
w_Brain_Age_Abs_Sum_rh_CSV_path = [SpinTest_Folder '/w_Brain_Age_Abs_Sum_rh.csv'];
w_Brain_Age_Abs_Sum_Perm_File = [SpinTest_Folder '/w_Brain_Age_Abs_Sum_Perm.mat'];
SpinPermuFS(w_Brain_Age_Abs_Sum_lh_CSV_Path, w_Brain_Age_Abs_Sum_rh_CSV_path, 1000, w_Brain_Age_Abs_Sum_Perm_File);

% Cognition Weight
w_Brain_EFAccuracy_Abs_Sum_lh_CSV_Path = [SpinTest_Folder '/w_Brain_EFAccuracy_Abs_Sum_lh.csv'];
w_Brain_EFAccuracy_Abs_Sum_rh_CSV_path = [SpinTest_Folder '/w_Brain_EFAccuracy_Abs_Sum_rh.csv'];
w_Brain_EFAccuracy_Abs_Sum_Perm_File = [SpinTest_Folder '/w_Brain_EFAccuracy_Abs_Sum_Perm.mat'];
SpinPermuFS(w_Brain_EFAccuracy_Abs_Sum_lh_CSV_Path, w_Brain_EFAccuracy_Abs_Sum_rh_CSV_path, 1000, w_Brain_EFAccuracy_Abs_Sum_Perm_File);

