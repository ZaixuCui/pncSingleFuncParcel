
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
WorkingFolder = [ReplicationFolder '/Revision/SingleParcellation_Kong/WorkingFolder'];
Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);

mesh = 'fsaverage5';
num_sess = '3';
num_clusters = '17';
w = '200';
c = '30';

ResultantFolder = [WorkingFolder '/ind_parcellation_200_30'];
mkdir(ResultantFolder);
for i = 1:length(BBLID)
  disp(i);
  subid = num2str(i);
  [lh_labels, rh_labels] = CBIG_MSHBM_generate_individual_parcellation(WorkingFolder, mesh, num_sess, num_clusters, subid, w, c);
  save([ResultantFolder '/' num2str(BBLID(i)) '.mat'], 'lh_labels', 'rh_labels');
end

