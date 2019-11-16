
library('R.matlab');
library('mgcv');
library('ggplot2');
library('visreg');

RevisionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
UnivariateFolder = paste0(RevisionFolder, '/GamAnalysis/AtlasLoading');
NetworkVariability_Mat = readMat(paste0(RevisionFolder, '/Corr_NetworkVariability_EffectSize/NetworkVariability.mat'));
data = data.frame(NetworkVariability = as.numeric(NetworkVariability_Mat$MedianValue));

# EF
data$NumOfSigVertices_Univariate_EF = as.numeric(matrix(0, 1, 17));
AgeEffect_Univariate_Folder = paste0(UnivariateFolder, '/AgeEffects');
EFEffect_Univariate_Folder = paste0(UnivariateFolder, '/CognitionEffects');
for (i in c(1:17)) {
    # EF
    tmp_Data = readMat(paste0(EFEffect_Univariate_Folder, '/CognitionEffect_AtlasLoading_17_Network_', as.character(i), '.mat'));
    data$NumOfSigVertices_Univariate_EF[i] = length(which(tmp_Data$Gam.Z.FDR.Sig.Cognition.Vector.All != 0));
}
# EF
cor.test(data$NetworkVariability, data$NumOfSigVertices_Univariate_EF);

# EF
ggplot(data, aes(NetworkVariability, NumOfSigVertices_Univariate_EF)) +
    geom_point() +
    geom_smooth(method = lm, se = FALSE) +
    theme_classic() +
    theme(axis.text=element_text(size = 30, color = 'black'), axis.title = element_text(size = 30)) +
    scale_y_continuous(limits = c(0, 1010), breaks = c(0, 400, 800), label = c("0", "400", "800")) +
    scale_x_continuous(limits = c(0.009, 0.035), breaks = c(0.010, 0.020, 0.030)) +
    geom_point(color = '#000000', size = 1.5) +
    labs(x = "Network Variability", y = 'Number of Sig Vertices')
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/NetworkVariability_EFEffects_Univariate.tiff', width = 19, height = 15, dpi = 600, units = "cm");

