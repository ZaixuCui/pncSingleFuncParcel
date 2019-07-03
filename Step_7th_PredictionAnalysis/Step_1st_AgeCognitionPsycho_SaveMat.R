
library(R.matlab);

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
###############################################
# Import demographics, cognition and strength #
###############################################
# Demographics, motion
AllInfo <- read.csv(paste0(ReplicationFolder, '/data/n693_Behavior_20181219.csv'));
BBLID <- AllInfo$bblid;
AgeYears <- AllInfo$ageAtScan1/12;
Sex <- AllInfo$sex;
Motion_Rest <- AllInfo$restRelMeanRMSMotion;
Motion_NBack <- AllInfo$nbackRelMeanRMSMotion;
Motion_Emotion <- AllInfo$idemoRelMeanRMSMotion;
Motion <- (Motion_Rest + Motion_NBack + Motion_Emotion)/3;
F1_Exec_Comp_Res_Accuracy <- AllInfo$F1_Exec_Comp_Res_Accuracy;
F3_Memory_Accuracy <- AllInfo$F3_Memory_Accuracy;
F2_Social_Cog_Accuracy <- AllInfo$F2_Social_Cog_Accuracy;
F1_Slow_Speed <- AllInfo$F1_Slow_Speed;
F2_Fast_Speed <- AllInfo$F2_Fast_Speed;
Overall_Speed <- AllInfo$Overall_Speed;
F3_Memory_Speed <- AllInfo$F3_Memory_Speed;

dir.create(paste0(ReplicationFolder, '/results/PredictionAnalysis'));
writeMat(paste0(ReplicationFolder, '/results/PredictionAnalysis/Behavior_693.mat'), 
    BBLID = BBLID, AgeYears = AgeYears, Sex = Sex, Motion = Motion,
    F1_Exec_Comp_Res_Accuracy = F1_Exec_Comp_Res_Accuracy, F3_Memory_Accuracy = F3_Memory_Accuracy, F2_Social_Cog_Accuracy = F2_Social_Cog_Accuracy, F1_Slow_Speed = F1_Slow_Speed, F2_Fast_Speed = F2_Fast_Speed, Overall_Speed = Overall_Speed, F3_Memory_Speed = F3_Memory_Speed);

