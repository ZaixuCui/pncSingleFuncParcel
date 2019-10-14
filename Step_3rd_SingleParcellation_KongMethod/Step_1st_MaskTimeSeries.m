
clear
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
ScanID = Demogra_Info(:, 2);
SNR_Mask_lh_Path = [DataFolder '/SNR_Mask/RawImage_FS_Smooth_Avg/SNR_Average_Thres800_Mask_lh.mgh'];
lh_SNR_Mask = MRIread(SNR_Mask_lh_Path);
lh_SNR_Mask = lh_SNR_Mask.vol;
lh_SNR_Mask(find(~lh_SNR_Mask)) = nan;
SNR_Mask_rh_Path = [DataFolder '/SNR_Mask/RawImage_FS_Smooth_Avg/SNR_Average_Thres800_Mask_rh.mgh'];
rh_SNR_Mask = MRIread(SNR_Mask_rh_Path);
rh_SNR_Mask = rh_SNR_Mask.vol;
rh_SNR_Mask(find(~rh_SNR_Mask)) = nan;

Modality = {'RestingState', 'NBack', 'EmotionIden'};
for i = 1:3
  Raw_Folder = [DataFolder '/' Modality{i}];
  OutputFolder = [DataFolder '/' Modality{i} '_SNRMask'];
  mkdir(OutputFolder);
  for j = 1:length(BBLID)
    j
    BBLID_Str = num2str(BBLID(j));
    lh_data = MRIread([Raw_Folder '/' BBLID_Str '/surf/lh.fs5.sm6.residualised.mgh']);
    lh_data_vol = lh_data.vol;
    rh_data = MRIread([Raw_Folder '/' BBLID_Str '/surf/rh.fs5.sm6.residualised.mgh']);
    rh_data_vol = rh_data.vol;
    [~, ~, ~, VolumeQuantity] = size(lh_data_vol);

    lh_data_vol = lh_data_vol .* repmat(lh_SNR_Mask, 1, 1, 1, VolumeQuantity);
    rh_data_vol = rh_data_vol .* repmat(rh_SNR_Mask, 1, 1, 1, VolumeQuantity);

    ResultantFolder = [OutputFolder '/' BBLID_Str];
    mkdir(ResultantFolder);
    save_mgh(lh_data_vol, [ResultantFolder '/lh.fs5.sm6.residualised.mgh'], ...
             lh_data.vox2ras, [lh_data.tr lh_data.flip_angle lh_data.te lh_data.ti]);
    save_mgh(rh_data_vol, [ResultantFolder '/rh.fs5.sm6.residualised.mgh'], ...
             rh_data.vox2ras, [rh_data.tr rh_data.flip_angle rh_data.te rh_data.ti]);

    CZ_CiftiWrite_dscalar(lh_data_vol(1,:,1,1)', rh_data_vol(1,:,1,1)', ...
             [ResultantFolder '/lh.fs5.sm6.residualised.func.gii'], ...
             [ResultantFolder '/rh.fs5.sm6.residualised.func.gii'], ...
             [ResultantFolder '/fs5.sm6.residualised.dscalar.nii']);
  end
end

