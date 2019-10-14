
library(R.matlab)
library(ggplot2)

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
# Actual accuracy
Actual_Data = readMat(paste0(PredictionFolder, '/AtlasLabel_Kong/2Fold_RandomCV_Age/2Fold_RandomCV_ParCorr_MAE_Actual.mat'));
Corr_Actual = Actual_Data$ParCorr.Actual.RandomCV;
MAE_Actual = Actual_Data$MAE.Actual.RandomCV;
ActualData = data.frame(Corr = t(Corr_Actual));
ggplot(ActualData) +
    geom_histogram(aes(x = Corr), bins = 30, color = "#000000", fill = "#000000") +
    theme_classic() + labs(x = expression(paste("Prediction Accuracy (", italic("r"), ")")), y = "") +
    theme(axis.text=element_text(size=30, color='black'), aspect.ratio = 1) +
    theme(axis.title=element_text(size = 30)) + 
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(0.46, 0.58), breaks = c(0.46, 0.52, 0.58), labels = c('0.46', '0.52', '0.58'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/ActualCorr_Age_RandomCV_AtlasLabel_Kong.pdf', width = 17, height = 15, dpi = 600, units = "cm");

# Permutation test accuracy
Permutation_Data = readMat(paste0(PredictionFolder, '/AtlasLabel_Kong/2Fold_RandomCV_Age_Permutation/2Fold_RandomCV_ParCorr_MAE_Permutation.mat'));
Corr_Permutation = Permutation_Data$ParCorr.Permutation.RandomCV;
MAE_Permutation = Permutation_Data$MAE.Permutation.RandomCV;
PermutationData = data.frame(Corr = t(Corr_Permutation));
ggplot(PermutationData) + 
    geom_histogram(aes(x = Corr), bins = 30, color = "#999999", fill = "#999999") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.2, 0.23), breaks = c(-0.2, 0, 0.2), labels = c('-0.2', '0', '0.2'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/PermutationCorr_Age_RandomCV_AtlasLabel_Kong.pdf', width = 17, height = 15, dpi = 600, units = "cm");

