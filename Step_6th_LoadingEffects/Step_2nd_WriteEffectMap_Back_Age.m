
clear
ProjectFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultantFolder = [ProjectFolder '/results/GamAnalysis/AtlasProbability_17_100_20190422'];

% Create file for workbench visualization
SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
% for surface data
surfML = [SubjectsFolder '/label/lh.Medial_wall.label'];
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = [SubjectsFolder '/label/rh.Medial_wall.label'];
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

%% Age
ResultantFolder_Age = [ResultantFolder '/AgeEffects'];
mkdir(ResultantFolder_Age);
ColorInfo_Atlas_Border = [ResultantFolder_Age '/name_Atlas_Border.txt'];
system(['rm -rf ' ColorInfo_Atlas_Border]);
system(['echo Border >> ' ColorInfo_Atlas_Border]);
system(['echo 1 231 97 120 1 >> ' ColorInfo_Atlas_Border]);
for i = 1:17

  i

  AgeEffects = load([ResultantFolder_Age '/AgeEffect_AtlasProbability_17_Network_' num2str(i) '.mat']);

  %% FDR
  %% display Z value (FDR corrected q < 0.05)
  Gam_Z_FDR_Sig_Vector_All_lh = zeros(10242, 1);
  Gam_Z_FDR_Sig_Vector_All_lh(Index_l) = AgeEffects.Gam_Z_FDR_Sig_Vector_All(1:length(Index_l));
  Gam_Z_FDR_Sig_Vector_All_rh = zeros(10242, 1);
  Gam_Z_FDR_Sig_Vector_All_rh(Index_r) = AgeEffects.Gam_Z_FDR_Sig_Vector_All(length(Index_l) + 1:end);
  % left hemi
  V_lh = gifti;
  V_lh.cdata = Gam_Z_FDR_Sig_Vector_All_lh;
  V_lh_File = [ResultantFolder_Age '/Gam_Z_FDR_Sig_Vector_All_Age_lh_Network_' num2str(i) '.func.gii'];
  save(V_lh, V_lh_File);
  % right hemi
  V_rh = gifti;
  V_rh.cdata = Gam_Z_FDR_Sig_Vector_All_rh;
  V_rh_File = [ResultantFolder_Age '/Gam_Z_FDR_Sig_Vector_All_Age_rh_Network_' num2str(i) '.func.gii'];
  save(V_rh, V_rh_File);
  % convert into cifti file
  cmd = ['wb_command -cifti-create-dense-scalar ' ResultantFolder_Age '/Gam_Z_FDR_Sig_Vector_All_Age_Network_' ...
         num2str(i) '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
  system(cmd);

  Gam_Z_Vector_All_lh = zeros(10242, 1);
  Gam_Z_Vector_All_lh(Index_l) = AgeEffects.Gam_Z_Vector_All(1:length(Index_l));
  Gam_Z_Vector_All_rh = zeros(10242, 1);
  Gam_Z_Vector_All_rh(Index_r) = AgeEffects.Gam_Z_Vector_All(length(Index_l) + 1:end);
  save([ResultantFolder_Age '/AgeEffect_AtlasProbability_17_Network_' num2str(i) '.mat'], 'Gam_Z_FDR_Sig_Vector_All_lh', 'Gam_Z_FDR_Sig_Vector_All_rh', 'Gam_Z_Vector_All_lh', 'Gam_Z_Vector_All_rh', '-append');

end
