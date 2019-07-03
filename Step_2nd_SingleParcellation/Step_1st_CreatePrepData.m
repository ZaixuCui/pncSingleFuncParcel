
clear
ProjectFolder = '/cbica/projects/pncSingleFuncParcel/Replication/results/SingleParcellation';
mkdir(ProjectFolder);

SubjectsFolder = '/cbica/software/external/freesurfer/centos7/5.3.0/subjects/fsaverage5';
% for surface data
surfL = [SubjectsFolder '/surf/lh.pial'];
surfR = [SubjectsFolder '/surf/rh.pial'];
surfML = [SubjectsFolder '/label/lh.Medial_wall.label'];
surfMR = [SubjectsFolder '/label/rh.Medial_wall.label'];

[surfStru, surfMask] = getFsSurf(surfL, surfR, surfML, surfMR);

gNb = createPrepData('surface', surfStru, 1, surfMask);

% save gNb into file for later use
prepDataName = [ProjectFolder '/CreatePrepData.mat'];
save(prepDataName, 'gNb');
