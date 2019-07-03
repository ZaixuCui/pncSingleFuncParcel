
clear
% Prepare input
% project_dir/profile_list/training_set/lh_sess<?>.txt
% project_dir/profile_list/training_set/rh_sess<?>.txt
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
WorkingFolder = [ReplicationFolder '/results/SingleParcellation_Kong/WorkingFolder'];
testing_dir = [WorkingFolder '/profile_list/test_set'];
mkdir(testing_dir);
system(['rm ' testing_dir '/*']);

Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

hemi = {'lh', 'rh'};
Suffix = '_fsaverage5_roifsaverage3.surf2surf_profile.nii.gz';
for i = 1:length(BBLID)
    i
    ID_Str = num2str(BBLID(i));
    for j = 1:2
        % session 1
        cmd = ['echo ' WorkingFolder '/profiles/sub' ID_Str '/sess1/' hemi{j} '.sub' ID_Str '_sess1' Suffix ' >> ' testing_dir '/' hemi{j} '_sess1.txt'];
        system(cmd);
        % session 2
        cmd = ['echo ' WorkingFolder '/profiles/sub' ID_Str '/sess2/' hemi{j} '.sub' ID_Str '_sess2' Suffix ' >> ' testing_dir '/' hemi{j} '_sess2.txt'];
        system(cmd);
        % session 3
        cmd = ['echo ' WorkingFolder '/profiles/sub' ID_Str '/sess3/' hemi{j} '.sub' ID_Str '_sess3' Suffix ' >> ' testing_dir '/' hemi{j} '_sess3.txt'];
        system(cmd);
    end
end
