
clear
seed_mesh = 'fsaverage3';
targ_mesh = 'fsaverage5';
out_dir = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';

DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

for i = 1:length(BBLID)
    i
    sub = num2str(BBLID(i));
    for sess = 1:3
        CBIG_MSHBM_generate_profiles(seed_mesh, targ_mesh, out_dir, sub, num2str(sess), '0');
    end
end

