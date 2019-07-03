
library('R.matlab');
library('mgcv');
library('ggplot2');

ProjectFolder <- '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
Behavior <- read.csv(paste0(ProjectFolder, '/data/n693_Behavior_20181219.csv'));
Behavior_New <- data.frame(BBLID = Behavior$bblid);
Behavior_New$AgeYears <- as.numeric(Behavior$ageAtScan1/12);
Motion <- (Behavior$restRelMeanRMSMotion + Behavior$nbackRelMeanRMSMotion + Behavior$idemoRelMeanRMSMotion)/3;
Behavior_New$Motion <- as.numeric(Motion);
Behavior_New$Sex_factor <- as.factor(Behavior$sex);
Behavior_New$F1_Exec_Comp_Res_Accuracy <- as.numeric(Behavior$F1_Exec_Comp_Res_Accuracy);
AtlasLoading_Folder <- paste0(ProjectFolder, '/results/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLoading');

SubjectsQuantity = 693;
FeaturesQuantity = 18715;
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

# Age effect
Gam_P_Vector_Age_WholeNetworkSum <- matrix(0, 1, 17);
Gam_Z_Vector_Age_WholeNetworkSum <- matrix(0, 1, 17);
Gam_P_Vector_Cognition_WholeNetworkSum <- matrix(0, 1, 17);
Gam_Z_Vector_Cognition_WholeNetworkSum <- matrix(0, 1, 17);
P_Interaction <- matrix(0, 1, 17);
for (i in 1:17)
{
  print(paste0('Network_', as.character(i)));
  Data_I = Data_All[,,i];
  WholeNetworkSum = as.numeric(rowSums(Data_I));
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
BorderColor <- c("#AF33AD", "#E76178", "#E76178", "#AF33AD", "#F5BA2E",
                 "#F5BA2E", "#E76178", "#E443FF", "#00A131", "#7499C2",
                 "#F5BA2E", "#F5BA2E", "#E443FF", "#7499C2", "#7499C2",
                 "#00A131", "#EBE297");
LineType <- c("solid", "dashed", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "dashed", "solid");
Fig <- ggplot(data, aes(EffectRank, AgeEffects_Z)) +
       geom_bar(stat = "identity", fill=c("#AF33AD", "#FFFFFF", 
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", 
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#EBE297"), 
            colour = BorderColor, linetype = LineType, width = 0.8) +
       labs(x = "Networks", y = expression(paste("Age Association (", italic("Z"), ")"))) + theme_classic() + 
       theme(axis.text.x = element_text(size = 27, color = BorderColor),
            axis.text.y = element_text(size = 33, color = "black"), 
            axis.title=element_text(size = 33)) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
       scale_x_discrete(limits = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                 13, 14, 15, 16, 17), 
                        labels = c("5", "1", "4", "2", "17", "9", "14", "6", "12", 
                 "10", "11", "16", "13", "8", "3", "15", "7")) + 
       scale_y_continuous(limits = c(-4, 6), breaks = c(-4, -2, 0, 2, 4, 6));
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/NetworkSize_Loading_AgeEffects.tiff', width = 19, height = 15, dpi = 600, units = "cm");
# bar plot for cognition effects
data <- data.frame(CognitionEffects_Z = as.numeric(Gam_Z_Vector_Cognition_WholeNetworkSum));
data$EffectRank <- rank(data$CognitionEffects_Z);
BorderColor <- c("#E76178", "#EBE297", "#00A131", "#AF33AD", "#00A131", "#7499C2",
                 "#7499C2", "#F5BA2E", "#AF33AD", "#F5BA2E", "#E76178", "#7499C2", 
                 "#E76178", "#E443FF", "#E443FF", "#F5BA2E", "#F5BA2E");
LineType <- c("solid", "solid", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "dashed", "dashed", "dashed", "dashed",
              "dashed", "dashed", "solid", "solid", "solid");
Fig <- ggplot(data, aes(EffectRank, CognitionEffects_Z)) +
            geom_bar(stat = "identity", fill=c("#E76178", "#EBE297", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF",
            "#FFFFFF", "#E443FF", "#F5BA2E", "#F5BA2E"), 
            colour = BorderColor, linetype = LineType, width = 0.8) + 
       labs(x = "Networks", y = expression(paste("EF Association (", italic("Z"), ")"))) + theme_classic() +
       theme(axis.text.x = element_text(size= 27, color = BorderColor), 
            axis.text.y = element_text(size= 33, color = "black"), 
            axis.title=element_text(size = 33)) +
       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
             scale_x_discrete(limits = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                 13, 14, 15, 16, 17),
                 labels = c("4", "7", "15", "5", "12", "10", "8", "16", "2", 
                 "9", "14", "3", "1", "13", "6", "17", "11")) + 
       scale_y_continuous(limits = c(-4, 6), breaks = c(-4, -2, 0, 2, 4, 6));
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/NetworkSize_Loading_EFEffects.tiff', width = 19, height = 15, dpi = 600, units = "cm");
