
library(R.matlab)

subjid_df <- read.csv("/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/pncSingleFuncParcel_n693_SubjectsIDs.csv");
#########################################
### 2. Extrating behavior information ###
#########################################  
demo <- subjid_df;
# Demographics 
Demographics_Data <- read.csv("/data/joy/BBL/studies/pnc/n1601_dataFreeze/demographics/n1601_demographics_go1_20161212.csv");
# Motion
Rest_Motion_Data <- read.csv("/data/joy/BBL/studies/pnc/n1601_dataFreeze/neuroimaging/rest/n1601_RestQAData_20170714.csv");
NBack_Motion_Data <- read.csv("/data/joy/BBL/studies/pnc/n1601_dataFreeze/neuroimaging/nback/nbackGlmBlockDesign/n1601_NBACKQAData_20181001.csv");
Idemo_Motion_Data <- read.csv("/data/joy/BBL/studies/pnc/n1601_dataFreeze/neuroimaging/idemo/n1601_idemo_FinalQA_092817.csv");
# Cognition
Cognition_Data <- read.csv("/data/joy/BBL/studies/pnc/n1601_dataFreeze/cnb/n1601_cnb_factor_scores_tymoore_20151006.csv");
# Merge all data
demo <- merge(demo, Demographics_Data, by = c("scanid", "bblid"));
demo <- merge(demo, Rest_Motion_Data, by = c("scanid", "bblid"));
demo <- merge(demo, NBack_Motion_Data, by = c("scanid", "bblid"));
demo <- merge(demo, Idemo_Motion_Data, by = c("scanid", "bblid"));
demo <- merge(demo, Cognition_Data, by = c("scanid", "bblid"));
# Output the subjects' behavior data
write.csv(demo, "/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/n693_Behavior_20181219.csv", row.names = FALSE);

# Save age in .mat file
BBLID = demo$bblid;
ScanID = demo$scanid;
Age = demo$ageAtScan1;
writeMat('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/Age_Info.mat', BBLID = BBLID, ScanID = ScanID, Age = Age);

