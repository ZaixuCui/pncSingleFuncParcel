
function CZ_Merge3Modality_FS(RSFolder, NBackFolder, IdEmotionFolder, BBLID, ResultantFolder)

ResultantFolder = [ResultantFolder '/' num2str(BBLID)];
if ~exist(ResultantFolder, 'dir')
    mkdir(ResultantFolder);
end

hemi = {'lh', 'rh'};
for i = 1:2
    RSFile = [RSFolder '/' num2str(BBLID) '/surf/' hemi{i} '.fs5.sm6.residualised.mgh'];
    NBackFile = [NBackFolder '/' num2str(BBLID) '/surf/' hemi{i} '.fs5.sm6.residualised.mgh'];
    IdEmotionFile = [IdEmotionFolder '/' num2str(BBLID) '/surf/' hemi{i} '.fs5.sm6.residualised.mgh'];
    ResultantFile = [ResultantFolder '/' hemi{i} '.fs5.sm6.residualised.mgh'];
    cmd = ['mri_concat --i ' RSFile ' --i ' NBackFile ' --i ' IdEmotionFile ' --o ' ResultantFile];
    system(cmd);
end
