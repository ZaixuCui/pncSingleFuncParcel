
library('R.matlab');
library('mgcv');

ProjectFolder <- '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
Behavior <- read.csv(paste0(ProjectFolder, '/data/n693_Behavior_20181219.csv'));
Behavior_New <- data.frame(BBLID = Behavior$bblid);
Behavior_New$AgeYears <- as.numeric(Behavior$ageAtScan1/12);
Motion <- (Behavior$restRelMeanRMSMotion + Behavior$nbackRelMeanRMSMotion + Behavior$idemoRelMeanRMSMotion)/3;
Behavior_New$Motion <- as.numeric(Motion);
Behavior_New$Sex_factor <- as.factor(Behavior$sex);
Behavior_New$F1_Exec_Comp_Res_Accuracy <- as.numeric(Behavior$F1_Exec_Comp_Res_Accuracy);
AtlasLoading_Folder <- paste0(ProjectFolder, '/Revision/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLoading');

SubjectsQuantity = 693;
FeaturesQuantity = 17734;
# Extract Loading
Data_Size <- SubjectsQuantity * FeaturesQuantity * 17;
Data_All <- matrix(0, 1, Data_Size);
dim(Data_All) <- c(SubjectsQuantity, FeaturesQuantity, 17);
BBLID <- Behavior_New$BBLID;
for (i in c(1:length(BBLID)))
{
  print(i);
  AtlasLoading_File <- paste0(AtlasLoading_Folder, '/', as.character(BBLID[i]), '.mat');
  Data <- readMat(AtlasLoading_File);
  Data_All[i,,] <- Data$sbj.AtlasLoading.NoMedialWall;
}

for (i in 1:17)
{
  Data_I = Data_All[,,i];
  ColumnSum = colSums(Data_I);
  NonZero_ColumnIndex = which(ColumnSum != 0);
  Data_I_NonZero = Data_I[, NonZero_ColumnIndex];
  FeaturesQuantity_NonZero = dim(Data_I_NonZero)[2];
  
  # Age effect
  Gam_P_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  Gam_Z_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  Gam_P_FDR_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  Gam_P_Bonf_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  for (j in 1:FeaturesQuantity_NonZero)
  {
    print(j)
    Loading_Data <- as.numeric(Data_I_NonZero[,j]);
    Gam_Analysis <- gam(Loading_Data ~ s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
    Gam_P_Vector[j] <- summary(Gam_Analysis)$s.table[, 4];
    Gam_Z_Vector[j] <- qnorm(Gam_P_Vector[j] / 2, lower.tail = FALSE);
    lm_Analysis <- lm(Loading_Data ~ AgeYears + Sex_factor + Motion, data = Behavior_New);
    Age_T <- summary(lm_Analysis)$coefficients[2, 3];
    if (Age_T < 0) {
      Gam_Z_Vector[j] <- -Gam_Z_Vector[j];
    }
  }
  # FDR correction
  Gam_P_FDR_Vector <- p.adjust(Gam_P_Vector, "fdr");
  Gam_Z_FDR_Sig_Vector = Gam_Z_Vector;
  Gam_Z_FDR_Sig_Vector[which(Gam_P_FDR_Vector >= 0.05)] = 0;
  Gam_P_Bonf_Vector <- p.adjust(Gam_P_Vector, "bonferroni");
  Gam_Z_Bonf_Sig_Vector = Gam_Z_Vector;
  Gam_Z_Bonf_Sig_Vector[which(Gam_P_Bonf_Vector >= 0.05)] = 0;
  # Write results back
  Gam_P_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_P_Vector_All[NonZero_ColumnIndex] <- Gam_P_Vector;
  Gam_Z_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_Z_Vector_All[NonZero_ColumnIndex] <- Gam_Z_Vector;
  Gam_P_FDR_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_P_FDR_Vector_All[NonZero_ColumnIndex] <- Gam_P_FDR_Vector;
  Gam_Z_FDR_Sig_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_Z_FDR_Sig_Vector_All[NonZero_ColumnIndex] <- Gam_Z_FDR_Sig_Vector;
  Gam_P_Bonf_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_P_Bonf_Vector_All[NonZero_ColumnIndex] <- Gam_P_Bonf_Vector;
  Gam_Z_Bonf_Sig_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_Z_Bonf_Sig_Vector_All[NonZero_ColumnIndex] <- Gam_Z_Bonf_Sig_Vector;
  ResultantFolder = paste0(ProjectFolder, '/Revision/GamAnalysis/AtlasLoading/AgeEffects');
  dir.create(ResultantFolder, recursive = TRUE);
  writeMat(paste0(ResultantFolder, '/AgeEffect_AtlasLoading_17_Network_', as.character(i), '.mat'), Gam_P_Vector_All = Gam_P_Vector_All, Gam_Z_Vector_All = Gam_Z_Vector_All, Gam_P_FDR_Vector_All = Gam_P_FDR_Vector_All, Gam_Z_FDR_Sig_Vector_All = Gam_Z_FDR_Sig_Vector_All, Gam_P_Bonf_Vector_All = Gam_P_Bonf_Vector_All, Gam_Z_Bonf_Sig_Vector_All = Gam_Z_Bonf_Sig_Vector_All);

  # Cognition effect
  Gam_P_Cognition_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  Gam_Z_Cognition_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  Gam_P_FDR_Cognition_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  Gam_P_Bonf_Cognition_Vector <- matrix(0, 1, FeaturesQuantity_NonZero);
  for (j in 1:FeaturesQuantity_NonZero)
  {   
    print(j)
    Loading_Data <- as.numeric(Data_I_NonZero[,j]);
    Gam_Analysis_Cognition <- gam(Loading_Data ~ F1_Exec_Comp_Res_Accuracy + s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
    Gam_Z_Cognition_Vector[j] <- summary(Gam_Analysis_Cognition)$p.table[2, 3];
    Gam_P_Cognition_Vector[j] <- summary(Gam_Analysis_Cognition)$p.table[2, 4];
  }
  Gam_P_FDR_Cognition_Vector <- p.adjust(Gam_P_Cognition_Vector, "fdr");
  Gam_Z_FDR_Sig_Cognition_Vector = Gam_Z_Cognition_Vector;
  Gam_Z_FDR_Sig_Cognition_Vector[which(Gam_P_FDR_Cognition_Vector >= 0.05)] = 0;
  Gam_P_Bonf_Cognition_Vector <- p.adjust(Gam_P_Cognition_Vector, "bonferroni");
  Gam_Z_Bonf_Sig_Cognition_Vector = Gam_Z_Cognition_Vector;
  Gam_Z_Bonf_Sig_Cognition_Vector[which(Gam_P_Bonf_Cognition_Vector >= 0.05)] = 0;
  # Write results back
  Gam_P_Cognition_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_P_Cognition_Vector_All[NonZero_ColumnIndex] <- Gam_P_Cognition_Vector;
  Gam_Z_Cognition_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_Z_Cognition_Vector_All[NonZero_ColumnIndex] <- Gam_Z_Cognition_Vector;
  Gam_P_FDR_Cognition_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_P_FDR_Cognition_Vector_All[NonZero_ColumnIndex] <- Gam_P_FDR_Cognition_Vector;
  Gam_Z_FDR_Sig_Cognition_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_Z_FDR_Sig_Cognition_Vector_All[NonZero_ColumnIndex] <- Gam_Z_FDR_Sig_Cognition_Vector;
  Gam_P_Bonf_Cognition_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_P_Bonf_Cognition_Vector_All[NonZero_ColumnIndex] <- Gam_P_Bonf_Cognition_Vector;
  Gam_Z_Bonf_Sig_Cognition_Vector_All <- matrix(0, 1, FeaturesQuantity);
  Gam_Z_Bonf_Sig_Cognition_Vector_All[NonZero_ColumnIndex] <- Gam_Z_Bonf_Sig_Cognition_Vector;
  ResultantFolder = paste0(ProjectFolder, '/Revision/GamAnalysis/AtlasLoading/CognitionEffects');
  dir.create(ResultantFolder, recursive = TRUE);
  writeMat(paste0(ResultantFolder, '/CognitionEffect_AtlasLoading_17_Network_', as.character(i), '.mat'), Gam_P_Cognition_Vector_All = Gam_P_Cognition_Vector_All, Gam_Z_Cognition_Vector_All = Gam_Z_Cognition_Vector_All, Gam_P_FDR_Cognition_Vector_All = Gam_P_FDR_Cognition_Vector_All, Gam_Z_FDR_Sig_Cognition_Vector_All = Gam_Z_FDR_Sig_Cognition_Vector_All, Gam_P_Bonf_Cognition_Vector_All = Gam_P_Bonf_Cognition_Vector_All, Gam_Z_Bonf_Sig_Cognition_Vector_All = Gam_Z_Bonf_Sig_Cognition_Vector_All);
}


