
clear
ProjectFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation';
mkdir(ProjectFolder);

SubjectsFolder = '/cbica/software/external/freesurfer/centos7/5.3.0/subjects/fsaverage5';
% for surface data
surfL = [SubjectsFolder '/surf/lh.pial'];
surfR = [SubjectsFolder '/surf/rh.pial'];
surfML = '/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/lh.Mask_SNR.label';
surfMR = '/cbica/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/rh.Mask_SNR.label';

[surfStru, surfMask] = getFsSurf(surfL, surfR, surfML, surfMR);

gNb = createPrepData('surface', surfStru, 1, surfMask);

% save gNb into file for later use
prepDataName = [ProjectFolder '/CreatePrepData.mat'];
save(prepDataName, 'gNb');
