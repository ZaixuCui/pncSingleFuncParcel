
%
% For variability of probability atlas:
% Using MADM=median(|x(i) - median(x)|) to calculate variability
% For variability of hard label atlas:
% See: 
%   https://stats.stackexchange.com/questions/221332/variance-of-a-distribution-of-multi-level-categorical-data
%

clear
WorkingFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation/SingleAtlas_Analysis';

SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects/fsaverage5';
surfML = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/lh.Mask_SNR.label';
mwIndVec_l = read_medial_wall_label(surfML);
Index_l = setdiff([1:10242], mwIndVec_l);
surfMR = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/SNR_Mask/subjects/fsaverage5/rh.Mask_SNR.label';
mwIndVec_r = read_medial_wall_label(surfMR);
Index_r = setdiff([1:10242], mwIndVec_r);

AgeInfo = load('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/Age_Info.mat');
BBLID = AgeInfo.BBLID;
Age_Month = AgeInfo.Age;

% Split into 3 groups according to age
[~, Sorted_Index] = sort(Age_Month);
AllSubsets_BBLID = {BBLID(Sorted_Index(1:231)), ...
                     BBLID(Sorted_Index(232:462)), ...
                     BBLID(Sorted_Index(463:693))};
%
% Variability of probability atlas
%
LoadingFolder = [WorkingFolder '/FinalAtlasLoading'];
LabelFolder = [WorkingFolder '/FinalAtlasLabel'];
Variability_Visualize_Folder = [WorkingFolder '/Variability_Visualize_3AgeGroups'];
mkdir(Variability_Visualize_Folder);
for i = 1:3
  SubsetBBLID = AllSubsets_BBLID{i};
  DataCell = cell(length(SubsetBBLID), 1);
  for j = 1:length(SubsetBBLID)
    DataCell{j} = [LoadingFolder '/' num2str(SubsetBBLID(j)) '.mat'];
  end
  
  for j = 1:length(DataCell)
    j
    tmp = load(DataCell{j});
    for k = 1:17
      cmd = ['sbj_Loading_lh_Matrix_' num2str(k) '(j, :) = tmp.sbj_AtlasLoading_lh(k, :);'];
      eval(cmd);
      cmd = ['sbj_Loading_rh_Matrix_' num2str(k) '(j, :) = tmp.sbj_AtlasLoading_rh(k, :);'];
      eval(cmd);
    end
  end
  %
  Variability_All_lh = zeros(17, 10242);
  Variability_All_rh = zeros(17, 10242);
  for m = 1:17
    m
    for n = 1:10242
      % left hemi
      cmd = ['tmp_data = sbj_Loading_lh_Matrix_' num2str(m) '(:, n);'];
      eval(cmd);
      Variability_lh(n) = median(abs(tmp_data - median(tmp_data)));
      eval(cmd);
      % right hemi
      cmd = ['tmp_data = sbj_Loading_rh_Matrix_' num2str(m) '(:, n);'];
      eval(cmd);
      Variability_rh(n) = median(abs(tmp_data - median(tmp_data)));
    end

    % write to files
    V_lh = gifti;
    V_lh.cdata = Variability_lh';
    V_lh_File = [Variability_Visualize_Folder '/Variability_lh_' num2str(m) '_AgeGroup_' num2str(i) '.func.gii'];
    save(V_lh, V_lh_File);
    V_rh = gifti;
    V_rh.cdata = Variability_rh';
    V_rh_File = [Variability_Visualize_Folder '/Variability_rh_' num2str(m) '_AgeGroup_' num2str(i) '.func.gii'];
    save(V_rh, V_rh_File);
    % convert into cifti file
    cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/Variability_' num2str(m) ...
           '_AgeGroup_' num2str(i) '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
    system(cmd);
    pause(1);
    system(['rm -rf ' V_lh_File ' ' V_rh_File]);
 
    Variability_All_lh(m, :) = Variability_lh;
    Variability_All_rh(m, :) = Variability_rh;
  end
  Variability_All_NoMedialWall = [Variability_All_lh(:, Index_l) Variability_All_rh(:, Index_r)];
  save([Variability_Visualize_Folder '/VariabilityLoading_AgeGroup_' num2str(i) '.mat'], ...
       'Variability_All_lh', 'Variability_All_rh', 'Variability_All_NoMedialWall');
  % 17 system mean
  VariabilityLoading_Median_17SystemMean_lh = mean(Variability_All_lh);
  VariabilityLoading_Median_17SystemMean_rh = mean(Variability_All_rh);
  V_lh = gifti;
  V_lh.cdata = VariabilityLoading_Median_17SystemMean_lh';
  V_lh_File = [Variability_Visualize_Folder '/VariabilityLoading_17SystemMean_lh_AgeGroup_' num2str(i) '.func.gii'];
  save(V_lh, V_lh_File);
  V_rh = gifti;
  V_rh.cdata = VariabilityLoading_Median_17SystemMean_rh';
  V_rh_File = [Variability_Visualize_Folder '/VariabilityLoading_17SystemMean_rh_AgeGroup_' num2str(i) '.func.gii'];
  save(V_rh, V_rh_File);
  cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/VariabilityLoading_17SystemMean' ...
        '_AgeGroup_' num2str(i) '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
  system(cmd);
  pause(1);
  system(['rm -rf ' V_lh_File ' ' V_rh_File]);
  % Save average variability of 17 system 
  VariabilityLoading_Median_17SystemMean_NoMedialWall = [VariabilityLoading_Median_17SystemMean_lh(Index_l) ...
      VariabilityLoading_Median_17SystemMean_rh(Index_r)];
  save([Variability_Visualize_Folder '/VariabilityLoading_Median_17SystemMean_AgeGroup_' num2str(i) '.mat'], ...
      'VariabilityLoading_Median_17SystemMean_lh', 'VariabilityLoading_Median_17SystemMean_rh', ...
      'VariabilityLoading_Median_17SystemMean_NoMedialWall');

  %%%%%%%%%%%%%%%%%%%%%
  % hard parcellation %
  %%%%%%%%%%%%%%%%%%%%%
  DataCell = cell(length(SubsetBBLID), 1);
  for j = 1:length(SubsetBBLID)
    DataCell{j} = [LabelFolder '/' num2str(SubsetBBLID(j)) '.mat'];
  end
  for j = 1:length(DataCell)
    j
    tmp = load(DataCell{j});
    sbj_AtlasLabel_lh_Matrix(j, :) = tmp.sbj_AtlasLabel_lh;
    sbj_AtlasLabel_rh_Matrix(j, :) = tmp.sbj_AtlasLabel_rh;
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
  VariabilityLabel_NoMedialWall = [VariabilityLabel_lh(Index_l) VariabilityLabel_rh(Index_r)];
  save([Variability_Visualize_Folder '/VariabilityLabel_AgeGroup_' num2str(i) '.mat'], 'VariabilityLabel_lh', 'VariabilityLabel_rh', 'VariabilityLabel_NoMedialWall');

  % For visualization
  V_lh = gifti;
  V_lh.cdata = VariabilityLabel_lh';
  V_lh_File = [Variability_Visualize_Folder '/VariabilityLabel_lh.func.gii'];
  save(V_lh, V_lh_File);
  V_rh = gifti;
  V_rh.cdata = VariabilityLabel_rh';
  V_rh_File = [Variability_Visualize_Folder '/VariabilityLabel_rh.func.gii'];
  save(V_rh, V_rh_File);
  cmd = ['wb_command -cifti-create-dense-scalar ' Variability_Visualize_Folder '/VariabilityLabel' ...
         '_AgeGroup_' num2str(i) '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
  system(cmd);
  system(['rm -rf ' V_lh_File ' ' V_rh_File]);
end

% Correlation amongth the three variability map
for i = 1:3
  tmp = load([Variability_Visualize_Folder '/VariabilityLoading_Median_17SystemMean_AgeGroup_' num2str(i) '.mat']);  
  NetworkVariability_All(i, :) = tmp.VariabilityLoading_Median_17SystemMean_NoMedialWall;
end
corr(NetworkVariability_All(1,:)', NetworkVariability_All(2,:)')
corr(NetworkVariability_All(1,:)', NetworkVariability_All(3,:)')
corr(NetworkVariability_All(2,:)', NetworkVariability_All(3,:)')

