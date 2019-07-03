
clear
SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
% for surface data
surfML = [SubjectsFolder '/label/lh.Medial_wall.label'];
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = [SubjectsFolder '/label/rh.Medial_wall.label'];
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/results'];
EvoGradientEtc_ResultsFolder = [ReplicationFolder '/results/Corr_EvoGradientMyelinScalingCBF'];
% load variability (17 systems mean)
VariabilityLoading_Mat = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLoading_Median_17SystemMean.mat']);
VariabilityLoading_17SystemMean_All_NoMedialWall = VariabilityLoading_Mat.VariabilityLoading_Median_17SystemMean_NoMedialWall;
VariabilityLoading_17SystemMean_rh_NoMedialWall = VariabilityLoading_Mat.VariabilityLoading_Median_17SystemMean_rh(Index_r);
% load variability permutation data (17 systems mean)
VariabilityLoading_Perm = load([EvoGradientEtc_ResultsFolder '/PermuteData_SpinTest/VariabilityLoading_17SystemMean_Perm.mat']);
VariabilityLoading_17SystemMean_Perm_All_NoMedialWall = [VariabilityLoading_Perm.bigrotl(:, Index_l) VariabilityLoading_Perm.bigrotr(:, Index_r)];
VariabilityLoading_17SystemMean_Perm_rh_NoMedialWall = VariabilityLoading_Perm.bigrotr(:, Index_r);
% load age weights
AgeWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLoading/Weight_Age/w_Brain_Age_abs_sum.mat']);
AgeWeights_All_NoMedialWall = AgeWeights.w_Brain_Age_abs_sum;
AgeWeights_rh_NoMedialWall = AgeWeights.w_Brain_Age_abs_sum_rh(Index_r);
% load cognition weights
CognitionWeights = load([ResultsFolder '/PredictionAnalysis/AtlasLoading/Weight_EFAccuracy/w_Brain_EFAccuracy_abs_sum.mat']);
CognitionWeights_All_NoMedialWall = CognitionWeights.w_Brain_EFAccuracy_abs_sum;
CognitionWeights_rh_NoMedialWall = CognitionWeights.w_Brain_EFAccuracy_abs_sum_rh(Index_r);

% load data of cortical organization
EvoGradientEtc_DataFolder = [ReplicationFolder '/data/EvoGradientMyelinScalingCBF'];
% load evolutionary expansion
Evo_rh_gifti = gifti([EvoGradientEtc_DataFolder '/EvolutionaryExpansion/rh.Hill2010_evo_fsaverage5.func.gii']);
Evo_rh = Evo_rh_gifti.cdata;
Evo_rh_NoMedialWall = Evo_rh(Index_r);
% loading myelin
Myelin_lh_gifti = gifti([EvoGradientEtc_DataFolder '/Myelin/MyelinMap.lh.fsaverage5.func.gii']);
Myelin_lh = Myelin_lh_gifti.cdata;
Myelin_rh_gifti = gifti([EvoGradientEtc_DataFolder '/Myelin/MyelinMap.rh.fsaverage5.func.gii']);
Myelin_rh = Myelin_rh_gifti.cdata;
Myelin_All_NoMedialWall = [Myelin_lh(Index_l)' Myelin_rh(Index_r)'];
% loading mean CBF
MeanCBF_lh_gifti = gifti([EvoGradientEtc_DataFolder '/MeanCBF/lh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_lh = MeanCBF_lh_gifti.cdata;
MeanCBF_rh_gifti = gifti([EvoGradientEtc_DataFolder '/MeanCBF/rh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_rh = MeanCBF_rh_gifti.cdata;
MeanCBF_All_NoMedialWall = [MeanCBF_lh(Index_l)' MeanCBF_rh(Index_r)'];

save([EvoGradientEtc_ResultsFolder '/AllData.mat'], ...
    'VariabilityLoading_17SystemMean_All_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_rh_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_Perm_All_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_Perm_rh_NoMedialWall', ...
    'AgeWeights_All_NoMedialWall', 'CognitionWeights_All_NoMedialWall', ...
    'Evo_rh_NoMedialWall', 'Myelin_All_NoMedialWall', ...
    'MeanCBF_All_NoMedialWall');

