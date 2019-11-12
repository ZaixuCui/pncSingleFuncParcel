
clear
ProjectFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_7Networks';
mkdir(ProjectFolder);

SubjectsFolder = '/cbica/software/external/freesurfer/centos7/5.3.0/subjects/fsaverage5';
% for surface data
surfL = [SubjectsFolder '/surf/lh.pial'];
surfR = [SubjectsFolder '/surf/rh.pial'];
surfML = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/fsaverage5/lh.Mask_SNR.label';
surfMR = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/fsaverage5/rh.Mask_SNR.label';

[surfStru, surfMask] = getFsSurf(surfL, surfR, surfML, surfMR);

gNb = createPrepData('surface', surfStru, 1, surfMask);

% save gNb into file for later use
prepDataName = [ProjectFolder '/CreatePrepData.mat'];
save(prepDataName, 'gNb');
