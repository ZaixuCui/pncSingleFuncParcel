
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
PredictionFolder = [ReplicationFolder '/results/PredictionAnalysis/AtlasLoading/'];
VisualizeFolder = [PredictionFolder '/WeightVisualize_Age'];
mkdir(VisualizeFolder);
w_Brain_Mat = load([PredictionFolder '/Weight_Age/w_Brain.mat']);
load([PredictionFolder '/AtlasLoading_All_RemoveZero.mat']);
w_Brain_Age = w_Brain_Mat.w_Brain;

SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
% for surface data
surfML = [SubjectsFolder '/label/lh.Medial_wall.label'];
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = [SubjectsFolder '/label/rh.Medial_wall.label'];
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

%%%%%%%%%%%%%%%%%%
% Age Prediction %
%%%%%%%%%%%%%%%%%%
VertexQuantity = 18715;
w_Brain_Age_All = zeros(1, 18715*17);
w_Brain_Age_All(NonZeroIndex) = w_Brain_Age;
%% Weight of all regions
for i = 1:17
    w_Brain_Age_Matrix(i, :) = w_Brain_Age_All([(i - 1) * VertexQuantity + 1 : i * VertexQuantity]);
end

%% Display the weight of the first 25% regions with the highest absolute weight
mkdir([VisualizeFolder '/First25Percent']);
w_Brain_Age_Abs = abs(w_Brain_Age);
[~, Sorted_IDs] = sort(w_Brain_Age_Abs);
w_Brain_Age_Abs_FirstPercent = w_Brain_Age_Abs;
w_Brain_Age_Abs_FirstPercent(Sorted_IDs(1:round(length(Sorted_IDs) * 0.75))) = 0;
w_Brain_Age_Abs_FirstPercent_All = zeros(1, 18715*17);
w_Brain_Age_Abs_FirstPercent_All(NonZeroIndex) = w_Brain_Age_Abs_FirstPercent;
AgeEffect_Folder = [ReplicationFolder '/results/GamAnalysis/AtlasProbability_17_100_20190422/AgeEffects'];
for i = 1:17
    i
    w_Brain_Age_Abs_FirstPercent_I = w_Brain_Age_Abs_FirstPercent_All([(i - 1) * VertexQuantity + 1 : i * VertexQuantity]);
    
    % Define the sign of the weight by GLM/partial correlation
    AgeEffect_Folder = [ReplicationFolder '/results/GamAnalysis/AtlasProbability_17_100_20190422/AgeEffects'];
    AgeEffects_Mat = load([AgeEffect_Folder, '/AgeEffect_AtlasProbability_17_Network_', num2str(i), '.mat']);
    AgeZ = AgeEffects_Mat.Gam_Z_Vector_All;
    AgeZ(find(AgeZ < 0)) = -1;
    AgeZ(find(AgeZ > 0)) = 1;
    w_Brain_Age_FirstPercent_I = w_Brain_Age_Abs_FirstPercent_I .* AgeZ;

    % left hemi
    w_Brain_Age_FirstPercent_lh = zeros(1, 10242);
    w_Brain_Age_FirstPercent_lh(Index_l) = w_Brain_Age_FirstPercent_I(1:length(Index_l));
    V_lh = gifti;
    V_lh.cdata = w_Brain_Age_FirstPercent_lh';
    V_lh_File = [VisualizeFolder '/First25Percent/w_Brain_Age_First25Percent_lh_Network_' num2str(i) '.func.gii'];
    save(V_lh, V_lh_File);
    % right hemi
    w_Brain_Age_FirstPercent_rh = zeros(1, 10242);
    w_Brain_Age_FirstPercent_rh(Index_r) = w_Brain_Age_FirstPercent_I(length(Index_l) + 1:end);
    V_rh = gifti;
    V_rh.cdata = w_Brain_Age_FirstPercent_rh';
    V_rh_File = [VisualizeFolder '/First25Percent/w_Brain_Age_First25Percent_rh_Network_' num2str(i) '.func.gii'];
    save(V_rh, V_rh_File);
    % convert into cifti file
    cmd = ['wb_command -cifti-create-dense-scalar ' VisualizeFolder '/First25Percent/w_Brain_Age_First25Percent_Network_' ...
           num2str(i) '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
    system(cmd);
end

%% Absolute sum weight of the 17 maps
w_Brain_Age_Abs_sum = sum(abs(w_Brain_Age_Matrix));
w_Brain_Age_Abs_sum_lh = zeros(1, 10242);
w_Brain_Age_Abs_sum_lh(Index_l) = w_Brain_Age_Abs_sum(1:length(Index_l));
w_Brain_Age_Abs_sum_rh = zeros(1, 10242);
w_Brain_Age_Abs_sum_rh(Index_r) = w_Brain_Age_Abs_sum(length(Index_l) + 1:end);
w_Brain_Age_Abs_sum_WholeBrain = [w_Brain_Age_Abs_sum_lh w_Brain_Age_Abs_sum_rh];
save([PredictionFolder '/Weight_Age/w_Brain_Age_Abs_sum.mat'], 'w_Brain_Age_Abs_sum', 'w_Brain_Age_Abs_sum_lh', 'w_Brain_Age_Abs_sum_rh');

