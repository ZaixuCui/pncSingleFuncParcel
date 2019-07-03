
clear
MethodKong_Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/SingleParcellation_Kong/';
WorkingFolder = [MethodKong_Folder '/WorkingFolder'];
VisualizeFolder = [MethodKong_Folder '/AtlasVisualize'];
mkdir(VisualizeFolder);

ColorInfo_Atlas17 = [VisualizeFolder '/name_Atlas17.txt'];
system(['rm -rf ' ColorInfo_Atlas17]);
system(['echo Dorsal attention 1 >> ' ColorInfo_Atlas17]);
system(['echo 1 74 155 60 1 >> ' ColorInfo_Atlas17]);
system(['echo Default mode 1 >> ' ColorInfo_Atlas17]);
system(['echo 2 205 62 78 1 >> ' ColorInfo_Atlas17]);
system(['echo Motor 1 >> ' ColorInfo_Atlas17]);
system(['echo 3 70 130 180 1 >> ' ColorInfo_Atlas17]);
system(['echo Default mode 2 >> ' ColorInfo_Atlas17]);
system(['echo 4 255 255 0 1 >> ' ColorInfo_Atlas17]);
system(['echo Default mode 3 >> ' ColorInfo_Atlas17]);
system(['echo 5 12 48 255 1 >> ' ColorInfo_Atlas17]);
system(['echo Visual 1 >> ' ColorInfo_Atlas17]);
system(['echo 6 255 0 0 1 >> ' ColorInfo_Atlas17]);
system(['echo Ventral attention 1 >> ' ColorInfo_Atlas17]);
system(['echo 7 196 58 250 1 >> ' ColorInfo_Atlas17]);
system(['echo Dorsal attention 2 >> ' ColorInfo_Atlas17]);
system(['echo 8 0 118 14 1 >> ' ColorInfo_Atlas17]);
system(['echo Ventral attention 2 >> ' ColorInfo_Atlas17]);
system(['echo 10 255 152 213 1 >> ' ColorInfo_Atlas17]);
system(['echo Frontoparietal 1 >> ' ColorInfo_Atlas17]);
system(['echo 11 230 148 34 1 >> ' ColorInfo_Atlas17]);
system(['echo Visual 2 >> ' ColorInfo_Atlas17]);
system(['echo 12 120 18 134 1 >> ' ColorInfo_Atlas17]);
system(['echo Motor 2 >> ' ColorInfo_Atlas17]);
system(['echo 13 42 204 164 1 >> ' ColorInfo_Atlas17]);
system(['echo Frontoparietal 2 >> ' ColorInfo_Atlas17]);
system(['echo 14 119 140 176 1 >> ' ColorInfo_Atlas17]);
system(['echo Frontoparietal 3 >> ' ColorInfo_Atlas17]);
system(['echo 15 135 50 74 1 >> ' ColorInfo_Atlas17]);
system(['echo Limbic 2 >> ' ColorInfo_Atlas17]);
system(['echo 16 122 135 50 1 >> ' ColorInfo_Atlas17]);
system(['echo Default mode 4 >> ' ColorInfo_Atlas17]);
system(['echo 17 0 0 170 1 >> ' ColorInfo_Atlas17]);

%% Group
GroupLabel_Mat = load([WorkingFolder '/group/group.mat']);
% left hemi
V_lh = gifti;
V_lh.cdata = GroupLabel_Mat.lh_labels;
V_lh_File = [VisualizeFolder '/GroupAverage_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_lh_Label_File = [VisualizeFolder '/GroupAverage_lh_Atlas17.label.gii'];
cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas17 ' ' V_lh_Label_File];
system(cmd);
% right hemi
V_rh = gifti;
V_rh.cdata = GroupLabel_Mat.rh_labels;
V_rh_File = [VisualizeFolder '/GroupAverage_rh.func.gii'];
save(V_rh, V_rh_File);
pause(1);
V_rh_Label_File = [VisualizeFolder '/GroupAverage_rh_Atlas17.label.gii'];
cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas17 ' ' V_rh_Label_File];
system(cmd);
% convert into cifti file
cmd = ['wb_command -cifti-create-label ' VisualizeFolder '/Group_AtlasLabel17_Kong' ...
       '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

%% Subject 1
Sub1Label_Mat = load([WorkingFolder '/ind_parcellation_200_30/100031.mat']);
% left hemi
V_lh = gifti;
V_lh.cdata = Sub1Label_Mat.lh_labels;
V_lh_File = [VisualizeFolder '/100031_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_lh_Label_File = [VisualizeFolder '/100031_lh_Atlas17.label.gii'];
cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas17 ' ' V_lh_Label_File];
system(cmd);
% right hemi
V_rh = gifti;
V_rh.cdata = Sub1Label_Mat.rh_labels;
V_rh_File = [VisualizeFolder '/100031_rh.func.gii'];
save(V_rh, V_rh_File);
pause(1);
V_rh_Label_File = [VisualizeFolder '/100031_rh_Atlas17.label.gii'];
cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas17 ' ' V_rh_Label_File];
system(cmd);
% convert into cifti file
cmd = ['wb_command -cifti-create-label ' VisualizeFolder '/100031_AtlasLabel17_Kong' ...
       '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

%% Subject 2
Sub2Label_Mat = load([WorkingFolder '/ind_parcellation_200_30/100050.mat']);
% left hemi
V_lh = gifti;
V_lh.cdata = Sub2Label_Mat.lh_labels;
V_lh_File = [VisualizeFolder '/100050_lh.func.gii'];
save(V_lh, V_lh_File);
pause(1);
V_lh_Label_File = [VisualizeFolder '/100050_lh_Atlas17.label.gii'];
cmd = ['wb_command -metric-label-import ' V_lh_File ' ' ColorInfo_Atlas17 ' ' V_lh_Label_File];
system(cmd);
% right hemi
V_rh = gifti;
V_rh.cdata = Sub2Label_Mat.rh_labels;
V_rh_File = [VisualizeFolder '/100050_rh.func.gii'];
save(V_rh, V_rh_File);
pause(1);
V_rh_Label_File = [VisualizeFolder '/100050_rh_Atlas17.label.gii'];
cmd = ['wb_command -metric-label-import ' V_rh_File ' ' ColorInfo_Atlas17 ' ' V_rh_Label_File];
system(cmd);
% convert into cifti file
cmd = ['wb_command -cifti-create-label ' VisualizeFolder '/100050_AtlasLabel17_Kong' ...
       '.dlabel.nii -left-label ' V_lh_Label_File ' -right-label ' V_rh_Label_File];
system(cmd);
pause(1);
system(['rm -rf ' V_lh_File ' ' V_rh_File ' ' V_lh_Label_File ' ' V_rh_Label_File]);

