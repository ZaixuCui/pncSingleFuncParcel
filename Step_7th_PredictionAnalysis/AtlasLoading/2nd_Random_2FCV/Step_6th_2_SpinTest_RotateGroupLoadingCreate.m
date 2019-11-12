
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ParcellationFolder = [ReplicationFolder '/Revision/SingleParcellation/SingleAtlas_Analysis'];
SpinTest_Folder = [ParcellationFolder '/Group_AtlasLoading_SpinPermutateData'];
InputFolder = [SpinTest_Folder '/Input'];
PermuteData_Folder = [SpinTest_Folder '/PermuteData'];
mkdir(PermuteData_Folder);
Configuration_Folder = [SpinTest_Folder '/Configuration'];
mkdir(Configuration_Folder);

for i = 1:17
  i
  AtlasLoading_lh_CSV_Path = [SpinTest_Folder '/Input/AtlasLoading_lh_Network_' num2str(i) '.csv'];
  AtlasLoading_rh_CSV_Path = [SpinTest_Folder '/Input/AtlasLoading_rh_Network_' num2str(i) '.csv'];
  AtlasLoading_Perm_File = [PermuteData_Folder '/AtlasLoading_Network_' num2str(i) '.mat'];

  Configuration_File = [Configuration_Folder '/Configuration_Network_' num2str(i) '.mat'];
  save(Configuration_File, 'AtlasLoading_lh_CSV_Path', 'AtlasLoading_rh_CSV_Path', 'AtlasLoading_Perm_File');
  
  ScriptPath = [Configuration_Folder '/Script_Network_' num2str(i) '.sh'];
  Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
       '"addpath(genpath(''' ReplicationFolder '/Toolbox'')),' ...
       'addpath(genpath(''' ReplicationFolder '/scripts'')),' ...
       'load(''' Configuration_File '''),' ...
       'SpinPermuFS(AtlasLoading_lh_CSV_Path, AtlasLoading_rh_CSV_Path, 1000, AtlasLoading_Perm_File),' ...
       'exit(1)">"' Configuration_Folder '/log_' num2str(i) '" 2>&1'];
  fid = fopen(ScriptPath, 'w');
  fprintf(fid, Cmd);
  system(['sh ' ScriptPath]); 
end

% Run following codes after finishing the above
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
PermuteData_Folder = [ReplicationFolder '/Revision/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLoading_SpinPermutateData/PermuteData'];

SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
surfML = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/lh.Mask_SNR.label';
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/rh.Mask_SNR.label';
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

for i = 1:17
  i
  Permute_FilePath = [PermuteData_Folder '/AtlasLoading_Network_' num2str(i) '.mat'];
  tmpData_Mat = load(Permute_FilePath);
  bigrot_NoMedialWall = [tmpData_Mat.bigrotl(:, Index_l) tmpData_Mat.bigrotr(:, Index_r)];
  save(Permute_FilePath, 'bigrot_NoMedialWall', '-append');
end

