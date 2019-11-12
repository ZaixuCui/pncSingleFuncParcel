
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = [ReplicationFolder '/Revision'];
% ARI between group atlas and Yeo 17 atlas
Hongming_Group_Data_Mat = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat']);
Hongming_Group_Label = [Hongming_Group_Data_Mat.sbj_AtlasLabel_lh'; Hongming_Group_Data_Mat.sbj_AtlasLabel_rh'];
Yeo17_Data_Mat = load([ReplicationFolder '/data/YeoAtlas/label_17system.mat']);
Yeo17_Label = [Yeo17_Data_Mat.sbj_Label_lh; Yeo17_Data_Mat.sbj_Label_rh];
NonZeroIndex = find(Hongming_Group_Label ~= 0); % Removing medial wall & low signal regions which we did not use
ARI_HongmingGroup_Yeo17 = rand_index(Hongming_Group_Label(NonZeroIndex), Yeo17_Label(NonZeroIndex), 'adjusted');

% ARI between rand group atlas and Yeo 17 atlas
PermuteFolder = [ResultsFolder '/Atlas_Homogeneity_Reliability/PermuteData_SpinTest/PermuteData'];
GroupAtlasLabel_Data_Mat = load([PermuteFolder '/GroupAtlasLabel_Perm.mat']);
GroupAtlasLabel_Spin = [GroupAtlasLabel_Data_Mat.bigrotl';GroupAtlasLabel_Data_Mat.bigrotr'];
for i = 1:1000
  i
  ARI_HongmingGroupSpin_Yeo17(i) = rand_index(GroupAtlasLabel_Spin(NonZeroIndex, i), Yeo17_Label(NonZeroIndex), 'adjusted');
end

ARI_HongmingGroup_Yeo17_PValue = length(find(ARI_HongmingGroupSpin_Yeo17 > ARI_HongmingGroup_Yeo17)) / 1000;
save([ResultsFolder '/Atlas_Homogeneity_Reliability/ARI_HongmingGroup_Yeo17.mat'], 'ARI_HongmingGroup_Yeo17', 'ARI_HongmingGroupSpin_Yeo17', 'ARI_HongmingGroup_Yeo17_PValue');
