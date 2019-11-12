
library(R.matlab)
library(ggplot2)

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis/AtlasLabel_Kong';

# Age prediction
# Fold 0
Prediction_Fold0 = readMat(paste0(PredictionFolder, '/2Fold_Sort_Fold0_Specificity_Sig_Age.mat'));
# Corr
Corr_Fold0_Rand = Prediction_Fold0$ParCorr.Rand.Fold0;
PermutationData = data.frame(x = t(Corr_Fold0_Rand));
PermutationData$Line_x = as.numeric(matrix(Prediction_Fold0$ParCorr.Actual.Fold0, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,175,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#7F7F7F", fill = "#7F7F7F") +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.4, 0.65), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Permutation_Age_Corr_Fold0_AtlasLabel_Kong.pdf', width = 17, height = 15, dpi = 600, units = "cm");

# Fold 1
Prediction_Fold1 = readMat(paste0(PredictionFolder, '/2Fold_Sort_Fold1_Specificity_Sig_Age.mat'));
# Corr
Corr_Fold1_Rand = Prediction_Fold1$ParCorr.Rand.Fold1;
PermutationData = data.frame(x = t(Corr_Fold1_Rand));
PermutationData$Line_x = as.numeric(matrix(Prediction_Fold1$ParCorr.Actual.Fold1, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,189,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#000000", fill = "#000000") +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.4, 0.65), breaks = c(-0.4, 0, 0.4), labels = c('-0.4', '0', '0.4'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Permutation_Age_Corr_Fold1_AtlasLabel_Kong.pdf', width = 17, height = 15, dpi = 600, units = "cm");


# EF prediction
# Fold 0
Prediction_Fold0 = readMat(paste0(PredictionFolder, '/2Fold_Sort_Fold0_Specificity_Sig_EFAccuracy.mat'));
# Corr
Corr_Fold0_Rand = Prediction_Fold0$ParCorr.Rand.Fold0;
PermutationData = data.frame(x = t(Corr_Fold0_Rand));
PermutationData$Line_x = as.numeric(matrix(Prediction_Fold0$ParCorr.Actual.Fold0, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,137,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#000000", fill = "#000000") +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.3, 0.47), breaks = c(-0.3, 0, 0.3), labels = c('-0.3', '0', '0.3'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Permutation_EFAccuracy_Corr_Fold0_AtlasLabel_Kong.pdf', width = 17, height = 15, dpi = 600, units = "cm");
# MAE
MAE_Fold0_Rand = Prediction_Fold0$MAE.Rand.Fold0;

# Fold 1
Prediction_Fold1 = readMat(paste0(PredictionFolder, '/2Fold_Sort_Fold1_Specificity_Sig_EFAccuracy.mat'));
# Corr
Corr_Fold1_Rand = Prediction_Fold1$ParCorr.Rand.Fold1;
PermutationData = data.frame(x = t(Corr_Fold1_Rand));
PermutationData$Line_x = as.numeric(matrix(Prediction_Fold1$ParCorr.Actual.Fold1, 1, 1000));
PermutationData$Line_y = as.numeric(seq(0,142,length.out=1000));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#7F7F7F", fill = "#7F7F7F") +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(-0.3, 0.47), breaks = c(-0.3, 0, 0.3), labels = c('-0.3', '0', '0.3'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Permutation_EFAccuracy_Corr_Fold1_AtlasLabel_Kong.pdf', width = 17, height = 15, dpi = 600, units = "cm");
# MAE
MAE_Fold1_Rand = Prediction_Fold1$MAE.Rand.Fold1;


