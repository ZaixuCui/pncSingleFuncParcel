
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ParcellationFolder = paste0(ReplicationFolder, '/results/SingleParcellation/SingleAtlas_Analysis');
GroupLoading_File = paste0(ParcellationFolder, '/Group_AtlasLoading.mat');
GroupLoading_Data = readMat(GroupLoading_File);

ResultantFolder = paste0(ParcellationFolder, '/Group_AtlasLoading_SpinPermutateData');
dir.create(ResultantFolder);
InputFolder = paste0(ResultantFolder, '/Input');
dir.create(InputFolder);
for (i in c(1:17))
{
  print(i);
  AtlasLoading_lh_Data = data.frame(Loading_lh = as.matrix(GroupLoading_Data$sbj.AtlasLoading.lh[i, ]));
  AtlasLoading_lh_CSV = paste0(InputFolder, '/AtlasLoading_lh_Network_', as.character(i), '.csv');
  write.table(AtlasLoading_lh_Data, AtlasLoading_lh_CSV, row.names = FALSE, col.names = FALSE);
  AtlasLoading_rh_Data = data.frame(Loading_rh = as.matrix(GroupLoading_Data$sbj.AtlasLoading.rh[i, ]));
  AtlasLoading_rh_CSV = paste0(InputFolder, '/AtlasLoading_rh_Network_', as.character(i), '.csv');
  write.table(AtlasLoading_rh_Data, AtlasLoading_rh_CSV, row.names = FALSE, col.names = FALSE);
}
