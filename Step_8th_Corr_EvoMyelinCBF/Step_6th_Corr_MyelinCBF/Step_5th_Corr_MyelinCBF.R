
library(R.matlab)
library(ggplot2)
library(hexbin)

Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Corr_EvoMyelinCBF/Corr_MyelinCBF';
Data_Mat = readMat(paste0(Folder, '/AllData.mat'));

myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
# Myelin vs. mean CBF
Data_tmp = data.frame(Myelin_All_NoMedialWall = as.numeric(Data_Mat$Myelin.All.NoMedialWall));
Data_tmp$MeanCBF_All_NoMedialWall = as.numeric(Data_Mat$MeanCBF.All.NoMedialWall);
cor.test(Data_tmp$Myelin_All_NoMedialWall, Data_tmp$MeanCBF_All_NoMedialWall, method = "pearson");
ggplot(data = Data_tmp, aes(Myelin_All_NoMedialWall, MeanCBF_All_NoMedialWall)) + 
    geom_point() +
    geom_smooth(method = lm) +
    theme_classic() + labs(x = "Myelin Content", y = "Mean CBF") +
    theme(axis.text=element_text(size=25, color='black'), axis.title=element_text(size=30)) +
    scale_fill_manual("", values = "grey12");
# Myelin vs. meanCBF (remove outlier points)
Index = which(Data_Mat$Myelin.All.NoMedialWall >= 1 & Data_Mat$MeanCBF.All.NoMedialWall >= 27);
Data_tmp2 = data.frame(Myelin_All_NoMedialWall = Data_Mat$Myelin.All.NoMedialWall[Index]);
Data_tmp2$MeanCBF_All_NoMedialWall = Data_Mat$MeanCBF.All.NoMedialWall[Index];
cor.test(Data_tmp2$Myelin_All_NoMedialWall, Data_tmp2$MeanCBF_All_NoMedialWall, method = "pearson");
hexinfo <- hexbin(Data_tmp2$Myelin_All_NoMedialWall, Data_tmp2$MeanCBF_All_NoMedialWall, xbins = 30);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
ggplot() +
    geom_hex(data = subset(data_hex, count > 10), aes(x, y, fill = count), stat = "identity") +
    scale_fill_gradientn(colours = myPalette) +
    geom_smooth(data = Data_tmp2, aes(x = Myelin_All_NoMedialWall, y = MeanCBF_All_NoMedialWall), method = lm, color = "#FFFFFF", linetype = "dashed") +
    theme_classic() + labs(x = "Myelin Content", y = "Mean CBF") +
    theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
    theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
    theme(legend.justification = c(1, 1), legend.position = c(1.02, 1)) +
    scale_x_continuous(limits = c(0.98, 2.0), breaks = c(1.0, 1.4, 1.8)) +
    scale_y_continuous(limits = c(-0.000001, 0.053), breaks = c(0, 0.02, 0.04));
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Myelin_MeanCBF_Corr.pdf', width = 17, height = 15, dpi = 600, units = "cm");

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
  tmp_data = cor.test(as.numeric(Data_Mat$Myelin.Perm.All.NoMedialWall[i,Index]),
                      as.numeric(Data_Mat$MeanCBF.All.NoMedialWall[Index]), method = "pearson");
  Perm_Corr_MyelinCBF[i] = tmp_data$estimate;
}
P_Value = length(which(Perm_Corr_MyelinCBF <= Actual_Corr_MyelinCBF)) / 1000;
print(paste0('P value (variability vs. myelin): ', as.character(P_Value)));
  # Plot for permutation distribution
PermutationData = data.frame(x = t(Perm_Corr_Myelin));
PermutationData$Line_x = as.numeric(matrix(Actual_Corr_Myelin, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,108,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    #geom_point(aes(x = Actual_Corr, y = 0), size=3) +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.6, 0.6), breaks = c(-0.5, 0, 0.5), labels = c('-0.5', '0', '0.5'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/SpinTestDensity_Myelin_MeanCBF.pdf', width = 17, height = 15, dpi = 600, units = "cm");

