
%
% For variability of probability atlas:
% Using MADM=median(|x(i) - median(x)|) to calculate variability
% For variability of hard label atlas:
% See: 
%   https://stats.stackexchange.com/questions/221332/variance-of-a-distribution-of-multi-level-categorical-data
%

clear
WorkingFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_7Networks/SingleAtlas_Analysis';

SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
surfML = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/lh.Mask_SNR.label';
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/rh.Mask_SNR.label';
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

%
% Variability of probability atlas
%
LoadingFolder = [WorkingFolder '/FinalAtlasLoading'];
DataCell = g_ls([LoadingFolder '/*.mat']);
for i = 1:length(DataCell)
  i
  tmp = load(DataCell{i});
  for j = 1:7
    cmd = ['sbj_Label_lh_Matrix_' num2str(j) '(i, :) = tmp.sbj_AtlasLoading_lh(j, :);'];
    eval(cmd);
    cmd = ['sbj_Label_rh_Matrix_' num2str(j) '(i, :) = tmp.sbj_AtlasLoading_rh(j, :);'];
    eval(cmd);
  end
end
%
Variability_Visualize_Folder = [WorkingFolder '/Variability_Visualize'];
mkdir(Variability_Visualize_Folder);
Variability_All_lh = zeros(7, 10242);
Variability_All_rh = zeros(7, 10242);
for m = 1:7
  m
  for n = 1:10242
    % left hemi
    cmd = ['tmp_data = sbj_Label_lh_Matrix_' num2str(m) '(:, n);'];
    eval(cmd);
    Variability_lh(n) = median(abs(tmp_data - median(tmp_data)));
    eval(cmd);
    % right hemi
    cmd = ['tmp_data = sbj_Label_rh_Matrix_' num2str(m) '(:, n);'];
    eval(cmd);
    Variability_rh(n) = median(abs(tmp_data - median(tmp_data)));
  end

  % write to files
  V_lh = gifti;
  V_lh.cdata = Variability_lh';
  V_lh_File = [Variability_Visualize_Folder '/Variability_lh_' num2str(m) '.func.gii'];
  save(V_lh, V_lh_File);
  V_rh = gifti;
  V_rh.cdata = Variability_rh';
  V_rh_File = [Variability_Visualize_Folder '/Variability_rh_' num2str(m) '.func.gii'];
  save(V_rh, V_rh_File);
  % convert into cifti file
  cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/Variability_' num2str(m) ...
         '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
  system(cmd);
  pause(1);
  system(['rm -rf ' V_lh_File ' ' V_rh_File]);
 
  Variability_All_lh(m, :) = Variability_lh;
  Variability_All_rh(m, :) = Variability_rh;
end
Variability_All_NoMedialWall = [Variability_All_lh(:, Index_l) Variability_All_rh(:, Index_r)];
save([Variability_Visualize_Folder '/VariabilityLoading.mat'], 'Variability_All_lh', 'Variability_All_rh', 'Variability_All_NoMedialWall');
% 7 system mean
VariabilityLoading_Median_7SystemMean_lh = mean(Variability_All_lh);
VariabilityLoading_Median_7SystemMean_rh = mean(Variability_All_rh);
V_lh = gifti;
V_lh.cdata = VariabilityLoading_Median_7SystemMean_lh';
V_lh_File = [Variability_Visualize_Folder '/VariabilityLoading_7SystemMean_lh.func.gii'];
save(V_lh, V_lh_File);
V_rh = gifti;
V_rh.cdata = VariabilityLoading_Median_7SystemMean_rh';
V_rh_File = [Variability_Visualize_Folder '/VariabilityLoading_7SystemMean_rh.func.gii'];
save(V_rh, V_rh_File);
cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/VariabilityLoading_7SystemMean' ...
       '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File]);
% Save average variability of 7 system 
VariabilityLoading_Median_7SystemMean_NoMedialWall = [VariabilityLoading_Median_7SystemMean_lh(Index_l) ...
    VariabilityLoading_Median_7SystemMean_rh(Index_r)];
save([Variability_Visualize_Folder '/VariabilityLoading_Median_7SystemMean.mat'], ...
    'VariabilityLoading_Median_7SystemMean_lh', 'VariabilityLoading_Median_7SystemMean_rh', ...
    'VariabilityLoading_Median_7SystemMean_NoMedialWall');

