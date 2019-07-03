
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
WorkingFolder = [ReplicationFolder '/results/SingleParcellation_Kong/WorkingFolder'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

mesh = 'fsaverage5';
num_sess = '3';
num_clusters = '17';
w = '200';
c = '30';

ResultantFolder = [WorkingFolder '/ind_parcellation_200_30'];
for i = 601:length(BBLID)
    disp(i);
    subid = num2str(i);
    CZ_IndividualParcellation(WorkingFolder, BBLID(i), mesh, num_sess, num_clusters, subid, w, c, ResultantFolder);
end

