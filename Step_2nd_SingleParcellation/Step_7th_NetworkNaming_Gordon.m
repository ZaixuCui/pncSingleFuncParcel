
clear
ProjectFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
% Projecting gordon atlas from MNI to freesurfer surface
GordonAtlas_Folder = [ProjectFolder '/data/GordonAtlas'];
GordonAtlas_MNI = [GordonAtlas_Folder '/gordon333MNI.nii.gz'];
GordonAtlas_fsaverage = [GordonAtlas_Folder '/gordon333_fs.'];
GordonAtlas_fsaverage5 = [GordonAtlas_Folder '/gordon333_fs5.'];

MNI152_VolumeToSurface = '/share/apps/freesurfer/6.0.0/average/mni152.register.dat';
hemi = {'lh', 'rh'};
for i = 1:2
  % Project
  cmd = ['mri_vol2surf --mov ' GordonAtlas_MNI ' --reg ' MNI152_VolumeToSurface ...
         ' --hemi ' hemi{i} ' --o ' GordonAtlas_fsaverage hemi{i} ...
         '.mgh --projfrac 0.5 --interp nearest --noreshape'];
  system(cmd);
  % down-sample to fsaverage5
  cmd = ['mri_surf2surf --srcsubject fsaverage --srcsurfval ' GordonAtlas_fsaverage ...
         hemi{i} '.mgh --trgsubject ico --trgicoorder 5 --trgsurfval ' ...
         GordonAtlas_fsaverage5 hemi{i} '.mgh --hemi ' hemi{i} ' --mapmethod nnf'];
  system(cmd);
end

% Naming networks
Gordon_lh = MRIread([GordonAtlas_Folder '/gordon333_fs5.lh.mgh']);
Gordon_lh = Gordon_lh.vol;
Gordon_rh = MRIread([GordonAtlas_Folder '/gordon333_fs5.rh.mgh']);
Gordon_rh = Gordon_rh.vol;
Gordon333_CommunityAffiliation = load([GordonAtlas_Folder '/gordon333CommunityAffiliation.txt']);

Gordon_Atlas = [Gordon_lh Gordon_rh];
Unique_index = setdiff(unique(Gordon_Atlas), 0);
% Covert Gordon atlas region index to their community index
for i = 1:length(Unique_index)
  Gordon_Atlas(find(Gordon_Atlas == Unique_index(i))) = Gordon333_CommunityAffiliation(Unique_index(i));
end

% Calculating overlap between our group parcellation and gordon community index
GroupAtlas_Path = [ProjectFolder '/Revision/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat'];
GroupAtlas = load(GroupAtlas_Path);
GroupAtlas = [GroupAtlas.sbj_AtlasLabel_lh GroupAtlas.sbj_AtlasLabel_rh];
for i = 1:17
  Vertex_Index = find(GroupAtlas == i);
  GordonCommunity_index = Gordon_Atlas(Vertex_Index);
  Community_Unique_index = setdiff(unique(GordonCommunity_index), 0);
  clear VertexQuantity;
  for j = 1:length(Community_Unique_index)
    VertexQuantity(j) = length(find(GordonCommunity_index == Community_Unique_index(j)));
  end
  [~, Maximum_index] = max(VertexQuantity);
  NetworkLabel(i) = Community_Unique_index(Maximum_index);
end

Gordon_Network_Label = {'default', 'somatomotorHand', 'somatomotorMouth', ...
   'visual', 'frontoparietal', 'auditory', 'cinguloparietal', 'retrosplenialTemporal', ...
   'cinguloopercular', 'ventralAttention', 'salience', 'dorsalAttention', 'none'};

for i = 1:17
  disp([num2str(i) ': ' Gordon_Network_Label{NetworkLabel(i)}]);
end

