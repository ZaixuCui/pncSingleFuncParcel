
clear
ProjectFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
% Projecting power atlas from MNI to freesurfer surface
PowerAtlas_Folder = [ProjectFolder '/data/PowerAtlas'];
PowerAtlas_MNI = [PowerAtlas_Folder '/power264MNI.nii.gz'];
PowerAtlas_fsaverage = [PowerAtlas_Folder '/power264_fs.'];
PowerAtlas_fsaverage5 = [PowerAtlas_Folder '/power264_fs5.'];

MNI152_VolumeToSurface = '/share/apps/freesurfer/6.0.0/average/mni152.register.dat';
hemi = {'lh', 'rh'};
for i = 1:2
  % Project
  cmd = ['mri_vol2surf --mov ' PowerAtlas_MNI ' --reg ' MNI152_VolumeToSurface ...
         ' --hemi ' hemi{i} ' --o ' PowerAtlas_fsaverage hemi{i} ...
         '.mgh --projfrac 0.5 --interp nearest --noreshape'];
  %system(cmd);
  % down-sample to fsaverage5
  cmd = ['mri_surf2surf --srcsubject fsaverage --srcsurfval ' PowerAtlas_fsaverage ...
         hemi{i} '.mgh --trgsubject ico --trgicoorder 5 --trgsurfval ' ...
         PowerAtlas_fsaverage5 hemi{i} '.mgh --hemi ' hemi{i} ' --mapmethod nnf'];
  %system(cmd);
end

% Naming networks
Power_lh = MRIread([PowerAtlas_Folder '/power264_fs5.lh.mgh']);
Power_lh = Power_lh.vol;
Power_rh = MRIread([PowerAtlas_Folder '/power264_fs5.rh.mgh']);
Power_rh = Power_rh.vol;
Power264_CommunityAffiliation = load([PowerAtlas_Folder '/Power264CommunityAffiliation.txt']);

Power_Atlas = [Power_lh Power_rh];
Unique_index = setdiff(unique(Power_Atlas), 0);
% Covert Power atlas region index to their community index
for i = 1:length(Unique_index)
  Power_Atlas(find(Power_Atlas == Unique_index(i))) = Power264_CommunityAffiliation(Unique_index(i));
end

% Calculating overlap between our group parcellation and power community index
GroupAtlas_Path = [ProjectFolder '/Revision/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat'];
GroupAtlas = load(GroupAtlas_Path);
GroupAtlas = [GroupAtlas.sbj_AtlasLabel_lh GroupAtlas.sbj_AtlasLabel_rh];
for i = 1:17
  Vertex_Index = find(GroupAtlas == i);
  PowerCommunity_index = Power_Atlas(Vertex_Index);
  Community_Unique_index = setdiff(unique(PowerCommunity_index), 0);
  clear VertexQuantity;
  for j = 1:length(Community_Unique_index)
    VertexQuantity(j) = length(find(PowerCommunity_index == Community_Unique_index(j)));
  end
  [~, Maximum_index] = max(VertexQuantity);
  NetworkLabel(i) = Community_Unique_index(Maximum_index);
end

Power_Network_Label = {'somatomotorHand', 'somatomotorMouth', 'cinguloopercular', ...
   'auditory', 'default', 'memoryRetrieval', 'visual', 'frontoparietal', 'salience', ...
   'subcortical', 'ventralAttention', 'dorsalAttention', 'cerebellar', 'none'};

for i = 1:17
  disp([num2str(i) ': ' Power_Network_Label{NetworkLabel(i)}]);
end

