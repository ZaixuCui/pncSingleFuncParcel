
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Homogeneity of hongming's single atlas
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
%%%%   Step 2: Extract all subjects' homogeneity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/';
AtlasHomoSimilarityFolder = [ReplicationFolder '/Revision/Atlas_Homogeneity_Reliability'];

ID_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'], 1, 0);
BBLID = ID_Info(:, 1);
for i = 1:length(BBLID)
  i
  Homogeneity_Hongming_Mat = load([AtlasHomoSimilarityFolder ...
             '/Homogeneity_Hongming/Homogeneity_Label_' num2str(BBLID(i)) '.mat']);
  TS_Homogeneity(i) = Homogeneity_Hongming_Mat.TS_Homogeneity;
end
save([AtlasHomoSimilarityFolder '/Homogeneity_Hongming_AllSubjects.mat'], 'TS_Homogeneity');

