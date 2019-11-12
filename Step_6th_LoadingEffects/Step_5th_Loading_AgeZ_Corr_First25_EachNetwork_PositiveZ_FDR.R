
library(R.matlab)
library(ggplot2)
library(hexbin)

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
AtlasFolder = paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis');
GroupLoadings_Mat = readMat(paste0(AtlasFolder, '/Group_AtlasLoading.mat'));
GroupLoadings = GroupLoadings_Mat$sbj.AtlasLoading.NoMedialWall;

PearCorr_Loading_AgeZ = matrix(0, 1, 17);
PearCorr_Loading_AgeZ_PValue = matrix(0, 1, 17);
AgeEffect_Folder = paste0(ResultsFolder, '/GamAnalysis/AtlasLoading/AgeEffects');
for (i in c(1:17)){
    if (i == 4){
        PearCorr_Loading_AgeZ[i] = NA;
        PearCorr_Loading_AgeZ_PValue[i] = NA;
        next
    }
    Loading_NetworkI = GroupLoadings[, i];
    # Extracting vertices with non-zero weight and positive relationship between age and loading 
    AgeEffects_Mat = readMat(paste0(AgeEffect_Folder, '/AgeEffect_AtlasLoading_17_Network_', as.character(i), '.mat'));
    Index = which(AgeEffects_Mat$Gam.Z.FDR.Sig.Vector.All>0);
    Loading_NetworkI = Loading_NetworkI[Index];
    AgeZ_NetworkI = AgeEffects_Mat$Gam.Z.FDR.Sig.Vector.All[Index];
    
    # Correlation between mean variability and mean absolute effects
    print(paste0('Network_', as.character(i)));
    Correlation = cor.test(Loading_NetworkI, AgeZ_NetworkI, method = "pearson");
    print(paste0('Pearson Correlation: ', as.character(Correlation$estimate)));
    PearCorr_Loading_AgeZ[i] = Correlation$estimate;

    # Permutation
    PearCorr_Loading_AgeZ_Permutation = c(1:10000);
    for (j in c(1:10000)){
      ind = sample(c(1:length(AgeZ_NetworkI)), length(AgeZ_NetworkI));
      AgeZ_NetworkI_Rand = AgeZ_NetworkI[ind];
      Correlation = cor.test(Loading_NetworkI, abs(AgeZ_NetworkI_Rand), method = "pearson");
      PearCorr_Loading_AgeZ_Permutation[j] = Correlation$estimate;
    }
    if (PearCorr_Loading_AgeZ[i] < 0) {
      PearCorr_Loading_AgeZ_PValue[i] =
          length(which(PearCorr_Loading_AgeZ_Permutation < PearCorr_Loading_AgeZ[i])) / 10000;
    } else {
      PearCorr_Loading_AgeZ_PValue[i] =
          length(which(PearCorr_Loading_AgeZ_Permutation > PearCorr_Loading_AgeZ[i])) / 10000;
    }
}

PearCorr_Loading_AgeZ_PValue_Bonf = p.adjust(PearCorr_Loading_AgeZ_PValue, 'bonferroni');
print(PearCorr_Loading_AgeZ);
print(PearCorr_Loading_AgeZ_PValue_Bonf);
print(length(which(PearCorr_Loading_AgeZ<0 & PearCorr_Loading_AgeZ_PValue_Bonf<0.05)));
print(length(which(PearCorr_Loading_AgeZ>0 & PearCorr_Loading_AgeZ_PValue_Bonf<0.05)));


