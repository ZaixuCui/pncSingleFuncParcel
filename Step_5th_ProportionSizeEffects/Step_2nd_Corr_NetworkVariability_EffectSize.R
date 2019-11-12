
library('R.matlab');
library('mgcv');
library('ggplot2');
library('visreg');

RevisionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
EffectSize_Mat = readMat(paste0(RevisionFolder, '/Corr_NetworkVariability_EffectSize/EffectSize.mat'));
NetworkVariability_Mat = readMat(paste0(RevisionFolder, '/Corr_NetworkVariability_EffectSize/NetworkVariability.mat'));
data = data.frame(NetworkVariability = as.numeric(NetworkVariability_Mat$MedianValue));
data$EffectSize_Age = as.numeric(EffectSize_Mat$Gam.Z.Vector.Age.WholeNetworkSum);
data$EffectSize_EF = as.numeric(EffectSize_Mat$Gam.Z.Vector.Cognition.WholeNetworkSum);

ggplot(data, aes(NetworkVariability, abs(EffectSize_EF))) + 
    geom_point() + 
    geom_smooth(method = lm);
