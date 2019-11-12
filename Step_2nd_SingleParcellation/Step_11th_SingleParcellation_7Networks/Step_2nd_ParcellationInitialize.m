
%
% The first step of single brain parcellation, initialization of group atlas
% Each time resample 100 subjects, and repeat 50 times
% For the toolbox of single brain parcellation, see: 
%

clear

ReplicationFolder = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication';
ParcellationFolder = [ReplicationFolder '/Revision/SingleParcellation_7Networks'];
InitializationFolder = [ParcellationFolder '/Initialization'];
mkdir(InitializationFolder);
mkdir([InitializationFolder '/Input']);
SubjectsQuantity = 100; % resampling 100 subjects

RawDataFolder = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/data/CombinedData';
LeftCell = g_ls([RawDataFolder '/*/lh.fs5.sm6.residualised.mgh']);
RightCell = g_ls([RawDataFolder '/*/rh.fs5.sm6.residualised.mgh']);
prepDataFile = [ParcellationFolder '/CreatePrepData.mat'];

SubjectsFolder = '/gpfs/fs001/cbica/software/external/freesurfer/centos7/5.3.0/subjects/fsaverage5';
% for surface data
surfL = [SubjectsFolder '/surf/lh.pial'];
surfR = [SubjectsFolder '/surf/rh.pial'];
surfML = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/fsaverage5/lh.Mask_SNR.label';
surfMR = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/fsaverage5/rh.Mask_SNR.label';

spaR = 1;
vxI = 1;
ard = 0;
iterNum = 2000;
tNum = 555; % number of time points
alpha = 1;
beta = 10;
resId = 'Initialization';
K = 7; % numer of networks

% Repeat 50 times
for i = 1:50
  i
  ResultantFile_Path = [InitializationFolder '/InitializationRes_' num2str(i) '/Initialization_num100_comp7_S1_7929_L_6607_spaR_1_vxInfo_1_ard_0/init.mat'];
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
    cmd = ['/cbica/software/external/matlab/R2018A/bin/matlab -nosplash -nodesktop -r ' ...
          '"addpath(genpath(''' ReplicationFolder '/Toolbox/Code_mvNMF_l21_ard_v3_release'')),load(''' ...
          InitializationFolder '/Configuration_' num2str(i) '.mat''),deployFuncInit_surf_fs(sbjListFile, surfL, surfR, ' ...
          'surfML, surfMR, prepDataFile, outDir, spaR, vxI, ard, iterNum, K, tNum, alpha, beta, resId),exit(1)">"' ...
          InitializationFolder '/ParcelInit' num2str(i) '.log" 2>&1'];
    fid = fopen([InitializationFolder '/tmp' num2str(i) '.sh'], 'w');
    fprintf(fid, cmd);
    system(['qsub -l h_vmem=30G ' InitializationFolder '/tmp' num2str(i) '.sh']);
  end
end

