
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
PredictionFolder = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLabel_Kong/'];
Results_Cell = g_ls([PredictionFolder '/2Fold_RandomCV_EFAccuracy/Time_*/Fold_*_Score.mat']);
for i = 1:length(Results_Cell)
  tmp = load(Results_Cell{i});
  w_Brain_EFAccuracy_AllModels(i, :) = tmp.w_Brain;
end
w_Brain_EFAccuracy = mean(w_Brain_EFAccuracy_AllModels);
VisualizeFolder = [PredictionFolder '/WeightVisualize_EFAccuracy_RandomCV'];
mkdir(VisualizeFolder);

SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
% for surface data
surfML = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/lh.Mask_SNR.label';
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/rh.Mask_SNR.label';
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

%%%%%%%%%%%%%%%%%%
% EFAccuracy Prediction %
%%%%%%%%%%%%%%%%%%
w_Brain_EFAccuracy_lh = zeros(1, 10242);
w_Brain_EFAccuracy_lh(Index_l) = w_Brain_EFAccuracy(1:length(Index_l));
w_Brain_EFAccuracy_rh = zeros(1, 10242);
w_Brain_EFAccuracy_rh(Index_r) = w_Brain_EFAccuracy(length(Index_l) + 1:end);
save([VisualizeFolder '/w_Brain_EFAccuracy.mat'], 'w_Brain_EFAccuracy', 'w_Brain_EFAccuracy_lh', 'w_Brain_EFAccuracy_rh');

V_lh = gifti;
V_lh.cdata = w_Brain_EFAccuracy_lh';
V_lh_File = [VisualizeFolder '/w_Brain_EF_RandomCV_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_rh = gifti;
V_rh.cdata = w_Brain_EFAccuracy_rh';
V_rh_File = [VisualizeFolder '/w_Brain_EF_RandomCV_rh.func.gii'];
save(V_rh, V_rh_File);
% combine 
cmd = ['wb_command -cifti-create-dense-scalar ' VisualizeFolder '/w_Brain_EF_RandomCV' ...
         '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File]);

