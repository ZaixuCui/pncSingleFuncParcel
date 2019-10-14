
clear

WorkingFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
system(['rm -rf ' WorkingFolder '/*']);
DataListFolder = [WorkingFolder '/data_list'];
fMRIListFolder = [DataListFolder '/fMRI_list'];
censorListFolder = [DataListFolder '/censor_list'];
mkdir(fMRIListFolder);
mkdir(censorListFolder);

DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
RestingFolder = [DataFolder '/RestingState_SNRMask'];
nbackFolder = [DataFolder '/NBack_SNRMask'];
EmoIdenFolder = [DataFolder '/EmotionIden_SNRMask'];

hemi = {'lh', 'rh'};
for i = 1:length(BBLID)
    i
    ID_Str = num2str(BBLID(i));
    for j = 1:2
        % session 1, resting state
        FilePath = [fMRIListFolder '/' hemi{j} '_sub' ID_Str '_sess1.txt'];
        cmd = ['echo ' RestingFolder '/' ID_Str '/' hemi{j} '.fs5.sm6.residualised.nii.gz >> ' FilePath];
        system(cmd);
        % session 2, nback
        FilePath = [fMRIListFolder '/' hemi{j} '_sub' ID_Str '_sess2.txt'];
        cmd = ['echo ' nbackFolder '/' ID_Str '/' hemi{j} '.fs5.sm6.residualised.nii.gz >> ' FilePath];
        system(cmd);
        % session 3, emotion identification
        FilePath = [fMRIListFolder '/' hemi{j} '_sub' ID_Str '_sess3.txt'];
        cmd = ['echo ' EmoIdenFolder '/' ID_Str '/' hemi{j} '.fs5.sm6.residualised.nii.gz >> ' FilePath];
        system(cmd);
    end
end

