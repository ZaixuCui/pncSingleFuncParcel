
clear
SpinTest_Folder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu/Corr_EvoMyelinCBF/BetweenCorr_MyelinCBF/PermuteData_SpinTest';

% Myelin
Myelin_lh_CSV_Path = [SpinTest_Folder '/Myelin_lh.csv'];
Myelin_rh_CSV_Path = [SpinTest_Folder '/Myelin_rh.csv'];
Myelin_Perm_File = [SpinTest_Folder '/Myelin_Perm.mat'];
SpinPermuFS(Myelin_lh_CSV_Path, Myelin_rh_CSV_Path, 1000, Myelin_Perm_File);

% Mean CBF
MeanCBF_lh_CSV_Path = [SpinTest_Folder '/MeanCBF_lh.csv'];
MeanCBF_rh_CSV_Path = [SpinTest_Folder '/MeanCBF_rh.csv'];
MeanCBF_Perm_File = [SpinTest_Folder '/MeanCBF_Perm.mat'];
SpinPermuFS(MeanCBF_lh_CSV_Path, MeanCBF_rh_CSV_Path, 1000, MeanCBF_Perm_File);

