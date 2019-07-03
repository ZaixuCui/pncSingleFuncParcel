
library(R.matlab)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/results');
ID_CSV = read.csv(paste0(ReplicationFolder, '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'));
BBLID = ID_CSV$bblid;
################
## For Hongming atlas
################
AtlasLabelFolder = paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLabel');
SpinTest_Folder = paste0(ResultsFolder, '/Atlas_Homogeneity_Reliability/PermuteData_SpinTest/Input');
dir.create(SpinTest_Folder, recursive = TRUE);
for (i in c(1:length(BBLID)))
{
  print(i);
  AtlasLabel_File <- paste0(AtlasLabelFolder, '/', as.character(BBLID[i]), '.mat');
  AtlasLabel_Data <- readMat(AtlasLabel_File);

  AtlasLabel_lh_Data = data.frame(Label_lh = t(AtlasLabel_Data$sbj.AtlasLabel.lh));
  AtlasLabel_lh_CSV = paste0(SpinTest_Folder, '/AtlasLabel_lh_', as.character(BBLID[i]), '.csv');
  write.table(AtlasLabel_lh_Data, AtlasLabel_lh_CSV, row.names = FALSE, col.names = FALSE);
  AtlasLabel_rh_Data = data.frame(Label_rh = t(AtlasLabel_Data$sbj.AtlasLabel.rh));
  AtlasLabel_rh_CSV = paste0(SpinTest_Folder, '/AtlasLabel_rh_', as.character(BBLID[i]), '.csv');
  write.table(AtlasLabel_rh_Data, AtlasLabel_rh_CSV, row.names = FALSE, col.names = FALSE);
}

# For group data
AtlasLabel_File <- paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat');
AtlasLabel_Data <- readMat(AtlasLabel_File);
AtlasLabel_lh_Data = data.frame(Label_lh = t(AtlasLabel_Data$sbj.AtlasLabel.lh));
AtlasLabel_lh_CSV = paste0(SpinTest_Folder, '/GroupAtlasLabel_lh.csv');
write.table(AtlasLabel_lh_Data, AtlasLabel_lh_CSV, row.names = FALSE, col.names = FALSE);
AtlasLabel_rh_Data = data.frame(Label_rh = t(AtlasLabel_Data$sbj.AtlasLabel.rh));
AtlasLabel_rh_CSV = paste0(SpinTest_Folder, '/GroupAtlasLabel_rh.csv');
write.table(AtlasLabel_rh_Data, AtlasLabel_rh_CSV, row.names = FALSE, col.names = FALSE);

