
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
PredictionFolder = [ReplicationFolder '/Revision/PredictionAnalysis/AtlasLoading_7Networks/'];
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

load([PredictionFolder '/AtlasLoading_All_RemoveZero.mat']); % NonZeroIndex was here
%%%%%%%%%%%%%%%%%%
% EFAccuracy Prediction %
%%%%%%%%%%%%%%%%%%
VertexQuantity = 17734;
% Absolute sum weights
w_Brain_EFAccuracy_All = zeros(1, 17734*7);
w_Brain_EFAccuracy_All(NonZeroIndex) = w_Brain_EFAccuracy;
%% Display weight of all regions
for i = 1:7
    w_Brain_EFAccuracy_Matrix(i, :) = w_Brain_EFAccuracy_All([(i - 1) * VertexQuantity + 1 : i * VertexQuantity]);
end
save([VisualizeFolder '/w_Brain_EFAccuracy_Matrix.mat'], 'w_Brain_EFAccuracy_Matrix');

%% Display sum absolute weight of the 7 maps
w_Brain_EFAccuracy_Abs_sum = sum(abs(w_Brain_EFAccuracy_Matrix));
w_Brain_EFAccuracy_Abs_sum_lh = zeros(10242, 1);
w_Brain_EFAccuracy_Abs_sum_lh(Index_l) = w_Brain_EFAccuracy_Abs_sum(1:length(Index_l));
w_Brain_EFAccuracy_Abs_sum_rh = zeros(10242, 1);
w_Brain_EFAccuracy_Abs_sum_rh(Index_r) = w_Brain_EFAccuracy_Abs_sum(length(Index_l) + 1:end);
save([VisualizeFolder '/w_Brain_EFAccuracy_Abs_sum.mat'], 'w_Brain_EFAccuracy_Abs_sum', ...
                         'w_Brain_EFAccuracy_Abs_sum_lh', 'w_Brain_EFAccuracy_Abs_sum_rh');

V_lh = gifti;
V_lh.cdata = w_Brain_EFAccuracy_Abs_sum_lh;
V_lh_File = [VisualizeFolder '/w_Brain_EF_Abs_sum_RandomCV_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_rh = gifti;
V_rh.cdata = w_Brain_EFAccuracy_Abs_sum_rh;
V_rh_File = [VisualizeFolder '/w_Brain_EF_Abs_sum_RandomCV_rh.func.gii'];
save(V_rh, V_rh_File);
% combine 
cmd = ['wb_command -cifti-create-dense-scalar ' VisualizeFolder '/w_Brain_EF_Abs_sum_RandomCV' ...
         '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File]);

