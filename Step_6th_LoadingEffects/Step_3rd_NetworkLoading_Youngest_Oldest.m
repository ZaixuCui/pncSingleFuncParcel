
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
AllSubsets_BBLID = {BBLID(Sorted_Index(1:100)), ...
                     BBLID(Sorted_Index(594:693))};
%
% Variability of probability atlas
%
LoadingFolder = [WorkingFolder '/FinalAtlasLoading'];
LabelFolder = [WorkingFolder '/FinalAtlasLabel'];
NetworkRefinement_Folder = [WorkingFolder '/NetworkRefinement_2'];
mkdir(NetworkRefinement_Folder);
for i = 1:2
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

  for j = 1:17
    j
    cmd = ['GroupLoading_lh(' num2str(j) ', :) = mean(sbj_Loading_lh_Matrix_' num2str(j) ');'];
    eval(cmd);
    cmd = ['GroupLoading_rh(' num2str(j) ', :) = mean(sbj_Loading_rh_Matrix_' num2str(j) ');'];
    eval(cmd);
  end

  %%%%%%%%%%%%%%%%%%%%%
  % hard parcellation %
  %%%%%%%%%%%%%%%%%%%%%
  [~, Label_lh] = max(GroupLoading_lh);
  Label_lh(mwIndVec_l) = 0;
  [~, Label_rh] = max(GroupLoading_rh);
  Label_rh(mwIndVec_r) = 0;
  ColorInfo_Atlas = [WorkingFolder '/Atlas_Visualize/name_Atlas.txt'];

  % left hemi
  V_lh = gifti;
  V_lh.cdata = Label_lh';
  V_lh_File = [NetworkRefinement_Folder '/Group_lh.func.gii'];
  save(V_lh, V_lh_File);
  pause(1);
  V_lh_Label_File = [NetworkRefinement_Folder '/Group_lh_AtlasLabel.label.gii'];
  cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas ' ' V_lh_Label_File];
  system(cmd);
  % right hemi
  V_rh = gifti;
  V_rh.cdata = Label_rh';
  V_rh_File = [NetworkRefinement_Folder '/Group_rh.func.gii'];
  save(V_rh, V_rh_File);
  pause(1);
  V_rh_Label_File = [NetworkRefinement_Folder '/Group_rh_AtlasLabel.label.gii'];
  cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas ' ' V_rh_Label_File];
  system(cmd);
  % convert into cifti file
  cmd = ['wb_command -cifti-create-label ' NetworkRefinement_Folder '/Group_AtlasLabel' ...
         '_AgeGroup_' num2str(i) '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
  system(cmd);
  system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

  GroupLoading_All_NoMedialWall = [GroupLoading_lh(:, Index_l) ...
                                   GroupLoading_rh(:, Index_r)];
  save([NetworkRefinement_Folder '/GroupLoading_' num2str(i) '.mat'], ...
       'GroupLoading_lh', 'GroupLoading_rh', 'GroupLoading_All_NoMedialWall', ...
       'Label_lh', 'Label_rh');
end

% Young (hard parcellation) - Old (hard parcellation)
Young_Atlas = load([NetworkRefinement_Folder '/GroupLoading_1.mat']);
Old_Atlas = load([NetworkRefinement_Folder '/GroupLoading_2.mat']);
Young_Old_Difference_lh = Young_Atlas.Label_lh - Old_Atlas.Label_lh;
Young_Old_Difference_rh = Young_Atlas.Label_rh - Old_Atlas.Label_rh;
Young_Old_Difference_lh(find(Young_Old_Difference_lh)) = 1;
Young_Old_Difference_rh(find(Young_Old_Difference_rh)) = 1;
% write to files
% left hemi
V_lh = gifti;
V_lh.cdata = Young_Old_Difference_lh';
V_lh_File = [NetworkRefinement_Folder '/Young_Old_Difference_lh.func.gii'];
save(V_lh, V_lh_File);
% right hemi
V_rh = gifti;
V_rh.cdata = Young_Old_Difference_rh';
V_rh_File = [NetworkRefinement_Folder '/Young_Old_Difference_rh.func.gii'];
save(V_rh, V_rh_File);
% convert into cifti file
cmd = ['wb_command -cifti-create-dense-scalar ' NetworkRefinement_Folder '/Young_Old_Difference' ...
       '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
system(cmd);

% Extracting regions with differences 
% For young group
Young_Difference_lh = Young_Atlas.Label_lh .* Young_Old_Difference_lh;
Young_Difference_rh = Young_Atlas.Label_rh .* Young_Old_Difference_rh;
% left hemi
V_lh = gifti;
V_lh.cdata = Young_Difference_lh';
V_lh_File = [NetworkRefinement_Folder '/Young_Difference_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_lh_Label_File = [NetworkRefinement_Folder '/Young_Difference_lh_AtlasLabel.label.gii'];
cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas ' ' V_lh_Label_File];
system(cmd);
% right hemi
V_rh = gifti;
V_rh.cdata = Young_Difference_rh';
V_rh_File = [NetworkRefinement_Folder '/Young_Difference_rh.func.gii'];
save(V_rh, V_rh_File);
pause(1);
V_rh_Label_File = [NetworkRefinement_Folder '/Young_Difference_rh_AtlasLabel.label.gii'];
cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas ' ' V_rh_Label_File];
system(cmd);
% convert into cifti file
cmd = ['wb_command -cifti-create-label ' NetworkRefinement_Folder '/Young_Difference_AtlasLabel' ...
       '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
system(cmd);
system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

% For old group
Old_Difference_lh = Old_Atlas.Label_lh .* Young_Old_Difference_lh;
Old_Difference_rh = Old_Atlas.Label_rh .* Young_Old_Difference_rh;
% left hemi
V_lh = gifti;
V_lh.cdata = Old_Difference_lh';
V_lh_File = [NetworkRefinement_Folder '/Old_Difference_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_lh_Label_File = [NetworkRefinement_Folder '/Old_Difference_lh_AtlasLabel.label.gii'];
cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas ' ' V_lh_Label_File];
system(cmd);
% right hemi
V_rh = gifti;
V_rh.cdata = Old_Difference_rh';
V_rh_File = [NetworkRefinement_Folder '/Old_Difference_rh.func.gii'];
save(V_rh, V_rh_File);
pause(1);
V_rh_Label_File = [NetworkRefinement_Folder '/Old_Difference_rh_AtlasLabel.label.gii'];
cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas ' ' V_rh_Label_File];
system(cmd);
% convert into cifti file
cmd = ['wb_command -cifti-create-label ' NetworkRefinement_Folder '/Old_Difference_AtlasLabel' ...
       '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
system(cmd);
system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

