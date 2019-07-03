
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 1: ARI between hongming atlas and kong atlas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/results'];
Hongming_Folder = [ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLabel'];
Kong_Folder = [ResultsFolder '/SingleParcellation_Kong/WorkingFolder/ind_parcellation_200_30'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

ResultantFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/AtlasSimilarity'];
mkdir(ResultantFolder);
for i = 1:length(BBLID)
  i
  Hongming_Data_Mat = load([Hongming_Folder '/' num2str(BBLID(i))]);
  Kong_Data_Mat = load([Kong_Folder '/' num2str(BBLID(i))]);
  Hongming_Label = [Hongming_Data_Mat.sbj_AtlasLabel_lh'; Hongming_Data_Mat.sbj_AtlasLabel_rh'];
  Kong_Label = [Kong_Data_Mat.lh_labels; Kong_Data_Mat.rh_labels];
  NonZeroIndex = find(Kong_Label ~= 0); % Removing medial wall
  ARI_Hongming_Kong(i) = rand_index(Hongming_Label(NonZeroIndex), Kong_Label(NonZeroIndex), 'adjusted');
end
ARI_Hongming_Kong_Mean = mean(ARI_Hongming_Kong);
ARI_Hongming_Kong_Std = std(ARI_Hongming_Kong);
save([ResultantFolder '/ARI_Hongming_Kong.mat'], 'ARI_Hongming_Kong', 'ARI_Hongming_Kong_Mean', 'ARI_Hongming_Kong_Std', 'BBLID');

% ARI between group atlas from two methods
Hongming_Group_Data_Mat = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat']);
Hongming_Group_Label = [Hongming_Group_Data_Mat.sbj_AtlasLabel_lh'; Hongming_Group_Data_Mat.sbj_AtlasLabel_rh'];
Kong_Group_Data_Mat = load([ResultsFolder '/SingleParcellation_Kong/WorkingFolder/group/group.mat']);
Kong_Group_Label = [Kong_Group_Data_Mat.lh_labels; Kong_Group_Data_Mat.rh_labels];
NonZeroIndex = find(Kong_Group_Label ~= 0); % Removing medial wall
ARI_Hongming_Kong_Group = rand_index(Hongming_Group_Label, Kong_Group_Label, 'adjusted');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 2: ARI between randomized hongming atlas and Kong atlas 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/results'];
HongmingSpin_Folder = [ResultsFolder '/Atlas_Homogeneity_Reliability/PermuteData_SpinTest/PermuteData'];
Kong_Folder = [ResultsFolder '/SingleParcellation_Kong/WorkingFolder/ind_parcellation_200_30'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

ResultantFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/AtlasSimilarity/ARI_PermuteData_SpinTest'];
mkdir(ResultantFolder);
for i = 1:length(BBLID)
  i
  ResultantFile = [ResultantFolder '/ARI_Spin_' num2str(BBLID(i)) '.mat'];
  if ~exist(ResultantFile, 'file')
    Kong_Mat_Path = [Kong_Folder '/' num2str(BBLID(i)) '.mat'];
    HongmingSpin_Mat_Path = [HongmingSpin_Folder '/AtlasLabel_Perm_' num2str(BBLID(i)) '.mat'];

    ScriptFolder = [ResultantFolder '/Scripts'];
    mkdir(ScriptFolder);
    LogFolder = [ResultantFolder '/logs'];
    mkdir(LogFolder);
    ScriptPath = [ScriptFolder '/ARI_Script_' num2str(i) '.sh'];
    Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox''));' ...
          'Kong_Data = load(''' Kong_Mat_Path ''');' ...
          'HongmingSpin_Data = load(''' HongmingSpin_Mat_Path ''');' ...
          'Kong_Label = [Kong_Data.lh_labels; Kong_Data.rh_labels];' ...
          'NonZeroIndex = find(Kong_Label ~= 0);' ...
          'HongmingSpin_Label = [HongmingSpin_Data.bigrotl HongmingSpin_Data.bigrotr];' ... 
          'for j = 1:1000,' ...
          'j,' ...
          'ARI_HongmingSpin_Kong(j) = rand_index(HongmingSpin_Label(j, NonZeroIndex), Kong_Label(NonZeroIndex), ''adjusted'');' ...
          'end,' ...
          'save(''' ResultantFile ''', ''ARI_HongmingSpin_Kong'');' ...
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
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/';
AtlasSimilarityFolder = [ReplicationFolder '/results/Atlas_Homogeneity_Reliability/AtlasSimilarity'];
ARI_Hongming_Kong_Actual = load([AtlasSimilarityFolder '/ARI_Hongming_Kong.mat']);

ID_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'], 1, 0);
BBLID = ID_Info(:, 1);
PermuteARI_Folder = [AtlasSimilarityFolder '/ARI_PermuteData_SpinTest'];
for i = 1:length(BBLID)
  i
  index = find(ARI_Hongming_Kong_Actual.BBLID == BBLID(i));
  ARI_Actual = ARI_Hongming_Kong_Actual.ARI_Hongming_Kong(index);
  ARI_Permutation_Data = load([PermuteARI_Folder '/ARI_Spin_' num2str(BBLID(i)) '.mat']);
  ARI_Permutation = ARI_Permutation_Data.ARI_HongmingSpin_Kong;
  ARI_P(i) = length(find(ARI_Permutation > ARI_Actual)) / 1000;
end
