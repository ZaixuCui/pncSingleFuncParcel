
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
EvoEtc_ResultsFolder = [ReplicationFolder '/Revision/Corr_EvoMyelinCBF/BetweenCorr_MyelinCBF'];

% load data of cortical organization
EvoEtc_DataFolder = [ReplicationFolder '/data/EvoMyelinCBF'];
% loading evo
Evo_rh_gifti = gifti([EvoEtc_DataFolder '/EvolutionaryExpansion/rh.Hill2010_evo_fsaverage5.func.gii']);
Evo_rh = Evo_rh_gifti.cdata;
Evo_rh_NoMedialWall = Evo_rh(Index_r)';
% loading myelin
Myelin_lh_gifti = gifti([EvoEtc_DataFolder '/Myelin/MyelinMap.lh.fsaverage5.func.gii']);
Myelin_lh = Myelin_lh_gifti.cdata;
Myelin_rh_gifti = gifti([EvoEtc_DataFolder '/Myelin/MyelinMap.rh.fsaverage5.func.gii']);
Myelin_rh = Myelin_rh_gifti.cdata;
Myelin_All_NoMedialWall = [Myelin_lh(Index_l)' Myelin_rh(Index_r)'];
Myelin_rh_NoMedialWall = Myelin_rh(Index_r)';
% loading mean CBF
MeanCBF_lh_gifti = gifti([EvoEtc_DataFolder '/MeanCBF/lh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_lh = MeanCBF_lh_gifti.cdata;
MeanCBF_rh_gifti = gifti([EvoEtc_DataFolder '/MeanCBF/rh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_rh = MeanCBF_rh_gifti.cdata;
MeanCBF_All_NoMedialWall = [MeanCBF_lh(Index_l)' MeanCBF_rh(Index_r)'];
MeanCBF_rh_NoMedialWall = MeanCBF_rh(Index_r)';
% load myelin permutation data
Myelin_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/Myelin_Perm.mat']);
Myelin_Perm_All_NoMedialWall = [Myelin_Perm.bigrotl(:, Index_l) Myelin_Perm.bigrotr(:, Index_r)];
Myelin_Perm_rh_NoMedialWall = Myelin_Perm.bigrotr(:, Index_r);
% load mean CBF permutation data
MeanCBF_Perm = load([EvoEtc_ResultsFolder '/PermuteData_SpinTest/MeanCBF_Perm.mat']);
MeanCBF_Perm_All_NoMedialWall = [MeanCBF_Perm.bigrotl(:, Index_l) MeanCBF_Perm.bigrotr(:, Index_r)];
MeanCBF_Perm_rh_NoMedialWall = MeanCBF_Perm.bigrotr(:, Index_r);

save([EvoEtc_ResultsFolder '/AllData.mat'], ...
    'Evo_rh_NoMedialWall', ...
    'Myelin_All_NoMedialWall', 'Myelin_rh_NoMedialWall', ...
    'MeanCBF_All_NoMedialWall', 'MeanCBF_rh_NoMedialWall', ...
    'Myelin_Perm_All_NoMedialWall', 'Myelin_Perm_rh_NoMedialWall', ...
    'MeanCBF_Perm_All_NoMedialWall', 'MeanCBF_Perm_rh_NoMedialWall');

