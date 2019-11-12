
library(R.matlab)
library(ggplot2)
library(hexbin)

Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Corr_EvoMyelinCBF';
Data_Mat = readMat(paste0(Folder, '/AllData.mat'));

myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
# EF prediction weights vs. Evolutionary expansion
Data_tmp1 = data.frame(EFPredictionWeights_rh_NoMedialWall = as.numeric(Data_Mat$CognitionWeights.rh.NoMedialWall.RandomCV));
Data_tmp1$Evo_rh_NoMedialWall = as.numeric(Data_Mat$Evo.rh.NoMedialWall);
cor.test(Data_tmp1$EFPredictionWeights_rh_NoMedialWall, Data_tmp1$Evo_rh_NoMedialWall, method = "pearson")

hexinfo <- hexbin(Data_tmp1$Evo_rh_NoMedialWall, Data_tmp1$EFPredictionWeights_rh_NoMedialWall, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
    #geom_hex(data = data_hex, aes(x, y, fill = count), stat = "identity") +
    geom_hex(data = subset(data_hex, count > 10), aes(x, y, fill = count), stat = "identity") +
    scale_fill_gradientn(colours = myPalette, breaks = c(50, 100)) + 
    geom_smooth(data = Data_tmp1, aes(x = Evo_rh_NoMedialWall, y = EFPredictionWeights_rh_NoMedialWall), method = lm, color = "#FFFFFF", linetype = "dashed") +
    theme_classic() + labs(x = "Evolutionary Expansion", y = "EF Contribution Weight") + 
    theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
    theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
    theme(legend.justification = c(1, 1), legend.position = c(1.02, 1)) +
    scale_x_continuous(limits = c(-2.2, 3.0), breaks = c(-2, -1, 0, 1, 2, 3)) + 
    scale_y_continuous(limits = c(-0.000001, 0.053), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFPredictionWeights_Evo.pdf', width = 17, height = 15, dpi = 600, units = "cm");
# EF prediction weights vs. Myelin
Data_tmp3 = data.frame(EFPredictionWeights_All_NoMedialWall = as.numeric(Data_Mat$EFWeights.All.NoMedialWall.RandomCV));
Data_tmp3$Myelin_All_NoMedialWall = as.numeric(Data_Mat$Myelin.All.NoMedialWall);
cor.test(Data_tmp3$EFPredictionWeights_All_NoMedialWall, Data_tmp3$Myelin_All_NoMedialWall, method = "pearson");
ggplot(data = Data_tmp3, aes(Myelin_All_NoMedialWall, EFPredictionWeights_All_NoMedialWall)) +
    geom_point() +
    geom_smooth(method = lm) +
    theme_classic() + labs(x = "Myelin Content", y = "Contribution Weight") +
    theme(axis.text=element_text(size=25, color='black'), axis.title=element_text(size=30)) +
    scale_fill_manual("", values = "grey12");
# EF prediction weights vs. Myelin(from the figure above, we found several points drives the correlation, restricting with Myelin>=1)
Index = which(Data_Mat$Myelin.All.NoMedialWall >= 1);
Data_tmp4 = data.frame(EFPredictionWeights_All_NoMedialWall = as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall.RandomCV[Index]));
Data_tmp4$Myelin_All_NoMedialWall = as.numeric(Data_Mat$Myelin.All.NoMedialWall[Index]);
cor.test(Data_tmp4$EFPredictionWeights_All_NoMedialWall, Data_tmp4$Myelin_All_NoMedialWall, method = "pearson");

hexinfo <- hexbin(Data_tmp4$Myelin_All_NoMedialWall, Data_tmp4$EFPredictionWeights_All_NoMedialWall, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
    geom_hex(data = subset(data_hex, count > 10), aes(x, y, fill = count), stat = "identity") +
    scale_fill_gradientn(colours = myPalette, breaks = c(75, 150)) +
    geom_smooth(data = Data_tmp4, aes(x = Myelin_All_NoMedialWall, y = EFPredictionWeights_All_NoMedialWall), method = lm, color = "#FFFFFF", linetype = "dashed") +
    theme_classic() + labs(x = "Myelin Content", y = "EF Contribution Weight") +
    theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
    theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
    theme(legend.justification = c(1, 1), legend.position = c(1.02, 1)) +
    scale_x_continuous(limits = c(0.98, 2.0), breaks = c(1.0, 1.4, 1.8)) +
    scale_y_continuous(limits = c(-0.000001, 0.043), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFPredictionWeights_Myelin.pdf', width = 17, height = 15, dpi = 600, units = "cm");
# EF prediction weights vs. Mean CBF
Data_tmp7 = data.frame(EFPredictionWeights_All_NoMedialWall = as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall.RandomCV));
Data_tmp7$MeanCBF_All_NoMedialWall = as.numeric(Data_Mat$MeanCBF.All.NoMedialWall);
cor.test(Data_tmp7$EFPredictionWeights_All_NoMedialWall, Data_tmp7$MeanCBF_All_NoMedialWall, method = "pearson");
ggplot(data = Data_tmp7, aes(MeanCBF_All_NoMedialWall, EFPredictionWeights_All_NoMedialWall)) +
    geom_point() +
    geom_smooth(method = lm) +
    theme_classic() + labs(x = "Mean CBF", y = "Contribution Weight") +
    theme(axis.text=element_text(size=25, color='black'), axis.title=element_text(size=30)) +
    scale_fill_manual("", values = "grey12");
# EF prediction weights vs. Mean CBF
Index = which(Data_Mat$MeanCBF.All.NoMedialWall >= 30);
Data_tmp8 = data.frame(EFPredictionWeights_All_NoMedialWall = as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall.RandomCV[Index]));
Data_tmp8$MeanCBF_All_NoMedialWall = as.numeric(Data_Mat$MeanCBF.All.NoMedialWall[Index]);
cor.test(Data_tmp8$EFPredictionWeights_All_NoMedialWall, Data_tmp8$MeanCBF_All_NoMedialWall, method = "pearson");

hexinfo <- hexbin(Data_tmp8$MeanCBF_All_NoMedialWall, Data_tmp8$EFPredictionWeights_All_NoMedialWall, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
    geom_hex(data = subset(data_hex, count > 10), aes(x, y, fill = count), stat = "identity") +
    scale_fill_gradientn(colours = myPalette, breaks = c(75, 150)) +
    geom_smooth(data = Data_tmp8, aes(x = MeanCBF_All_NoMedialWall, y = EFPredictionWeights_All_NoMedialWall), method = lm, color = "#FFFFFF", linetype = "dashed") +
    theme_classic() + labs(x = "Mean CBF", y = "EF Contribution Weight") +
    theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
    theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
    theme(legend.justification = c(1, 1), legend.position = c(1.02, 1.02)) +
    scale_x_continuous(limits = c(30, 90), breaks = c(40, 60, 80)) +
    scale_y_continuous(limits = c(-0.000001, 0.053), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFPredictionWeights_MeanCBF.pdf', width = 17, height = 15, dpi = 600, units = "cm");

# Significance
# EF prediction weights vs. evolutionary expansion
tmp_data = cor.test(as.numeric(Data_Mat$CognitionWeights.rh.NoMedialWall.RandomCV), 
                    as.numeric(Data_Mat$Evo.rh.NoMedialWall), method = "pearson");
Actual_Corr_Evo = tmp_data$estimate;
Perm_Corr_Evo = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Data_Mat$CognitionWeights.RandomCV.Perm.rh.NoMedialWall[i,] != 100); 
  tmp_data = cor.test(as.numeric(Data_Mat$CognitionWeights.RandomCV.Perm.rh.NoMedialWall[i, Non100_Index]),
                      as.numeric(Data_Mat$Evo.rh.NoMedialWall[Non100_Index]), method = "pearson");
  Perm_Corr_Evo[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_Evo >= Actual_Corr_Evo)) / 1000;
print(paste0('P value (EF prediction weight vs. evo): ', as.character(P_Value)));
  # Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_Evo));
PermutationData$Line_x = as.numeric(matrix(Actual_Corr_Evo, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,140,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.5, 0.5), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/SpinTestDensity_EFWeights_Evo.pdf', width = 17, height = 15, dpi = 600, units = "cm");

# EF prediction weights vs. myelin
Index = which(Data_Mat$Myelin.All.NoMedialWall >= 1);
tmp_data = cor.test(as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall.RandomCV[Index]),
                    as.numeric(Data_Mat$Myelin.All.NoMedialWall[Index]), method = "pearson");
Actual_Corr_Myelin = tmp_data$estimate;
Perm_Corr_Myelin = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  CognitionWeights_tmp = as.numeric(Data_Mat$CognitionWeights.RandomCV.Perm.All.NoMedialWall[i,Index]);
  Myelin_tmp = as.numeric(Data_Mat$Myelin.All.NoMedialWall[Index]);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(CognitionWeights_tmp != 100);
  tmp_data = cor.test(CognitionWeights_tmp[Non100_Index], Myelin_tmp[Non100_Index], method = "pearson");
  Perm_Corr_Myelin[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_Myelin <= Actual_Corr_Myelin)) / 1000;
print(paste0('P value (EF prediction weight vs. myelin): ', as.character(P_Value)));
  # Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_Myelin));
PermutationData$Line_x = as.numeric(matrix(Actual_Corr_Myelin, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,158,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.5, 0.5), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/SpinTestDensity_EFWeights_Myelin.pdf', width = 17, height = 15, dpi = 600, units = "cm");

# EF prediction weights vs MeanCBF
Index = which(Data_Mat$MeanCBF.All.NoMedialWall >= 30);
tmp_data = cor.test(as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall.RandomCV[Index]),
                    as.numeric(Data_Mat$MeanCBF.All.NoMedialWall[Index]), method = "pearson");
Actual_Corr_CBF = tmp_data$estimate;
Perm_Corr_CBF = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i)
  CognitionWeights_tmp = as.numeric(Data_Mat$CognitionWeights.RandomCV.Perm.All.NoMedialWall[i,Index]);
  MeanCBF_tmp = as.numeric(Data_Mat$MeanCBF.All.NoMedialWall[Index]);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(CognitionWeights_tmp != 100);
  tmp_data = cor.test(CognitionWeights_tmp[Non100_Index], MeanCBF_tmp[Non100_Index], method = "pearson");
  Perm_Corr_CBF[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_CBF >= Actual_Corr_CBF)) / 1000;
print(paste0('P value (EF prediction weight vs. mean CBF): ', as.character(P_Value)));
  # Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_CBF));
PermutationData$Line_x = as.numeric(matrix(Actual_Corr_CBF, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,165,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.5, 0.5), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/SpinTestDensity_EFWeights_MeanCBF.pdf', width = 17, height = 15, dpi = 600, units = "cm");

