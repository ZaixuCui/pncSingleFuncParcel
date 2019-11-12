
clear
WorkingFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
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
  Variability_lh(m) = -sum(Probability_lh(m, :));
  Variability_rh(m) = -sum(Probability_rh(m, :));
end

Variability_Visualize_Folder = [WorkingFolder '/Variability_Visualize'];
mkdir(Variability_Visualize_Folder);
save([Variability_Visualize_Folder '/Variability.mat'], 'Variability_lh', 'Variability_rh');

% For visualization
V_lh = gifti;
V_lh.cdata = Variability_lh';
V_lh_File = [Variability_Visualize_Folder '/Variability_lh.func.gii'];
save(V_lh, V_lh_File);
V_rh = gifti;
V_rh.cdata = Variability_rh';
V_rh_File = [Variability_Visualize_Folder '/Variability_rh.func.gii'];
save(V_rh, V_rh_File);
cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/VariabilityLabel_Kong' ...
       '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);
system(['rm -rf ' V_lh_File ' ' V_rh_File]);

% Variability for youngest and oldest groups
AgeInfo = load('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/Age_Info.mat');
BBLID = AgeInfo.BBLID;
Age_Month = AgeInfo.Age;

% Split into 3 groups according to age
[~, Sorted_Index] = sort(Age_Month);
AllSubsets_BBLID = {BBLID(Sorted_Index(1:231)), ...
                     BBLID(Sorted_Index(232:462)), ...
                     BBLID(Sorted_Index(463:693))};

for i = 1:3
  SubsetBBLID = AllSubsets_BBLID{i};
  DataCell = cell(length(SubsetBBLID), 1);
  for j = 1:length(SubsetBBLID)
    DataCell{j} = [LabelFolder '/' num2str(SubsetBBLID(j)) '.mat'];
  end

  for j = 1:length(DataCell)
    j
    tmp = load(DataCell{j});
    sbj_AtlasLabel_lh_Matrix(j, :) = tmp.lh_labels;
    sbj_AtlasLabel_rh_Matrix(j, :) = tmp.rh_labels;
  end
  for m = 1:10242
    m
    for n = 1:17
      % left hemi
      Probability_lh(m, n) = length(find(sbj_AtlasLabel_lh_Matrix(:, m) == n)) / length(SubsetBBLID);
      Probability_lh(m, n) = Probability_lh(m, n) * log2(Probability_lh(m, n));
      % right hemi
      Probability_rh(m, n) = length(find(sbj_AtlasLabel_rh_Matrix(:, m) == n)) / length(SubsetBBLID);
      Probability_rh(m, n) = Probability_rh(m, n) * log2(Probability_rh(m, n));
    end
    Probability_lh(find(isnan(Probability_lh))) = 0;
    Probability_rh(find(isnan(Probability_rh))) = 0;
    VariabilityLabel_lh(m) = -sum(Probability_lh(m, :));
    VariabilityLabel_rh(m) = -sum(Probability_rh(m, :));
  end

  % For visualization
  V_lh = gifti;
  V_lh.cdata = VariabilityLabel_lh';
  V_lh_File = [Variability_Visualize_Folder '/VariabilityLabel_Kong_lh.func.gii'];
  save(V_lh, V_lh_File);
  V_rh = gifti;
  V_rh.cdata = VariabilityLabel_rh';
  V_rh_File = [Variability_Visualize_Folder '/VariabilityLabel_Kong_rh.func.gii'];
  save(V_rh, V_rh_File);
  cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/VariabilityLabel_Kong' ...
         '_AgeGroup_' num2str(i) '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
  system(cmd);
  system(['rm -rf ' V_lh_File ' ' V_rh_File]);
end

