
library(R.matlab)
library(ggplot2)
library(hexbin)

Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Corr_EvoGradientMyelinScalingCBF';
Data_Mat = readMat(paste0(Folder, '/AllData.mat'));

# plot the highest correlation
myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
# Correlation between age prediction weights and atlas variability
data_Age = data.frame(Variability_Data = as.numeric(t(Data_Mat$VariabilityLoading.17SystemMean.All.NoMedialWall)));
data_Age$AgeWeights_Mean = as.numeric(Data_Mat$AgeWeights.All.NoMedialWall);
cor.test(data_Age$AgeWeights_Mean, data_Age$Variability_Data, method = "pearson");

hexinfo <- hexbin(data_Age$Variability_Data, data_Age$AgeWeights_Mean, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
         geom_hex(data = subset(data_hex, count > 10), aes(x, y, fill = count), stat = "identity") + 
         scale_fill_gradientn(colours = myPalette) +
         geom_smooth(data = data_Age, aes(x = Variability_Data, y = AgeWeights_Mean), method = lm, color = "#FFFFFF", linetype = "dashed") + 
         theme_classic() + labs(x = "Network Variability", y = "Contribution Weight") +
         theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
         theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) + 
         theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
         scale_x_continuous(limits = c(-0.000001, 0.049), breaks = c(0, 0.02, 0.04)) + 
         scale_y_continuous(limits = c(-0.000001, 0.049), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/AgePredictionWeights_Variability.tiff', width = 17, height = 15, dpi = 600, units = "cm");
# Cognition prediction weights vs. atlas variability
data_Cognition = data.frame(Variability_Data = as.numeric(t(Data_Mat$VariabilityLoading.17SystemMean.All.NoMedialWall)));
data_Cognition$CognitionWeights_Mean = as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall);
cor.test(data_Cognition$CognitionWeights_Mean, data_Cognition$Variability_Data, method = "pearson");

hexinfo <- hexbin(data_Cognition$Variability_Data, data_Cognition$CognitionWeights_Mean, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
        geom_hex(data = subset(data_hex, count > 10), aes(x, y, fill = count), stat = "identity") + 
        scale_fill_gradientn(colours = myPalette, breaks = c(50, 100, 150)) +
        geom_smooth(data = data_Cognition, aes(x = Variability_Data, y = CognitionWeights_Mean), method = lm, color = "#FFFFFF", linetype = "dashed") +
        theme_classic() + labs(x = "Network Variability", y = "Contribution Weight") +
        theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
        theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) + 
        theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
        scale_x_continuous(limits = c(-0.000001, 0.050), breaks = c(0, 0.02, 0.04)) +
        scale_y_continuous(limits = c(-0.000001, 0.050), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/EFPredictionWeights_Variability.tiff', width = 16, height = 15, dpi = 600, units = "cm");

# Significance
# AgeWeights vs. variability
tmp_data = cor.test(as.numeric(Data_Mat$AgeWeights.All.NoMedialWall),
                    as.numeric(Data_Mat$VariabilityLoading.17SystemMean.All.NoMedialWall), method = "pearson");
Actual_Corr_Variability_AgeWeights = tmp_data$estimate;
Perm_Corr_Variability_AgeWeights = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  tmp_data = cor.test(as.numeric(Data_Mat$AgeWeights.All.NoMedialWall),
                      as.numeric(Data_Mat$VariabilityLoading.17SystemMean.Perm.All.NoMedialWall[i,]), method = "pearson");
  Perm_Corr_Variability_AgeWeights[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_Variability_AgeWeights >= Actual_Corr_Variability_AgeWeights)) / 1000;
print(paste0('P value (variability vs. age prediction weights): ', as.character(P_Value)));
# Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_Variability_AgeWeights));
PermutationData$Line_x = as.numeric(matrix(0.55, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,185,length.out=1000));
ggplot(PermutationData) + 
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) + 
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.4, 0.63), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/SpinTestDensity_AgeWeights_Variability.tiff', width = 17, height = 15, dpi = 600, units = "cm");
# CognitionWeights vs. variability
tmp_data = cor.test(as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall),
                    as.numeric(Data_Mat$VariabilityLoading.17SystemMean.All.NoMedialWall), method = "pearson");
Actual_Corr_Variability_CognitionWeights = tmp_data$estimate;
Perm_Corr_Variability_CognitionWeights = matrix(0, 1, 1000);
for (i in c(1:1000))
{
  print(i);
  tmp_data = cor.test(as.numeric(Data_Mat$CognitionWeights.All.NoMedialWall),
                      as.numeric(Data_Mat$VariabilityLoading.17SystemMean.Perm.All.NoMedialWall[i,]), method = "pearson");
  Perm_Corr_Variability_CognitionWeights[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_Variability_CognitionWeights >= Actual_Corr_Variability_CognitionWeights)) / 1000;
print(paste0('P value (variability vs. cognition prediction weights): ', as.character(P_Value)));
# Plot for permutaiton distribution
PermutationData = data.frame(x = t(Perm_Corr_Variability_CognitionWeights));
PermutationData$Line_x = as.numeric(matrix(0.61, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,195,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.4, 0.69), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/SpinTestDensity_CognitionWeights_Variability.tiff', width = 17, height = 15, dpi = 600, units = "cm");

