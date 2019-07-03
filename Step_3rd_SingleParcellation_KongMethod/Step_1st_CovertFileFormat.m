
clear
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
RestingStateFolder = [DataFolder '/RestingState'];
nbackFolder = [DataFolder '/NBack'];
EmoIdenFolder = [DataFolder '/EmotionIden'];

RestingStateFolder = g_ls([RestingStateFolder '/*/']);
nbackFolder = g_ls([nbackFolder '/*/']);
EmoIdenFolder = g_ls([EmoIdenFolder '/*/']);

hemi = {'lh', 'rh'};
for j = 1:2
  for i = 1:length(RestingStateFolder)
    i
    cmd = ['mri_convert ' RestingStateFolder{i} '/surf/' hemi{j} '.fs5.sm6.residualised.mgh ' RestingStateFolder{i} '/surf/' hemi{j} '.fs5.sm6.residualised.nii.gz'];
    system(cmd);
  end

  for i = 1:length(nbackFolder)
    cmd = ['mri_convert ' nbackFolder{i} '/surf/' hemi{j} '.fs5.sm6.residualised.mgh ' nbackFolder{i} '/surf/' hemi{j} '.fs5.sm6.residualised.nii.gz'];
    system(cmd);
  end

  for i = 1:length(EmoIdenFolder)
    cmd = ['mri_convert ' EmoIdenFolder{i} '/surf/' hemi{j} '.fs5.sm6.residualised.mgh ' EmoIdenFolder{i} '/surf/' hemi{j} '.fs5.sm6.residualised.nii.gz'];
    system(cmd);
  end
end

