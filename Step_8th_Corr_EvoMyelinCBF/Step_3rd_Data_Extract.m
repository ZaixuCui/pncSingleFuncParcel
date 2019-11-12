
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
EvoEtc_ResultsFolder = [ReplicationFolder '/Revision/Corr_EvoMyelinCBF'];
% load variability (17 systems mean)
VariabilityLoading_Mat = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Variability_Visualize/VariabilityLoading_Median_17SystemMean.mat']);
VariabilityLoading_17SystemMean_All_NoMedialWall = VariabilityLoading_Mat.VariabilityLoading_Median_17SystemMean_NoMedialWall;
VariabilityLoading_17SystemMean_rh_NoMedialWall = VariabilityLoading_Mat.VariabilityLoading_Median_17SystemMean_rh(Index_r);
% load variability permutation data (17 systems mean)
VariabilityLoading_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/VariabilityLoading_17SystemMean_Perm.mat']);
VariabilityLoading_17SystemMean_Perm_All_NoMedialWall = [VariabilityLoading_Perm.bigrotl(:, Index_l) VariabilityLoading_Perm.bigrotr(:, Index_r)];
VariabilityLoading_17SystemMean_Perm_rh_NoMedialWall = VariabilityLoading_Perm.bigrotr(:, Index_r);
% load age weights from random 2F-CV
AgeWeights_RandomCV = load([ResultsFolder '/PredictionAnalysis/AtlasLoading/WeightVisualize_Age_RandomCV/w_Brain_Age_Abs_sum.mat']);
AgeWeights_All_NoMedialWall_RandomCV = AgeWeights_RandomCV.w_Brain_Age_Abs_sum;
% load cognition weights from random 2F-CV
CognitionWeights_RandomCV = load([ResultsFolder '/PredictionAnalysis/AtlasLoading/WeightVisualize_EFAccuracy_RandomCV/w_Brain_EFAccuracy_Abs_sum.mat']);
CognitionWeights_All_NoMedialWall_RandomCV = CognitionWeights_RandomCV.w_Brain_EFAccuracy_Abs_sum;

% load data of cortical organization
EvoEtc_DataFolder = [ReplicationFolder '/data/EvoMyelinCBF'];
% load evolutionary expansion
Evo_rh_gifti = gifti([EvoEtc_DataFolder '/EvolutionaryExpansion/rh.Hill2010_evo_fsaverage5.func.gii']);
Evo_rh = Evo_rh_gifti.cdata;
Evo_rh_NoMedialWall = Evo_rh(Index_r);
% loading myelin
Myelin_lh_gifti = gifti([EvoEtc_DataFolder '/Myelin/MyelinMap.lh.fsaverage5.func.gii']);
Myelin_lh = Myelin_lh_gifti.cdata;
Myelin_rh_gifti = gifti([EvoEtc_DataFolder '/Myelin/MyelinMap.rh.fsaverage5.func.gii']);
Myelin_rh = Myelin_rh_gifti.cdata;
Myelin_All_NoMedialWall = [Myelin_lh(Index_l)' Myelin_rh(Index_r)'];
% loading mean CBF
MeanCBF_lh_gifti = gifti([EvoEtc_DataFolder '/MeanCBF/lh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_lh = MeanCBF_lh_gifti.cdata;
MeanCBF_rh_gifti = gifti([EvoEtc_DataFolder '/MeanCBF/rh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_rh = MeanCBF_rh_gifti.cdata;
MeanCBF_All_NoMedialWall = [MeanCBF_lh(Index_l)' MeanCBF_rh(Index_r)'];

save([EvoEtc_ResultsFolder '/AllData.mat'], ...
    'VariabilityLoading_17SystemMean_All_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_rh_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_Perm_All_NoMedialWall', ...
    'VariabilityLoading_17SystemMean_Perm_rh_NoMedialWall', ...
    'AgeWeights_All_NoMedialWall_RandomCV', ...
    'CognitionWeights_All_NoMedialWall_RandomCV', ...
    'Evo_rh_NoMedialWall', 'Myelin_All_NoMedialWall', ...
    'MeanCBF_All_NoMedialWall');

