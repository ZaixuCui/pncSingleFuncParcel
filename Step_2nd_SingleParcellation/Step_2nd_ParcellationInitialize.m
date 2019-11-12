
%
% The first step of single brain parcellation, initialization of group atlas
% Each time resample 100 subjects, and repeat 50 times
% For the toolbox of single brain parcellation, see: 
%

clear

ReplicationFolder = '/cbica/projects/pncSingleFuncParcel/Replication';
ParcellationFolder = [ReplicationFolder '/Revision/SingleParcellation'];
InitializationFolder = [ParcellationFolder '/Initialization'];
mkdir(InitializationFolder);
mkdir([InitializationFolder '/Input']);
SubjectsQuantity = 100; % resampling 100 subjects

RawDataFolder = '/cbica/projects/pncSingleFuncParcel/Replication/data/CombinedData';
LeftCell = g_ls([RawDataFolder '/*/lh.fs5.sm6.residualised.mgh']);
RightCell = g_ls([RawDataFolder '/*/rh.fs5.sm6.residualised.mgh']);
prepDataFile = [ParcellationFolder '/CreatePrepData.mat'];

SubjectsFolder = '/cbica/software/external/freesurfer/centos7/5.3.0/subjects/fsaverage5';
% for surface data
surfL = [SubjectsFolder '/surf/lh.pial'];
surfR = [SubjectsFolder '/surf/rh.pial'];
surfML = '/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/lh.Mask_SNR.label';
surfMR = '/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/rh.Mask_SNR.label';

spaR = 1;
vxI = 1;
ard = 0;
iterNum = 2000;
tNum = 555; % number of time points
alpha = 1;
beta = 10;
resId = 'Initialization';
K = 17; % numer of networks

% Repeat 50 times
for i = 1:50
  i
  ResultantFile_Path = [InitializationFolder '/InitializationRes_' num2str(i) '/Initialization_num100_comp17_S1_3265_L_2721_spaR_1_vxInfo_1_ard_0/init.mat'];
  if ~exist(ResultantFile_Path, 'file')
    SubjectsIDs = randperm(length(LeftCell), SubjectsQuantity);
    sbjListFile = [InitializationFolder '/Input/sbjListFile_' num2str(i) '.txt'];
    %system(['rm ' sbjListFile]);
    %for j = 1:length(SubjectsIDs)
    %  cmd = ['echo ' LeftCell{SubjectsIDs(j)} ' >> ' sbjListFile];
    %  system(cmd);
    %  cmd = ['echo ' RightCell{SubjectsIDs(j)} ' >> ' sbjListFile];
    %  system(cmd);
    %end

    outDir = [InitializationFolder '/InitializationRes_' num2str(i)];
    save([InitializationFolder '/Configuration_' num2str(i) '.mat'], 'sbjListFile', 'surfL', 'surfR', 'surfML', 'surfMR', 'prepDataFile', 'outDir', ...
          'spaR', 'vxI', 'ard', 'iterNum', 'K', 'tNum', 'alpha', 'beta', 'resId');
    cmd = ['qsub-run --sge "-l h_vmem=30G" matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox/Code_mvNMF_l21_ard_v3_release'')),load(''' ...
          InitializationFolder '/Configuration_' num2str(i) '.mat''),deployFuncInit_surf_fs(sbjListFile, surfL, surfR, ' ...
          'surfML, surfMR, prepDataFile, outDir, spaR, vxI, ard, iterNum, K, tNum, alpha, beta, resId),exit(1)">"' ...
          InitializationFolder '/ParcelInit' num2str(i) '.log" 2>&1'];
    fid = fopen([InitializationFolder '/tmp' num2str(i) '.sh'], 'w');
    fprintf(fid, cmd);
    system(['sh ' InitializationFolder '/tmp' num2str(i) '.sh']);
  end
end

