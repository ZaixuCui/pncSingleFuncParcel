
library(R.matlab)
library(ggplot2)
library(hexbin)

Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis/AtlasLabel_Kong/Corr_Variability_AgePredictionWeights';
Data_Mat = readMat(paste0(Folder, '/AllData.mat'));

# plot the highest correlation
myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
# Correlation between age prediction weights and atlas variability
data_Age = data.frame(Variability_Data = as.numeric(t(Data_Mat$VariabilityLabel.All.NoMedialWall)));
data_Age$AgeWeights_Mean = as.numeric(Data_Mat$AgeWeights.All.NoMedialWall);
ActualCorr <-cor.test(data_Age$AgeWeights_Mean, data_Age$Variability_Data, method = "pearson");

hexinfo <- hexbin(data_Age$Variability_Data, data_Age$AgeWeights_Mean, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
         geom_hex(data = subset(data_hex, count >= 10), aes(x, y, fill = count), stat = "identity") + 
         scale_fill_gradientn(colours = myPalette, breaks = c(300, 600)) +
         geom_smooth(data = data_Age, aes(x = Variability_Data, y = AgeWeights_Mean), method = lm, color = "#FFFFFF", linetype = "dashed") + 
         theme_classic() + labs(x = "Network Variability", y = "Contribution Weight") +
         theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
         theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) + 
         theme(legend.justification = c(1, 1), legend.position = c(1.02, 1.03)) +
         scale_x_continuous(limits = c(-0.000001, 3.2), breaks = c(0, 1, 2, 3)) + 
         scale_y_continuous(limits = c(-0.000001, 0.042), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/AgePredictionWeights_Variability_LabelAtlas_Kong.tiff', width = 17, height = 15, dpi = 600, units = "cm");
# Correlation between EF prediction weights and atlas variability
data_EF = data.frame(Variability_Data = as.numeric(t(Data_Mat$VariabilityLabel.All.NoMedialWall)));
data_EF$EFWeights_Mean = as.numeric(Data_Mat$EFWeights.All.NoMedialWall);
ActualCorr <-cor.test(data_EF$EFWeights_Mean, data_EF$Variability_Data, method = "pearson");

hexinfo <- hexbin(data_EF$Variability_Data, data_EF$EFWeights_Mean, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
         geom_hex(data = subset(data_hex, count >= 10), aes(x, y, fill = count), stat = "identity") +
         scale_fill_gradientn(colours = myPalette, breaks = c(300, 600)) +
         geom_smooth(data = data_EF, aes(x = Variability_Data, y = EFWeights_Mean), method = lm, color = "#FFFFFF", linetype = "dashed") +
         theme_classic() + labs(x = "Network Variability", y = "Contribution Weight") +
         theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
         theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
         theme(legend.justification = c(1, 1), legend.position = c(1.02, 1.03)) +
         scale_x_continuous(limits = c(-0.000001, 3.2), breaks = c(0, 1, 2, 3)) +
         scale_y_continuous(limits = c(-0.000001, 0.045), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFPredictionWeights_Variability_LabelAtlas_Kong.tiff', width = 17, height = 15, dpi = 600, units = "cm");


# Significance
# AgeWeights vs. variability
tmp_data = cor.test(as.numeric(Data_Mat$AgeWeights.All.NoMedialWall),
                    as.numeric(Data_Mat$VariabilityLabel.All.NoMedialWall), method = "pearson");
Actual_Corr_Variability_AgeWeights = tmp_data$estimate;
Perm_Corr_Variability_AgeWeights = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Data_Mat$VariabilityLabel.Perm.All.NoMedialWall[i,] != 100);
  tmp_data = cor.test(as.numeric(Data_Mat$AgeWeights.All.NoMedialWall[Non100_Index]),
                      as.numeric(Data_Mat$VariabilityLabel.Perm.All.NoMedialWall[i,Non100_Index]), method = "pearson");
  Perm_Corr_Variability_AgeWeights[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_Variability_AgeWeights >= Actual_Corr_Variability_AgeWeights)) / 1000;
print(paste0('P value (variability vs. age prediction weights): ', as.character(P_Value)));
# Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_Variability_AgeWeights));
PermutationData$Line_x = as.numeric(matrix(Actual_Corr_Variability_AgeWeights, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,210,length.out=1000));
ggplot(PermutationData) + 
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) + 
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.5, 0.91), breaks = c(-0.5, 0, 0.5), labels = c('-0.5', '0', '0.5'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/SpinTestDensity_AgeWeights_Variability_LabelAtlas_Kong.tiff', width = 17, height = 15, dpi = 600, units = "cm");

# EFWeights vs. variability
tmp_data = cor.test(as.numeric(Data_Mat$EFWeights.All.NoMedialWall),
                    as.numeric(Data_Mat$VariabilityLabel.All.NoMedialWall), method = "pearson");
Actual_Corr_Variability_EFWeights = tmp_data$estimate;
Perm_Corr_Variability_EFWeights = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Data_Mat$VariabilityLabel.Perm.All.NoMedialWall[i,] != 100);
  tmp_data = cor.test(as.numeric(Data_Mat$EFWeights.All.NoMedialWall[Non100_Index]),
                      as.numeric(Data_Mat$VariabilityLabel.Perm.All.NoMedialWall[i,Non100_Index]), method = "pearson");
  Perm_Corr_Variability_EFWeights[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_Variability_EFWeights >= Actual_Corr_Variability_EFWeights)) / 1000;
print(paste0('P value (variability vs. EF prediction weights): ', as.character(P_Value)));
# Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_Variability_EFWeights));
PermutationData$Line_x = as.numeric(matrix(Actual_Corr_Variability_EFWeights, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,194,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.5, 0.91), breaks = c(-0.5, 0, 0.5), labels = c('-0.5', '0', '0.5'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/SpinTestDensity_EFWeights_Variability_LabelAtlas_Kong.tiff', width = 17, height = 15, dpi = 600, units = "cm");

# Significance, Age weights (NMF vs. MS-HBM)
tmp_data = cor.test(as.numeric(Data_Mat$AgeWeights.All.NoMedialWall.NMFLabel),
                    as.numeric(Data_Mat$AgeWeights.All.NoMedialWall), method = "pearson");
Actual_Corr_NMFLabel_MSHBM = tmp_data$estimate;
Perm_Corr_NMFLabel_MSHBM = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Data_Mat$AgeWeights.Perm.All.NoMedialWall[i,] != 100);
  tmp_data = cor.test(as.numeric(Data_Mat$AgeWeights.All.NoMedialWall.NMFLabel[Non100_Index]),
                      as.numeric(Data_Mat$AgeWeights.Perm.All.NoMedialWall[i,Non100_Index]), method = "pearson");
  Perm_Corr_NMFLabel_MSHBM[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_NMFLabel_MSHBM >= Actual_Corr_NMFLabel_MSHBM)) / 1000;
print(paste0('P value (Age weights: NMF label vs. MS-HBM): ', as.character(P_Value)));

# Significance, EF weights (NMF vs. MS-HBM)
tmp_data = cor.test(as.numeric(Data_Mat$EFWeights.All.NoMedialWall.NMFLabel),
                    as.numeric(Data_Mat$EFWeights.All.NoMedialWall), method = "pearson");
Actual_Corr_NMFLabel_MSHBM = tmp_data$estimate;
Perm_Corr_NMFLabel_MSHBM = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  # Remove medial wall and low SNR regions in the permuted data
  Non100_Index = which(Data_Mat$EFWeights.Perm.All.NoMedialWall[i,] != 100);
  tmp_data = cor.test(as.numeric(Data_Mat$EFWeights.All.NoMedialWall.NMFLabel[Non100_Index]),
                      as.numeric(Data_Mat$EFWeights.Perm.All.NoMedialWall[i,Non100_Index]), method = "pearson");
  Perm_Corr_NMFLabel_MSHBM[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_NMFLabel_MSHBM >= Actual_Corr_NMFLabel_MSHBM)) / 1000;
print(paste0('P value (EF weights: NMF label vs. MS-HBM): ', as.character(P_Value)));

