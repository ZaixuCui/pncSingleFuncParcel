
library(R.matlab)
library(ggplot2)

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/PredictionAnalysis';
# Actual accuracy
Actual_Data = readMat(paste0(PredictionFolder, '/AtlasLoading/2Fold_RandomCV_EFAccuracy/2Fold_RandomCV_ParCorr_MAE.mat'));
Corr_Actual = Actual_Data$ParCorr.Actual.RandomCV;
MAE_Actual = Actual_Data$MAE.Actual.RandomCV;
ActualData = data.frame(Corr = t(Corr_Actual));
ggplot(ActualData) +
    geom_histogram(aes(x = Corr), bins = 30, color = "#000000", fill = "#000000") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=30, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(0.40, 0.54), breaks = c(0.40, 0.47, 0.54), labels = c('0.40', '0.47', '0.54'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/ActualCorr_EFAccuracy_RandomCV.pdf', width = 17, height = 15, dpi = 600, units = "cm");

# Permutation test accuracy
Permutation_Data = readMat(paste0(PredictionFolder, '/AtlasLoading/2Fold_RandomCV_EFAccuracy_Permutation/2Fold_RandomCV_ParCorr_MAE_Permutation.mat'));
Corr_Permutation = Permutation_Data$ParCorr.Permutation.RandomCV;
MAE_Permutation = Permutation_Data$MAE.Permutation.RandomCV;
PermutationData = data.frame(Corr = t(Corr_Permutation));
ggplot(PermutationData) + 
    geom_histogram(aes(x = Corr), bins = 30, color = "#999999", fill = "#999999") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.18, 0.19), breaks = c(-0.18, 0, 0.18), labels = c('-0.18', '0', '0.18'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/PermutationCorr_EFAccuracy_RandomCV.pdf', width = 17, height = 15, dpi = 600, units = "cm");
