
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
EvoEtc_ResultsFolder = [ResultsFolder '/PredictionAnalysis/AtlasLoading_7Networks/Corr_Variability_AgePredictionWeights'];
% load variability (7 systems mean)
VariabilityLoading_Mat = load([ResultsFolder '/SingleParcellation_7Networks/SingleAtlas_Analysis/Variability_Visualize/VariabilityLoading_Median_7SystemMean.mat']);
VariabilityLoading_7SystemMean_All_NoMedialWall = VariabilityLoading_Mat.VariabilityLoading_Median_7SystemMean_NoMedialWall;
% load variability permutation data (7 systems mean)
VariabilityLoading_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/VariabilityLoading_7SystemMean_Perm.mat']);
VariabilityLoading_7SystemMean_Perm_All_NoMedialWall = [VariabilityLoading_Perm.bigrotl(:, Index_l) VariabilityLoading_Perm.bigrotr(:, Index_r)];
% load age weights
AgeWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLoading_7Networks/WeightVisualize_Age_RandomCV/w_Brain_Age_Abs_sum.mat']);
AgeWeights_All_NoMedialWall = AgeWeights.w_Brain_Age_Abs_sum;
% load age weights permutation data (7 systems)
AgeWeights_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/w_Brain_Age_Abs_Sum_Perm.mat']);
AgeWeights_Perm_All_NoMedialWall = [AgeWeights_Perm.bigrotl(:, Index_l) AgeWeights_Perm.bigrotr(:, Index_r)];
% load EF weights
EFWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLoading_7Networks/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy_Abs_sum.mat']);
EFWeights_All_NoMedialWall = EFWeights.w_Brain_EFAccuracy_Abs_sum;
% load EF weights permutation data (7 systems)
EFWeights_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/w_Brain_EFAccuracy_Abs_Sum_Perm.mat']);
EFWeights_Perm_All_NoMedialWall = [EFWeights_Perm.bigrotl(:, Index_l) EFWeights_Perm.bigrotr(:, Index_r)];
% load variability (17 systems mean)
VariabilityLoading_Mat = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLoading_Median_17SystemMean.mat']);
VariabilityLoading_17SystemMean_All_NoMedialWall = VariabilityLoading_Mat.VariabilityLoading_Median_17SystemMean_NoMedialWall;
% load age weight (17 systems mean);
AgeWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLoading/WeightVisualize_Age_RandomCV/w_Brain_Age_Abs_sum.mat']);
AgeWeights_17SystemMean_All_NoMedialWall = AgeWeights.w_Brain_Age_Abs_sum;
% load EF weight (17 systems mean)
EFWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLoading/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy_Abs_sum.mat']);
EFWeights_17SystemMean_All_NoMedialWall = EFWeights.w_Brain_EFAccuracy_Abs_sum;

save([EvoEtc_ResultsFolder '/AllData.mat'], ...
    'VariabilityLoading_7SystemMean_All_NoMedialWall', ...
    'VariabilityLoading_7SystemMean_Perm_All_NoMedialWall', ...
    'AgeWeights_All_NoMedialWall', ...
    'AgeWeights_Perm_All_NoMedialWall', ...
    'EFWeights_All_NoMedialWall', ...
    'EFWeights_Perm_All_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_All_NoMedialWall', ...
    'AgeWeights_17SystemMean_All_NoMedialWall', ...
    'EFWeights_17SystemMean_All_NoMedialWall');

