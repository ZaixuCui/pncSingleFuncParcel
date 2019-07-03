
clear
WorkingFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/SingleParcellation_Kong/WorkingFolder';
LabelFolder = [WorkingFolder '/ind_parcellation_200_30'];
DataCell = g_ls([LabelFolder '/*.mat']);
for i = 1:length(DataCell)
  i
  tmp = load(DataCell{i});
  sbj_Label_lh_Matrix(i, :) = tmp.lh_labels;
  sbj_Label_rh_Matrix(i, :) = tmp.rh_labels;
end
%
% Reference for the variability calculation
% https://stats.stackexchange.com/questions/221332/variance-of-a-distribution-of-multi-level-categorical-data
%
for m = 1:10242
  m
  for n = 1:17
    % left hemi
    Probability_lh(m, n) = length(find(sbj_Label_lh_Matrix(:, m) == n)) / 693;
    Probability_lh(m, n) = Probability_lh(m, n) * log2(Probability_lh(m, n));
    % right hemi
    Probability_rh(m, n) = length(find(sbj_Label_rh_Matrix(:, m) == n)) / 693;
    Probability_rh(m, n) = Probability_rh(m, n) * log2(Probability_rh(m, n));
  end
  Probability_lh(find(isnan(Probability_lh))) = 0;
  Probability_rh(find(isnan(Probability_rh))) = 0;
  variability_lh(m) = -sum(Probability_lh(m, :));
  variability_rh(m) = -sum(Probability_rh(m, :));
end

Variability_Visualize_Folder = [WorkingFolder '/Variability_Visualize'];
mkdir(Variability_Visualize_Folder);
save([Variability_Visualize_Folder '/Variability.mat'], 'variability_lh', 'variability_rh');

% For visualization
V_lh = gifti;
V_lh.cdata = variability_lh';
V_lh_File = [Variability_Visualize_Folder '/Variability_lh.func.gii'];
save(V_lh, V_lh_File);
V_rh = gifti;
V_rh.cdata = variability_rh';
V_rh_File = [Variability_Visualize_Folder '/Variability_rh.func.gii'];
save(V_rh, V_rh_File);
cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/VariabilityLabel_Kong' ...
       '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);
system(['rm -rf ' V_lh_File ' ' V_rh_File]);

