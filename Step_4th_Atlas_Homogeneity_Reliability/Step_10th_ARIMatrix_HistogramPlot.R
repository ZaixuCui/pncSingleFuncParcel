
library(R.matlab)
library(ggplot2)

AtlasSimilarityFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Atlas_Homogeneity_Reliability/AtlasSimilarity';
ARI_Data = readMat(paste0(AtlasSimilarityFolder, '/ARIMatrix_Hongming_Kong.mat'));
ARI_SameIndividual = data.frame(ARI = ARI_Data$ARIMatrix.Hongming.Kong.Diagonal);
ARI_DifferentIndividual = data.frame(ARI = ARI_Data$ARIMatrix.Hongming.Kong.OffDiagonal);
# ARI, Same individual
ggplot(ARI_SameIndividual) +
    geom_histogram(aes(x = ARI), bins = 30, color = "#000000", fill = "#000000") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=30, color='black'), aspect.ratio = 1) +
    #theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(0.40, 0.62), breaks = c(0.41, 0.50, 0.59), labels = c('0.41', '0.50', '0.59'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/ARI_SameIndividual.pdf', width = 17, height = 15, dpi = 600, units = "cm");
# ARI, Different individual
ggplot(ARI_DifferentIndividual) + 
    geom_histogram(aes(x = ARI), bins = 30, color = "#000000", fill = "#000000") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=30, color='black'), aspect.ratio = 1) +
    #theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(0.20, 0.42), breaks = c(0.21, 0.30, 0.39), labels = c('0.21', '0.30', '0.39'))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/ARI_DifferentIndividuals.pdf', width = 17, height = 15, dpi = 600, units = "cm");


