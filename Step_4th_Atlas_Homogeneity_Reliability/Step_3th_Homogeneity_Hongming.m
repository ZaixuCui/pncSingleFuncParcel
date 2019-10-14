
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Step 1: Homogeneity of hongming's single atlas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision'];
HongmingLabel_Folder = [ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLabel'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

ResultantFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/Homogeneity_Hongming'];
mkdir(ResultantFolder);
Combined_DataFolder = [ReplicationFolder '/data/CombinedData'];
for i = 1:length(BBLID)
  i
  Hongming_Mat_Path = [HongmingLabel_Folder '/' num2str(BBLID(i)) '.mat'];
  Image_lh_Path = [Combined_DataFolder '/' num2str(BBLID(i)) '/lh.fs5.sm6.residualised.mgh'];
  Image_rh_Path = [Combined_DataFolder '/' num2str(BBLID(i)) '/rh.fs5.sm6.residualised.mgh'];
  ResultantFile = [ResultantFolder '/Homogeneity_Label_' num2str(BBLID(i)) '.mat'];

  if ~exist(ResultantFile, 'file')
    ScriptFolder = [ResultantFolder '/Scripts'];
    mkdir(ScriptFolder);
    LogFolder = [ResultantFolder '/logs'];
    mkdir(LogFolder);
    ScriptPath = [ScriptFolder '/Homogeneity_Script_' num2str(i) '.sh'];
    Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox''));' ...
          'HongmingLabel_Data = load(''' Hongming_Mat_Path ''');' ...
          'sbj_AtlasLabel = [HongmingLabel_Data.sbj_AtlasLabel_lh HongmingLabel_Data.sbj_AtlasLabel_rh];' ... 
          'Data_lh = MRIread(''' Image_lh_Path ''');' ...
          'Data_lh = squeeze(Data_lh.vol);' ...
          'Data_rh = MRIread(''' Image_rh_Path ''');' ...
          'Data_rh = squeeze(Data_rh.vol);' ...
          'Data_All = [Data_lh; Data_rh];' ...
          'for j = 1:17, ' ...
          'System_Index{j} = find(sbj_AtlasLabel == j);' ...
          'Vertex_Quantity(j) = length(System_Index{j});' ...
          'TS_System = Data_All(System_Index{j}, :)'';' ...
          'Corr_WithinSystem = corr(TS_System);' ...
          'Corr_WithinSystem(find(eye(size(Corr_WithinSystem)))) = 0;' ...
          'Corr_WithinSystem_Avg(j) = sum(sum(Corr_WithinSystem)) / (Vertex_Quantity(j)*Vertex_Quantity(j)-Vertex_Quantity(j));' ...
          'end,' ...
          'TS_Homogeneity = mean(Corr_WithinSystem_Avg);' ...
          'save(''' ResultantFile ''',''TS_Homogeneity'',''Corr_WithinSystem_Avg'');' ...
          'exit(1)">"' ...
          LogFolder '/log_' num2str(i) '" 2>&1'];
    fid = fopen(ScriptPath, 'w');
    fprintf(fid, Cmd);
    system(['sh ' ScriptPath]);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 2: Homogeneity of randomized hongming atlas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision'];
HongmingSpin_Folder = [ResultsFolder '/Atlas_Homogeneity_Reliability/PermuteData_SpinTest/PermuteData'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

ResultantFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/PermuteData_SpinTest/HomogeneitySig'];
mkdir(ResultantFolder);
Combined_DataFolder = [ReplicationFolder '/data/CombinedData'];
for i = 1:length(BBLID)
  i

  [~, JobRunning_Number_Str] = system('qstat | wc -l');
  JobRunning_Number = str2num(JobRunning_Number_Str(1:2));
  while JobRunning_Number > 32
    [~, JobRunning_Number_Str] = system('qstat | wc -l');
    JobRunning_Number = str2num(JobRunning_Number_Str(1:2));
  end

  HongmingSpin_Mat_Path = [HongmingSpin_Folder '/AtlasLabel_Perm_' num2str(BBLID(i)) '.mat'];
  Image_lh_Path = [Combined_DataFolder '/' num2str(BBLID(i)) '/lh.fs5.sm6.residualised.mgh'];
  Image_rh_Path = [Combined_DataFolder '/' num2str(BBLID(i)) '/rh.fs5.sm6.residualised.mgh'];
  ResultantFile = [ResultantFolder '/Homogeneity_Spin_' num2str(BBLID(i)) '.mat'];

  if ~exist(ResultantFile, 'file')
    ScriptFolder = [ResultantFolder '/Scripts'];
    mkdir(ScriptFolder);
    LogFolder = [ResultantFolder '/logs'];
    mkdir(LogFolder);
    ScriptPath = [ScriptFolder '/Homogeneity_Script_' num2str(i) '.sh'];
    Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox''));' ...
          'HongmingSpin_Data = load(''' HongmingSpin_Mat_Path ''');' ...
          'HongmingSpin_Label = [HongmingSpin_Data.bigrotl HongmingSpin_Data.bigrotr];' ... 
          'Data_lh = MRIread(''' Image_lh_Path ''');' ...
          'Data_lh = squeeze(Data_lh.vol);' ...
          'Data_rh = MRIread(''' Image_rh_Path ''');' ...
          'Data_rh = squeeze(Data_rh.vol);' ...
          'Data_All = [Data_lh; Data_rh];' ...
          'for i = 1:1000, ' ...
          'i,' ...
          'sbj_AtlasLabel = HongmingSpin_Label(i, :);' ...
          'for j = 1:17, ' ...
          'System_Index{j} = find(sbj_AtlasLabel == j);' ...
          'Vertex_Quantity(j) = length(System_Index{j});' ...
          'TS_System = Data_All(System_Index{j}, :)'';' ...
          'Corr_WithinSystem = corr(TS_System);' ...
          'Corr_WithinSystem(find(eye(size(Corr_WithinSystem)))) = 0;' ...
          'Corr_WithinSystem_Avg(j) = sum(sum(Corr_WithinSystem)) / (Vertex_Quantity(j)*Vertex_Quantity(j)-Vertex_Quantity(j));' ...
          'end,' ...
          'TS_Homogeneity_Spin(i) = mean(Corr_WithinSystem_Avg);' ...
          'end,' ...
          'save(''' ResultantFile ''',''TS_Homogeneity_Spin'');' ...
          'exit(1)">"' ...
          LogFolder '/log_' num2str(i) '" 2>&1'];
    fid = fopen(ScriptPath, 'w');
    fprintf(fid, Cmd);
    system(['sh ' ScriptPath]);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 3: Calculating the significance 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication/';
AtlasSimilarityFolder = [ReplicationFolder '/Revision/Atlas_Homogeneity_Reliability'];
ARI_Hongming_Kong_Actual = load([AtlasSimilarityFolder '/ARI_Hongming_Kong.mat']);

ID_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'], 1, 0);
BBLID = ID_Info(:, 1);
PermuteARI_Folder = [AtlasSimilarityFolder '/PermuteData_SpinTest/ARI/'];
for i = 1:length(BBLID)
  i
  Homogeneity_Hongming_Mat = load([AtlasSimilarityFolder ...
             '/Homogeneity_Hongming/Homogeneity_Label_' num2str(BBLID(i)) '.mat']);
  TS_Homogeneity(i) = Homogeneity_Hongming_Mat.TS_Homogeneity;
  Homogeneity_Hongming_Spin_Mat = load([AtlasSimilarityFolder ...
             '/PermuteData_SpinTest/HomogeneitySig/Homogeneity_Spin_' num2str(BBLID(i)) '.mat']);
  TS_Homogeneity_Spin(i, :) = Homogeneity_Hongming_Spin_Mat.TS_Homogeneity_Spin;
  Homogeneity_PValue(i) = length(find(TS_Homogeneity_Spin(i, :) > TS_Homogeneity(i))) / 1000;
end
save([AtlasSimilarityFolder '/Homogeneity_Hongming_Sig.mat'], 'TS_Homogeneity', 'TS_Homogeneity_Spin', 'Homogeneity_PValue');

