
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
SpinTest_Folder = [ReplicationFolder '/Revision/Atlas_Homogeneity_Reliability/PermuteData_SpinTest'];
ID_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'], 1, 0);
BBLID = ID_Info(:, 1);
PermuteData_Folder = [SpinTest_Folder '/PermuteData'];
mkdir(PermuteData_Folder);
Configuration_Folder = [SpinTest_Folder '/Configuration'];
mkdir(Configuration_Folder);

for i = 1:length(BBLID)
  i
  AtlasLabel_lh_CSV_Path = [SpinTest_Folder '/Input/AtlasLabel_lh_' num2str(BBLID(i)) '.csv'];
  AtlasLabel_rh_CSV_Path = [SpinTest_Folder '/Input/AtlasLabel_rh_' num2str(BBLID(i)) '.csv'];
  AtlasLabel_Perm_File = [PermuteData_Folder '/AtlasLabel_Perm_' num2str(BBLID(i)) '.mat'];

  if ~exist(AtlasLabel_Perm_File)
    [~, JobRunning_Number_Str] = system('qstat | wc -l');
    JobRunning_Number = str2num(JobRunning_Number_Str(1:2));
    while JobRunning_Number > 32
      [~, JobRunning_Number_Str] = system('qstat | wc -l');
      JobRunning_Number = str2num(JobRunning_Number_Str(1:2));
    end

    if ~exist(AtlasLabel_Perm_File, 'file')
      Configuration_File = [Configuration_Folder '/Configuration_' num2str(i) '.mat'];
      save(Configuration_File, 'AtlasLabel_lh_CSV_Path', 'AtlasLabel_rh_CSV_Path', 'AtlasLabel_Perm_File');

      ScriptPath = [Configuration_Folder '/Script_' num2str(i) '.sh'];
      Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
         '"addpath(genpath(''' ReplicationFolder '/Toolbox'')),' ...
         'addpath(genpath(''' ReplicationFolder '/scripts'')),' ...
         'load(''' Configuration_File '''),' ...
         'SpinPermuFS(AtlasLabel_lh_CSV_Path, AtlasLabel_rh_CSV_Path, 1000, AtlasLabel_Perm_File),' ...
         'exit(1)">"' Configuration_Folder '/log_' num2str(i) '" 2>&1'];
      fid = fopen(ScriptPath, 'w');
      fprintf(fid, Cmd);
      system(['sh ' ScriptPath]);
    end
  end
end

% Spin permutation for group atlas
AtlasLabel_lh_CSV_Path = [SpinTest_Folder '/Input/GroupAtlasLabel_lh.csv'];
AtlasLabel_rh_CSV_Path = [SpinTest_Folder '/Input/GroupAtlasLabel_rh.csv'];
AtlasLabel_Perm_File = [PermuteData_Folder '/GroupAtlasLabel_Perm.mat'];
Configuration_File = [Configuration_Folder '/Configuration_Group.mat'];
save(Configuration_File, 'AtlasLabel_lh_CSV_Path', 'AtlasLabel_rh_CSV_Path', 'AtlasLabel_Perm_File');
ScriptPath = [Configuration_Folder '/Script_Group.sh'];
Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
      '"addpath(genpath(''' ReplicationFolder '/Toolbox'')),' ...
      'addpath(genpath(''' ReplicationFolder '/scripts'')),' ...
      'load(''' Configuration_File '''),' ...
      'SpinPermuFS(AtlasLabel_lh_CSV_Path, AtlasLabel_rh_CSV_Path, 1000, AtlasLabel_Perm_File),' ...
      'exit(1)">"' Configuration_Folder '/log_Group" 2>&1'];
fid = fopen(ScriptPath, 'w');
fprintf(fid, Cmd);
system(['sh ' ScriptPath]);
