
clear
SpinTest_Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Corr_EvoMyelinCBF/PermuteData_SpinTest';

% Variability, 17 systems mean
Variability_lh_CSV_Path = [SpinTest_Folder '/VariabilityLoading_17SystemMean_lh.csv'];
Variability_rh_CSV_Path = [SpinTest_Folder '/VariabilityLoading_17SystemMean_rh.csv'];
Variability_Perm_File = [SpinTest_Folder '/VariabilityLoading_17SystemMean_Perm.mat'];
SpinPermuFS(Variability_lh_CSV_Path, Variability_rh_CSV_Path, 1000, Variability_Perm_File);

