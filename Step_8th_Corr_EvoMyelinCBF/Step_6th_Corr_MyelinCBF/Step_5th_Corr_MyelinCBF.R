
library(R.matlab)
library(ggplot2)
library(hexbin)

Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Corr_EvoMyelinCBF/BetweenCorr_MyelinCBF';
Data_Mat = readMat(paste0(Folder, '/AllData.mat'));

# Significance
# Myelin vs. mean CBF
Index = which(Data_Mat$Myelin.All.NoMedialWall >= 1 & Data_Mat$MeanCBF.All.NoMedialWall >= 30);
tmp_data = cor.test(as.numeric(Data_Mat$Myelin.All.NoMedialWall[Index]),
                    as.numeric(Data_Mat$MeanCBF.All.NoMedialWall[Index]), method = "pearson");
Actual_Corr_MyelinCBF = tmp_data$estimate;
Perm_Corr_MyelinCBF = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  Index = which(Data_Mat$Myelin.Perm.All.NoMedialWall[i,] >= 1 & Data_Mat$MeanCBF.All.NoMedialWall >= 30);
  Myelin_tmp = as.numeric(Data_Mat$Myelin.Perm.All.NoMedialWall[i,Index]);
  MeanCBF_tmp = as.numeric(Data_Mat$MeanCBF.All.NoMedialWall[Index]);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Myelin_tmp != 100);
  tmp_data = cor.test(Myelin_tmp[Non100_Index], MeanCBF_tmp[Non100_Index], method = "pearson");
  Perm_Corr_MyelinCBF[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_MyelinCBF <= Actual_Corr_MyelinCBF)) / 1000;
print(paste0('P value (myelin vs. mean CBF): ', as.character(P_Value)));

# Myelin vs. evo
Index = which(Data_Mat$Myelin.rh.NoMedialWall >= 1);
tmp_data = cor.test(as.numeric(Data_Mat$Myelin.rh.NoMedialWall[Index]),
                    as.numeric(Data_Mat$Evo.rh.NoMedialWall[Index]), method = "pearson");
Actual_Corr_EvoMyelin = tmp_data$estimate;
Perm_Corr_EvoMyelin = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  Index = which(Data_Mat$Myelin.Perm.rh.NoMedialWall[i,] >= 1);
  Myelin_tmp = as.numeric(Data_Mat$Myelin.Perm.rh.NoMedialWall[i,Index]);
  Evo_tmp = as.numeric(Data_Mat$Evo.rh.NoMedialWall[Index]);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Myelin_tmp != 100);
  tmp_data = cor.test(Myelin_tmp[Non100_Index], Evo_tmp[Non100_Index], method = "pearson");
  Perm_Corr_EvoMyelin[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_EvoMyelin <= Actual_Corr_EvoMyelin)) / 1000;
print(paste0('P value (evo vs. myelin): ', as.character(P_Value)));

# Mean CBF vs. evo
Index = which(Data_Mat$MeanCBF.rh.NoMedialWall >= 30);
tmp_data = cor.test(as.numeric(Data_Mat$MeanCBF.rh.NoMedialWall[Index]),
                    as.numeric(Data_Mat$Evo.rh.NoMedialWall[Index]), method = "pearson");
Actual_Corr_EvoMeanCBF = tmp_data$estimate;
Perm_Corr_EvoMeanCBF = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  Index = which(Data_Mat$MeanCBF.Perm.rh.NoMedialWall[i,] >= 30);
  MeanCBF_tmp = as.numeric(Data_Mat$MeanCBF.Perm.rh.NoMedialWall[i,Index]);
  Evo_tmp = as.numeric(Data_Mat$Evo.rh.NoMedialWall[Index]);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(MeanCBF_tmp != 100);
  tmp_data = cor.test(MeanCBF_tmp[Non100_Index], Evo_tmp[Non100_Index], method = "pearson");
  Perm_Corr_EvoMeanCBF[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_EvoMeanCBF >= Actual_Corr_EvoMeanCBF)) / 1000;
print(paste0('P value (evo vs. mean CBF): ', as.character(P_Value)));

