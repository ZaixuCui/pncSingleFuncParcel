
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
GamFolder = [ReplicationFolder '/results/GamAnalysis/AtlasProbability_17_100_20190422/CognitionEffects'];

SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
% for surface data
surfML = [SubjectsFolder '/label/lh.Medial_wall.label'];
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = [SubjectsFolder '/label/rh.Medial_wall.label'];
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

CognitionZ_abs_sum_lh = zeros(10242, 1);
CognitionZ_abs_sum_rh = zeros(10242, 1);
%% Calculate the sum of z value across 17 networks
for i = 1:17
    tmp_Data = load([GamFolder '/CognitionEffect_AtlasProbability_17_Network_' num2str(i) '.mat']);
    CognitionZ_abs_sum_lh = CognitionZ_abs_sum_lh + abs(tmp_Data.Gam_Z_Vector_All_lh);
    CognitionZ_abs_sum_rh = CognitionZ_abs_sum_rh + abs(tmp_Data.Gam_Z_Vector_All_rh);
end
CognitionZ_abs_sum_WholeBrain = [CognitionZ_abs_sum_lh CognitionZ_abs_sum_rh];

GroupAtlasLabel_Mat = load([ReplicationFolder '/results/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat']);
AtlasLabel_lh = GroupAtlasLabel_Mat.sbj_AtlasLabel_lh;
AtlasLabel_rh = GroupAtlasLabel_Mat.sbj_AtlasLabel_rh;
AtlasLabel_WholeBrain = [AtlasLabel_lh AtlasLabel_rh];

CognitionZMap_NetworkAvg_lh = zeros(size(AtlasLabel_lh));
CognitionZMap_NetworkAvg_rh = zeros(size(AtlasLabel_rh));

for i = 1:17
    CognitionZ_NetworkAvg_System_I = mean(CognitionZ_abs_sum_WholeBrain(find(AtlasLabel_WholeBrain == i)));
    CognitionZMap_NetworkAvg_lh(find(AtlasLabel_lh == i)) = CognitionZ_NetworkAvg_System_I;
    CognitionZMap_NetworkAvg_rh(find(AtlasLabel_rh == i)) = CognitionZ_NetworkAvg_System_I;
end

V_lh = gifti;
V_lh.cdata = CognitionZMap_NetworkAvg_lh';
V_lh_File = [GamFolder '/CognitionZMap_17NetworkAbsSum_NetworkAvg_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_rh = gifti;
V_rh.cdata = CognitionZMap_NetworkAvg_rh';
V_rh_File = [GamFolder '/CognitionZMap_17NetworkAbsSum_NetworkAvg_rh.func.gii'];
save(V_rh, V_rh_File);
% combine 
cmd = ['wb_command -cifti-create-dense-scalar ' GamFolder '/CognitionZMap_17NetworkAbsSum_NetworkAvg' ...
         '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File]);

