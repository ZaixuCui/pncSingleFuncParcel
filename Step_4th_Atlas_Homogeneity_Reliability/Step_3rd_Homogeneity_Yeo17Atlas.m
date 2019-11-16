
clear
ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

ResultantFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/Homogeneity_Yeo17Atlas'];
mkdir(ResultantFolder);
Combined_DataFolder = [ReplicationFolder '/data/CombinedData'];
Yeo17_Mat_Path = [ReplicationFolder '/data/YeoAtlas/label_17system.mat'];
for i = 1:length(BBLID)
  i
  Image_lh_Path = [Combined_DataFolder '/' num2str(BBLID(i)) '/lh.fs5.sm6.residualised.mgh'];
  Image_rh_Path = [Combined_DataFolder '/' num2str(BBLID(i)) '/rh.fs5.sm6.residualised.mgh'];
  ResultantFile = [ResultantFolder '/Homogeneity_Yeo17Label_' num2str(BBLID(i)) '.mat'];

  if ~exist(ResultantFile, 'file')
    ScriptFolder = [ResultantFolder '/Scripts'];
    mkdir(ScriptFolder);
    LogFolder = [ResultantFolder '/logs'];
    mkdir(LogFolder);
    ScriptPath = [ScriptFolder '/Homogeneity_Script_' num2str(i) '.sh'];
    Cmd = ['qsub-run --sge "-l h_vmem=10G" matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox''));' ...
          'Yeo17Label_Data = load(''' Yeo17_Mat_Path ''');' ...
          'sbj_AtlasLabel = [Yeo17Label_Data.sbj_Label_lh'' Yeo17Label_Data.sbj_Label_rh''];' ... 
          'UniqueLabel = setdiff(unique(sbj_AtlasLabel), 0);' ...
          'Data_lh = MRIread(''' Image_lh_Path ''');' ...
          'Data_lh = squeeze(Data_lh.vol);' ...
          'Data_rh = MRIread(''' Image_rh_Path ''');' ...
          'Data_rh = squeeze(Data_rh.vol);' ...
          'Data_All = [Data_lh; Data_rh];' ...
          'for j = 1:17, ' ...
          'System_Index{j} = find(sbj_AtlasLabel == UniqueLabel(j));' ...
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
