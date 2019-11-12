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
EvoEtc_ResultsFolder = [ResultsFolder '/PredictionAnalysis/AtlasLabel_Kong/Corr_Variability_AgePredictionWeights'];
% load variability 
VariabilityLabel_Mat = load([ResultsFolder '/SingleParcellation_Kong/WorkingFolder/Variability_Visualize/Variability.mat']);
VariabilityLabel_lh = VariabilityLabel_Mat.Variability_lh;
VariabilityLabel_rh = VariabilityLabel_Mat.Variability_rh;
VariabilityLabel_All_NoMedialWall = [VariabilityLabel_Mat.Variability_lh(Index_l) ...
                      VariabilityLabel_Mat.Variability_rh(Index_r)];
% load variability permutation data 
VariabilityLabel_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/VariabilityLabel_Perm_Kong.mat']);
VariabilityLabel_Perm_All_NoMedialWall = [VariabilityLabel_Perm.bigrotl(:, Index_l) ...
                      VariabilityLabel_Perm.bigrotr(:, Index_r)];
% load age weights
AgeWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLabel_Kong/WeightVisualize_Age_RandomCV/w_Brain_Age.mat']);
AgeWeights_All_NoMedialWall = AgeWeights.w_Brain_Age;
% load age weights permutation data
AgeWeights_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/AgeWeights_Perm_Kong.mat']);
AgeWeights_Perm_All_NoMedialWall = [AgeWeights_Perm.bigrotl(:, Index_l) AgeWeights_Perm.bigrotr(:, Index_r)];

% load EF weights
EFWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLabel_Kong/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy.mat']);
EFWeights_All_NoMedialWall = EFWeights.w_Brain_EFAccuracy;
% load EF weights permutation data
EFWeights_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/EFWeights_Perm_Kong.mat']);
EFWeights_Perm_All_NoMedialWall = [EFWeights_Perm.bigrotl(:, Index_l) EFWeights_Perm.bigrotr(:, Index_r)];

% load age weights (NMF label)
AgeWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLabel/WeightVisualize_Age_RandomCV/w_Brain_Age.mat']);
AgeWeights_All_NoMedialWall_NMFLabel = AgeWeights.w_Brain_Age;
% load EF weights (NMF label)
EFWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLabel/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy.mat']);
EFWeights_All_NoMedialWall_NMFLabel = EFWeights.w_Brain_EFAccuracy;

save([EvoEtc_ResultsFolder '/AllData.mat'], ...
    'VariabilityLabel_All_NoMedialWall', ...
    'VariabilityLabel_Perm_All_NoMedialWall', ...
    'AgeWeights_All_NoMedialWall', ...
    'AgeWeights_Perm_All_NoMedialWall', ...
    'EFWeights_All_NoMedialWall', ...
    'EFWeights_Perm_All_NoMedialWall', ...
    'AgeWeights_All_NoMedialWall_NMFLabel', ...
    'EFWeights_All_NoMedialWall_NMFLabel');

