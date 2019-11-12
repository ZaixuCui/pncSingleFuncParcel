
clear
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
ScanID = Demogra_Info(:, 2);

RawDataFolder = '/data/joy/BBL/studies/pnc/rawData/';
RestingOutput = [DataFolder '/SNR_Mask/RawImage/RestingState'];
NBackOutput = [DataFolder '/SNR_Mask/RawImage/NBack'];
EmotionIdenOutput = [DataFolder '/SNR_Mask/RawImage/EmotionIden'];
% Step 1: Extract first signal data
for i = 1:length(BBLID)
  i
  BBLID_Str = num2str(BBLID(i));
  % Resting state
  Resting_Image = g_ls([RawDataFolder '/' num2str(BBLID(i)) '/*' num2str(ScanID(i)) ...
               '/*restbold1*/nifti/*.nii.gz']);
  cmd = ['fslroi ' Resting_Image{1} ' ' RestingOutput '/' BBLID_Str ' 4 1'];
  system(cmd);
  % NBack
  NBack_Image = g_ls([RawDataFolder '/' num2str(BBLID(i)) '/*' num2str(ScanID(i)) ...
               '/*frac2back1*/nifti/*.nii.gz']);
  cmd = ['fslroi ' NBack_Image{1} ' ' NBackOutput '/' BBLID_Str ' 6 1'];
  system(cmd);
  % Emotion identification
  Idemo_Image = g_ls([RawDataFolder '/' num2str(BBLID(i)) '/*' num2str(ScanID(i)) ...
               '/*idemo2*/nifti/*.nii.gz']);
  cmd = ['fslroi ' Idemo_Image{1} ' ' EmotionIdenOutput '/' BBLID_Str ' 0 1'];
  system(cmd);
end

