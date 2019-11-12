
library('R.matlab');
library('mgcv');
library('ggplot2');
library('visreg');

ProjectFolder <- '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
Behavior <- read.csv(paste0(ProjectFolder, '/data/n693_Behavior_20181219.csv'));
Behavior_New <- data.frame(BBLID = Behavior$bblid);
Behavior_New$AgeYears <- as.numeric(Behavior$ageAtScan1/12);
Motion <- (Behavior$restRelMeanRMSMotion + Behavior$nbackRelMeanRMSMotion + Behavior$idemoRelMeanRMSMotion)/3;
Behavior_New$Motion <- as.numeric(Motion);
Behavior_New$Sex_factor <- as.factor(Behavior$sex);
Behavior_New$F1_Exec_Comp_Res_Accuracy <- as.numeric(Behavior$F1_Exec_Comp_Res_Accuracy);
AtlasLoading_Folder <- paste0(ProjectFolder, '/Revision/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLoading');

SubjectsQuantity = 693;
FeaturesQuantity = 17734;
# Extract Loading
Data_Size <- SubjectsQuantity * FeaturesQuantity * 17;
Data_All <- matrix(0, 1, Data_Size);
dim(Data_All) <- c(SubjectsQuantity, FeaturesQuantity, 17);
BBLID <- Behavior_New$BBLID;
for (i in c(1:length(BBLID)))
{
  print(i);
  AtlasLoading_File <- paste0(AtlasLoading_Folder, '/', as.character(BBLID[i]), '.mat');
  Data <- readMat(AtlasLoading_File);
  Data_All[i,,] <- Data$sbj.AtlasLoading.NoMedialWall;
}

Gam_Z_Vector_Age_WholeNetworkSum <- matrix(0, 1, 17);
Gam_P_Vector_Age_WholeNetworkSum <- matrix(0, 1, 17);
Gam_P_Vector_Cognition_WholeNetworkSum <- matrix(0, 1, 17);
Gam_Z_Vector_Cognition_WholeNetworkSum <- matrix(0, 1, 17);
NetworkSize_Variability <- matrix(0, 1, 17);
for (i in 1:17)
{
  print(paste0('Network_', as.character(i)));
  Data_I = Data_All[,,i];
  WholeNetworkSum = as.numeric(rowSums(Data_I));
  NetworkSize_Variability[i] = sd(WholeNetworkSum); 
  # Effects of network size 
  Gam_Analysis_WholeNetworkSum <- gam(WholeNetworkSum ~ s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
  Gam_P_Vector_Age_WholeNetworkSum[i] = summary(Gam_Analysis_WholeNetworkSum)$s.table[4];
  Gam_Z_Vector_Age_WholeNetworkSum[i] <- qnorm(Gam_P_Vector_Age_WholeNetworkSum[i] / 2, lower.tail = FALSE);
  lm_Analysis_WholeNetworkSum <- lm(WholeNetworkSum ~ AgeYears + Sex_factor + Motion, data = Behavior_New);
  Age_T <- summary(lm_Analysis_WholeNetworkSum)$coefficients[2, 3];
  if (Age_T < 0) {
    Gam_Z_Vector_Age_WholeNetworkSum[i] <- -Gam_Z_Vector_Age_WholeNetworkSum[i];
  }
  print(paste0('Age effect: P Value is: ', as.character(summary(Gam_Analysis_WholeNetworkSum)$s.table[4]))) 
     # Calculate the partial correlation to represent effect size
  WholeNetworkSum_Partial <- lm(WholeNetworkSum ~ Sex_factor + Motion, data = Behavior_New)$residuals;
  Age_Partial <- lm(AgeYears ~ Sex_factor + Motion, data = Behavior_New)$residuals;
  cor.test(WholeNetworkSum_Partial, Age_Partial);

  Gam_Analysis_Cognition_WholeNetworkSum <- gam(WholeNetworkSum ~ F1_Exec_Comp_Res_Accuracy + s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
  Gam_P_Vector_Cognition_WholeNetworkSum[i] = summary(Gam_Analysis_Cognition_WholeNetworkSum)$p.table[2,4];
  Gam_Z_Vector_Cognition_WholeNetworkSum[i] = summary(Gam_Analysis_Cognition_WholeNetworkSum)$p.table[2,3];
  print(paste0('Cognition effect: P Value is: ', as.character(summary(Gam_Analysis_Cognition_WholeNetworkSum)$p.table[2,4])));
      # Calculate the partial correlation to represent effect size
  WholeNetworkSum_Partial <- lm(WholeNetworkSum ~ AgeYears + Sex_factor + Motion, data = Behavior_New)$residuals;
  EF_Partial <- lm(F1_Exec_Comp_Res_Accuracy ~ AgeYears + Sex_factor + Motion, data = Behavior_New)$residuals;
  cor.test(WholeNetworkSum_Partial, EF_Partial);
}
Gam_P_Vector_Age_WholeNetworkSum_Bonf = p.adjust(Gam_P_Vector_Age_WholeNetworkSum, 'bonferroni');
Gam_P_Vector_Cognition_WholeNetworkSum_Bonf = p.adjust(Gam_P_Vector_Cognition_WholeNetworkSum, 'bonferroni');

# Using 7 colors scheme for bar plot
# bar plot for age effects 
data <- data.frame(AgeEffects_Z = as.numeric(Gam_Z_Vector_Age_WholeNetworkSum));
data$EffectRank <- rank(data$AgeEffects_Z);
BorderColor <- c("#7499C2", "#AF33AD", "#E76178", "#AF33AD", "#E443FF",
                 "#7499C2", "#7499C2", "#E76178", "#F5BA2E", "#F5BA2E",
                 "#7499C2", "#4E31A8", "#00A131", "#E443FF", "#F5BA2E", 
                 "#00A131", "#E76178");
LineType <- c("solid", "solid", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "dashed", "dashed");
Fig <- ggplot(data, aes(EffectRank, AgeEffects_Z)) +
       geom_bar(stat = "identity", fill=c("#7499C2", "#AF33AD", 
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", 
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF"), 
            colour = BorderColor, linetype = LineType, width = 0.8) +
       labs(x = "Networks", y = expression(paste("Age Association (", italic("Z"), ")"))) + theme_classic() + 
       theme(axis.text.x = element_text(size = 27, color = BorderColor),
            axis.text.y = element_text(size = 33, color = "black"), 
            axis.title=element_text(size = 33)) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
       scale_x_discrete(limits = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                 13, 14, 15, 16, 17), 
                        labels = c("4", "10", "8", "6", "7", "13", "2", "1", "15", 
                 "17", "11", "16", "14", "9", "3", "5", "12")) + 
       scale_y_continuous(limits = c(-4, 4), breaks = c(-4, -2, 0, 2, 4));
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/NetworkSize_Loading_AgeEffects.tiff', width = 19, height = 15, dpi = 600, units = "cm");

# bar plot for cognition effects
data <- data.frame(CognitionEffects_Z = as.numeric(Gam_Z_Vector_Cognition_WholeNetworkSum));
data$EffectRank <- rank(data$CognitionEffects_Z);
BorderColor <- c("#7499C2", "#E76178", "#E76178", "#F5BA2E", "#AF33AD",
                 "#7499C2", "#7499C2", "#E443FF", "#4E31A8", "#AF33AD",
                 "#00A131", "#7499C2", "#00A131", "#E443FF", "#E76178", 
                 "#F5BA2E", "#F5BA2E");
LineType <- c("solid", "dashed", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "solid", "solid");
Fig <- ggplot(data, aes(EffectRank, CognitionEffects_Z)) +
            geom_bar(stat = "identity", fill=c("#7499C2", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#F5BA2E", "#F5BA2E"), 
            colour = BorderColor, linetype = LineType, width = 0.8) + 
       labs(x = "Networks", y = expression(paste("EF Association (", italic("Z"), ")"))) + theme_classic() +
       theme(axis.text.x = element_text(size= 27, color = BorderColor), 
            axis.text.y = element_text(size= 33, color = "black"), 
            axis.title=element_text(size = 33)) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
             scale_x_discrete(limits = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                 13, 14, 15, 16, 17),
                 labels = c("2", "8", "12", "3", "6", "4", "13", "7", "16", 
                 "10", "5", "11", "14", "9", "1", "15", "17")) + 
       scale_y_continuous(limits = c(-4, 6), breaks = c(-4, -2, 0, 2, 4, 6));
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/NetworkSize_Loading_EFEffects.tiff', width = 19, height = 15, dpi = 600, units = "cm");

# Scatter plots of age effects of total representation of motor network
i = 4;
Data_I = Data_All[,,i];
WholeNetworkSum = as.numeric(rowSums(Data_I));
Gam_Analysis_Age_WholeNetworkSum <- gam(WholeNetworkSum ~ s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
# Calculate the partial correlation to represent effect size
WholeNetworkSum_Partial <- lm(WholeNetworkSum ~ Sex_factor + Motion, data = Behavior_New)$residuals;
Age_Partial <- lm(AgeYears ~ Sex_factor + Motion, data = Behavior_New)$residuals;
cor.test(WholeNetworkSum_Partial, Age_Partial);
Fig <- visreg(Gam_Analysis_Age_WholeNetworkSum, "AgeYears", xlab = "Age (Years)", ylab = "Total Representation", 
              line.par = list(col = '#7499C2'), fill = list(fill = '#D9E2EC'), gg = TRUE)
Fig <- Fig + theme_classic() +
       theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30)) +
       scale_y_continuous(limits = c(380, 860), breaks = c(380, 580, 780), label = c("380", "580", "780")) +
       scale_x_continuous(limits = c(8, 23), breaks = c(8, 13, 18, 23)) +
       geom_point(color = '#7499C2', size = 1.5)
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/AgeEffect_Scatter_Network4.tiff', width = 17, height = 15, dpi = 300, units = "cm");

# Scatter plots of cognition effects for two significant FP networks
i = 15;
Data_I = Data_All[,,i];
WholeNetworkSum = as.numeric(rowSums(Data_I));
Gam_Analysis_Cognition_WholeNetworkSum <- gam(WholeNetworkSum ~ F1_Exec_Comp_Res_Accuracy + s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
Fig <- visreg(Gam_Analysis_Cognition_WholeNetworkSum, "F1_Exec_Comp_Res_Accuracy", xlab = "EF Performance", ylab = "Total Representation", line.par = list(col = '#F5BA2E'), fill = list(fill = '#F3DDA8'), gg = TRUE)
Fig <- Fig + theme_classic() +
       theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30)) +
       scale_y_continuous(limits = c(399, 710), breaks = c(400, 500, 600, 700), label = c("400", "500", "600", "700")) + 
       scale_x_continuous(limits = c(-3.3, 2.3), breaks = c(-3.2, -1.6, 0, 1.6)) + 
       geom_point(color = '#F5BA2E', size = 1.5)
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFEffect_Scatter_Network15.tiff', width = 17, height = 15, dpi = 300, units = "cm");

i = 17;
Data_I = Data_All[,,i];
WholeNetworkSum = as.numeric(rowSums(Data_I));
Gam_Analysis_Cognition_WholeNetworkSum <- gam(WholeNetworkSum ~ F1_Exec_Comp_Res_Accuracy + s(AgeYears, k=4) + Sex_factor + Motion, method = "REML", data = Behavior_New);
Fig <- visreg(Gam_Analysis_Cognition_WholeNetworkSum, "F1_Exec_Comp_Res_Accuracy", xlab = "EF Performance", ylab = "Total Representation", line.par = list(col = '#F5BA2E'), fill = list(fill = '#F3DDA8'), gg = TRUE)
Fig <- Fig + theme_classic() +
       theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30)) +
       scale_y_continuous(limits = c(1000, 1900), breaks = c(1000, 1300, 1600, 1900), label = c("1000", "1300", "1600", "1900")) +
       scale_x_continuous(limits = c(-3.3, 2.3), breaks = c(-3.2, -1.6, 0, 1.6)) +
       geom_point(color = '#F5BA2E', size = 1.5)
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFEffect_Scatter_Network17.tiff', width = 17, height = 15, dpi = 300, units = "cm");

