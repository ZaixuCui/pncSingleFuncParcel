
clear
% 
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
ScanID = Demogra_Info(:, 2);
FSFolder = [DataFolder '/SNR_Mask/RawImage_FS_Smooth'];
FS_Avg_Folder = [DataFolder '/SNR_Mask/RawImage_FS_Smooth_Avg'];
Modality = {'RestingState', 'NBack', 'EmotionIden'};

% Read Yeo atlas as brain mask
Yeo_System_Path = [DataFolder '/YeoAtlas/Yeo_17system'];
Yeo_System_lh = gifti([Yeo_System_Path '/Yeo_17system_lh.label.gii']);
Yeo_System_lh = Yeo_System_lh.cdata;
Yeo_System_rh = gifti([Yeo_System_Path '/Yeo_17system_rh.label.gii']);
Yeo_System_rh = Yeo_System_rh.cdata;

SNR_Average_lh = zeros(1, 10242);
SNR_Average_rh = zeros(1, 10242);
for i = 1:length(BBLID)
  i
  for j = 1:3
    % Read images
    lh_data = MRIread([FSFolder '/' Modality{j} '/' num2str(BBLID(i)) '/surf/lh.fs5.sm6.residualised.mgh']);
    lh_data = lh_data.vol;
    rh_data = MRIread([FSFolder '/' Modality{j} '/' num2str(BBLID(i)) '/surf/rh.fs5.sm6.residualised.mgh']);
    rh_data = rh_data.vol;

    lh_data(find(~Yeo_System_lh)) = 0;
    rh_data(find(~Yeo_System_rh)) = 0;

    All_data = [lh_data rh_data];
    % find the value that at the center of the distribution
    [Num, Center] = hist(All_data(find(All_data)), 11);
    for k = 1:11
      if sum(Num(1:k)) > 18715/2
        Center = Center(k);
        break;
      end
    end
    lh_data = lh_data/Center * 1000;
    rh_data = rh_data/Center * 1000;

    SNR_Average_lh = SNR_Average_lh + lh_data;
    SNR_Average_rh = SNR_Average_rh + rh_data;
  end
end

% write the average signal map into cifti file
mkdir(FS_Avg_Folder);
SNR_Average_lh = SNR_Average_lh / (length(BBLID) * 3);
SNR_Average_rh = SNR_Average_rh / (length(BBLID) * 3);

All_Data = [SNR_Average_lh SNR_Average_rh];
% find the value that at the center of the distribution
[Num, Center] = hist(All_data(find(All_data)), 11);
for k = 1:11
  if sum(Num(1:k)) > 18715/2
    Center = Center(k);
    break;
  end
end
% write the average SNR signal map
SNR_Average_lh = SNR_Average_lh/Center * 1000;
SNR_Average_rh = SNR_Average_rh/Center * 1000;
CZ_CiftiWrite_dscalar(SNR_Average_lh', SNR_Average_rh', ...
                      [FS_Avg_Folder '/SNR_Average_lh.func.gii'], ...
                      [FS_Avg_Folder '/SNR_Average_rh.func.gii'], ...
                      [FS_Avg_Folder '/SNR_Average.dscalar.nii']);

% write the theresholded SNR map
SNR_Average_lh(find(SNR_Average_lh < 800)) = 0;
SNR_Average_rh(find(SNR_Average_rh < 800)) = 0;
CZ_CiftiWrite_dscalar(SNR_Average_lh', SNR_Average_rh', ...
                      [FS_Avg_Folder '/SNR_Average_Thres800_lh.func.gii'], ...
                      [FS_Avg_Folder '/SNR_Average_Thres800_rh.func.gii'], ...
                      [FS_Avg_Folder '/SNR_Average_Thres800.dscalar.nii']);

% write the mask map
SNR_Average_lh(find(SNR_Average_lh)) = 1;
SNR_Average_rh(find(SNR_Average_rh)) = 1;
CZ_CiftiWrite_dscalar(SNR_Average_lh', SNR_Average_rh', ...
                      [FS_Avg_Folder '/SNR_Average_Thres800_Mask_lh.func.gii'], ...
                      [FS_Avg_Folder '/SNR_Average_Thres800_Mask_rh.func.gii'], ...
                      [FS_Avg_Folder '/SNR_Average_Thres800_Mask.dscalar.nii']);

% save the SNR mask to .mat file for future use
% 0: medial wall and low SNR regions
SNR_Mask_lh = SNR_Average_lh;
SNR_Mask_rh = SNR_Average_rh;
save([DataFolder '/SNR_Mask/subjects/fsaverage5/SNR_Mask.mat'], 'SNR_Mask_lh', 'SNR_Mask_rh');

% Convert the gifti file to .mgh file
cmd = ['mri_convert ' FS_Avg_Folder '/SNR_Average_Thres800_Mask_lh.func.gii ' ...
       FS_Avg_Folder '/SNR_Average_Thres800_Mask_lh.mgh'];
system(cmd);
cmd = ['mri_convert ' FS_Avg_Folder '/SNR_Average_Thres800_Mask_rh.func.gii ' ...
       FS_Avg_Folder '/SNR_Average_Thres800_Mask_rh.mgh'];
system(cmd);

% Write into FreeSurfer label file
SubjectsFolder = '/share/apps/freesurfer/6.0.0/subjects';
% for surface data
surfL = [SubjectsFolder '/fsaverage5/surf/lh.pial'];
[vx_L, ~] = read_surf(surfL);
surfR = [SubjectsFolder '/fsaverage5/surf/rh.pial'];
[vx_R, ~] = read_surf(surfR);
Mask_L = [DataFolder '/SNR_Mask/subjects/fsaverage5/lh.Mask_SNR.label'];
Mask_R = [DataFolder '/SNR_Mask/subjects/fsaverage5/rh.Mask_SNR.label'];
surfML = [SubjectsFolder '/fsaverage5/label/lh.Medial_wall.label'];
MW_L = read_label([], surfML);
surfMR = [SubjectsFolder '/fsaverage5/label/rh.Medial_wall.label'];
MW_R = read_label([], surfMR);

RemoveIndex_L = find(~SNR_Average_lh);
RemoveIndex_R = find(~SNR_Average_rh);
xyz_Coor_L = vx_L(RemoveIndex_L, :);
xyz_Coor_R = vx_R(RemoveIndex_R, :);
RemoveIndex_L = RemoveIndex_L - 1;
RemoveIndex_R = RemoveIndex_R - 1;
write_label(RemoveIndex_L, xyz_Coor_L, zeros(length(RemoveIndex_L), 1), Mask_L);
write_label(RemoveIndex_R, xyz_Coor_R, zeros(length(RemoveIndex_R), 1), Mask_R);

% Remove low SNR regions in the lh.cortex.label file
surf_Cortex_L_File = [SubjectsFolder '/fsaverage5/label/lh.cortex.label'];
surf_L = read_label([], surf_Cortex_L_File);
surf_Cortex_R_File = [SubjectsFolder '/fsaverage5/label/rh.cortex.label'];
surf_R = read_label([], surf_Cortex_R_File);
surf_Cortex_L_File_SNR = [DataFolder '/SNR_Mask/subjects/fsaverage5/lh.cortex_SNR.label'];
surf_Cortex_R_File_SNR = [DataFolder '/SNR_Mask/subjects/fsaverage5/rh.cortex_SNR.label'];

LowSNR_Index_L = intersect(RemoveIndex_L, surf_L(:, 1));
[~, ind] = ismember(LowSNR_Index_L, surf_L(:, 1));
surf_L(ind, :) = [];
LowSNR_Index_R = intersect(RemoveIndex_R, surf_R(:, 1));
[~, ind] = ismember(LowSNR_Index_R, surf_R(:, 1));
surf_R(ind, :) = [];

write_label(surf_L(:, 1), surf_L(:, 2:4), surf_L(:, end), surf_Cortex_L_File_SNR);
write_label(surf_R(:, 1), surf_R(:, 2:4), surf_R(:, end), surf_Cortex_R_File_SNR);

