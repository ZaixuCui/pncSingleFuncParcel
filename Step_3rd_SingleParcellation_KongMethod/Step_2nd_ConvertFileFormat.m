
clear
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
RestingStateFolder = [DataFolder '/RestingState_SNRMask'];
nbackFolder = [DataFolder '/NBack_SNRMask'];
EmoIdenFolder = [DataFolder '/EmotionIden_SNRMask'];

RestingStateFolder = g_ls([RestingStateFolder '/*/']);
nbackFolder = g_ls([nbackFolder '/*/']);
EmoIdenFolder = g_ls([EmoIdenFolder '/*/']);

hemi = {'lh', 'rh'};
for j = 1:2
  for i = 1:length(RestingStateFolder)
    i
    cmd = ['mri_convert ' RestingStateFolder{i} '/' hemi{j} '.fs5.sm6.residualised.mgh ' RestingStateFolder{i} '/' hemi{j} '.fs5.sm6.residualised.nii.gz'];
    system(cmd);
  end

  for i = 1:length(nbackFolder)
    cmd = ['mri_convert ' nbackFolder{i} '/' hemi{j} '.fs5.sm6.residualised.mgh ' nbackFolder{i} '/' hemi{j} '.fs5.sm6.residualised.nii.gz'];
    system(cmd);
  end

  for i = 1:length(EmoIdenFolder)
    cmd = ['mri_convert ' EmoIdenFolder{i} '/' hemi{j} '.fs5.sm6.residualised.mgh ' EmoIdenFolder{i} '/' hemi{j} '.fs5.sm6.residualised.nii.gz'];
    system(cmd);
  end
end

