
%
%% Group probability atlas and hard label atlas
%

clear
Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_7Networks/SingleAtlas_Analysis';
VisualizeFolder = [Folder '/Atlas_Visualize'];
mkdir(VisualizeFolder);

%% Group probability atlas
GroupAtlasLoading_Mat = load([Folder '/Group_AtlasLoading.mat']);
for i = 1:7
  % left hemi
  V_lh = gifti;
  V_lh.cdata = GroupAtlasLoading_Mat.sbj_AtlasLoading_lh(i, :)';
  V_lh_File = [VisualizeFolder '/Group_lh_Network_' num2str(i) '.func.gii'];
  save(V_lh, V_lh_File);
  % right hemi
  V_rh = gifti;
  V_rh.cdata = GroupAtlasLoading_Mat.sbj_AtlasLoading_rh(i, :)';
  V_rh_File = [VisualizeFolder '/Group_rh_Network_' num2str(i) '.func.gii'];
  save(V_rh, V_rh_File);
  % convert into cifti file
  cmd = ['wb_command -cifti-create-dense-scalar ' VisualizeFolder '/Group_AtlasLoading_Network_' num2str(i) ...
         '.dscalar.nii -left-metric ' V_lh_File ' -right-metric ' V_rh_File];
  system(cmd);
  pause(1);
  system(['rm -rf ' V_lh_File ' ' V_rh_File]);
end
%% Group hard label atlas
GroupAtlasLabel_Mat = load([Folder '/Group_AtlasLabel.mat']);
ColorInfo_Atlas = [VisualizeFolder '/name_Atlas.txt'];
system(['rm -rf ' ColorInfo_Atlas]);

SystemName = {'Visual', 'DM 1', 'Motor 2', 'DM 2', 'FP', 'VA', 'Motor 2'};
ColorPlate = {'244 197 115', '158 186 204', '229 157 41', '73 143 191', ...
              '65 171 93', '137 63 153', '242 139 168'}
for i = 1:7
  system(['echo ' SystemName{i} ' >> ' ColorInfo_Atlas]);
  system(['echo ' num2str(i) ' ' ColorPlate{i} ' 1 >> ' ColorInfo_Atlas]); 
end

% left hemi
V_lh = gifti;
V_lh.cdata = GroupAtlasLabel_Mat.sbj_AtlasLabel_lh';
V_lh_File = [VisualizeFolder '/Group_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_lh_Label_File = [VisualizeFolder '/Group_lh_AtlasLabel.label.gii'];
cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas ' ' V_lh_Label_File];
system(cmd);
% right hemi
V_rh = gifti;
V_rh.cdata = GroupAtlasLabel_Mat.sbj_AtlasLabel_rh';
V_rh_File = [VisualizeFolder '/Group_rh.func.gii'];
save(V_rh, V_rh_File);
pause(1);
V_rh_Label_File = [VisualizeFolder '/Group_rh_AtlasLabel.label.gii'];
cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas ' ' V_rh_Label_File];
system(cmd);
% convert into cifti file
cmd = ['wb_command -cifti-create-label ' VisualizeFolder '/Group_AtlasLabel' ...
       '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
system(cmd);
pause(1);
%system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

