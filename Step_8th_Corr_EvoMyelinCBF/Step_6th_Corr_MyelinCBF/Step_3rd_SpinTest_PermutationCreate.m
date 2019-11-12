
clear
SpinTest_Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Corr_EvoMyelinCBF/Corr_MyelinCBF/PermuteData_SpinTest';

% Myelin
Myelin_lh_CSV_Path = [SpinTest_Folder '/Myelin_lh.csv'];
Myelin_rh_CSV_Path = [SpinTest_Folder '/Myelin_rh.csv'];
Myelin_Perm_File = [SpinTest_Folder '/Myelin_Perm.mat'];
SpinPermuFS(Myelin_lh_CSV_Path, Myelin_rh_CSV_Path, 1000, Myelin_Perm_File);

