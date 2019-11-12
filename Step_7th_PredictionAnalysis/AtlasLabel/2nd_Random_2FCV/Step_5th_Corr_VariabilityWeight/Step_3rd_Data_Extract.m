%
clear
SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
% for surface data
surfML = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/lh.Mask_SNR.label';
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/rh.Mask_SNR.label';
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision'];
EvoEtc_ResultsFolder = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLabel/Corr_Variability_AgePredictionWeights'];
% load variability (7 systems mean)
VariabilityLabel_Mat = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLabel.mat']);
VariabilityLabel_All_NoMedialWall = VariabilityLabel_Mat.VariabilityLabel_NoMedialWall;
% load variability permutation data (7 systems mean)
VariabilityLabel_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/VariabilityLabel_Perm.mat']);
VariabilityLabel_Perm_All_NoMedialWall = [VariabilityLabel_Perm.bigrotl(:, Index_l) VariabilityLabel_Perm.bigrotr(:, Index_r)];
% load age weights
AgeWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLabel/WeightVisualize_Age_RandomCV/w_Brain_Age.mat']);
AgeWeights_Label_All_NoMedialWall = AgeWeights.w_Brain_Age;
% load EF weights
EFWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLabel/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy.mat']);
EFWeights_Label_All_NoMedialWall = EFWeights.w_Brain_EFAccuracy;

save([EvoEtc_ResultsFolder '/AllData.mat'], ...
    'VariabilityLabel_All_NoMedialWall', ...
    'VariabilityLabel_Perm_All_NoMedialWall', ...
    'AgeWeights_Label_All_NoMedialWall', ...
    'EFWeights_Label_All_NoMedialWall');

