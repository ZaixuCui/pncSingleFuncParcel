
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 1: ARI between hongming atlas and kong atlas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision'];
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
  NonZeroIndex = find(Hongming_Label ~= 0); % Removing medial wall and low signal regions which we did not use
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
NonZeroIndex = find(Hongming_Group_Label ~= 0); % Removing medial wall and low signal regions which we did not use
ARI_Hongming_Kong_Group = rand_index(Hongming_Group_Label(NonZeroIndex), Kong_Group_Label(NonZeroIndex), 'adjusted');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 2: ARI between randomized hongming atlas and Kong atlas 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision_Zaixu'];
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
    Cmd = ['/cbica/software/external/matlab/R2018A/bin/matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox''));' ...
          'Kong_Data = load(''' Kong_Mat_Path ''');' ...
          'HongmingSpin_Data = load(''' HongmingSpin_Mat_Path ''');' ...
          'Kong_Label = [Kong_Data.lh_labels; Kong_Data.rh_labels];' ...
          'NonZeroIndex = find(Kong_Label ~= 0);' ...
          'HongmingSpin_Label = [HongmingSpin_Data.bigrotl HongmingSpin_Data.bigrotr];' ... 
          'for j = 1:1000,' ...
          'j,' ...
          'NonZeroIndex_Both = intersect(NonZeroIndex, find(HongmingSpin_Label(j, :) ~= 0));' ...
          'ARI_HongmingSpin_Kong(j) = rand_index(HongmingSpin_Label(j, NonZeroIndex_Both), Kong_Label(NonZeroIndex_Both), ''adjusted'');' ...
          'end,' ...
          'save(''' ResultantFile ''', ''ARI_HongmingSpin_Kong'');' ...
          'exit(1)">"' ...
          LogFolder '/log_' num2str(i) '" 2>&1'];
    fid = fopen(ScriptPath, 'w');
    fprintf(fid, Cmd);
    system(['qsub -l h_vmem=5G ' ScriptPath]);
    pause(1);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 3: Calculating the significance 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/';
AtlasSimilarityFolder = [ReplicationFolder '/Revision/Atlas_Homogeneity_Reliability/AtlasSimilarity'];
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Step 4: Testing if a particular subject's NMF and MS-HBM network
%%%% patterns are more similar to each other than to that of other subject
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For a particular subject:
% Calculating ARI between NMF and MS-HBM networks
% Calculating ARI between NMF network and all oather subjects' MS-HBM networks
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/';
% Extract the label file for both two methods, totally the same subject order for two cells
AtlasLabel_Hongming_Cell = g_ls([ReplicationFolder '/Revision/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLabel/*.mat']);
AtlasLabel_Kong_Cell = g_ls([ReplicationFolder '/Revision/SingleParcellation_Kong/WorkingFolder/ind_parcellation_200_30/*.mat']);

ResultsFolder = [ReplicationFolder '/Revision'];
ResultantFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/AtlasSimilarity'];
for i = 1:693
  Job_Name = ['ARIMatrix_' num2str(i)];
  pipeline.(Job_Name).command = 'ARIMatrix_TwoAtlas(opt.para1, opt.para2, opt.para3, opt.para4)';
  pipeline.(Job_Name).opt.para1 = AtlasLabel_Hongming_Cell{i};
  pipeline.(Job_Name).opt.para2 = AtlasLabel_Kong_Cell;
  pipeline.(Job_Name).opt.para3 = i;
  pipeline.(Job_Name).opt.para4 = [ResultantFolder '/ARIMatrix_Hongming_Kong'];
end

psom_gb_vars
Pipeline_opt.mode = 'qsub';
Pipeline_opt.qsub_options = '-q all.q,basic.q';
Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.max_queued = 1000;
Pipeline_opt.flag_verbose = 1;
Pipeline_opt.flag_pause = 0;
Pipeline_opt.path_logs = [ResultantFolder '/ARIMatrix_Hongming_Kong/logs'];

psom_run_pipeline(pipeline, Pipeline_opt);

for i = 1:693
  ARIMatrix_Row = load([ResultantFolder '/ARIMatrix_Hongming_Kong/ARIMatrix_Row_' num2str(i) '.mat']); 
  ARIMatrix_Hongming_Kong(i, :) = ARIMatrix_Row.ARI;
end
ARIMatrix_Hongming_Kong_Diagonal = diag(ARIMatrix_Hongming_Kong);
ARIMatrix_Hongming_Kong_OffDiagonal = ARIMatrix_Hongming_Kong - ...
                      ARIMatrix_Hongming_Kong .* eye(size(ARIMatrix_Hongming_Kong));
ARIMatrix_Hongming_Kong_OffDiagonal = ARIMatrix_Hongming_Kong_OffDiagonal(find(ARIMatrix_Hongming_Kong_OffDiagonal));
save([ResultantFolder '/ARIMatrix_Hongming_Kong.mat'], 'ARIMatrix_Hongming_Kong', ...
                      'ARIMatrix_Hongming_Kong_Diagonal', 'ARIMatrix_Hongming_Kong_OffDiagonal');

% Finally, the diagonal elements are similarity between NMF and MS-HBM of one subject
%          off-diagnal elements of each row are similarity between NMF and all other subjects' MS-HBM 

