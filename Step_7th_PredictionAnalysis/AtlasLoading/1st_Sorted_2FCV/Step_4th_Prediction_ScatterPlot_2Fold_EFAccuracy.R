
library(R.matlab)
library(ggplot2)
library(visreg)

WorkingFolder <- '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis'
PredictionFolder <- paste0(WorkingFolder, '/AtlasLoading/2Fold_Sort_EFAccuracy');
Fold0 <- readMat(paste0(PredictionFolder, '/Fold_0_Score.mat'));
TestScore_Fold0 <- t(Fold0$Test.Score);
PredictScore_Fold0 <- as.numeric(t(Fold0$Predict.Score));
Index_Fold0 <- Fold0$Index + 1;
Fold1 <- readMat(paste0(PredictionFolder, '/Fold_1_Score.mat'));
TestScore_Fold1 <- t(Fold1$Test.Score);
PredictScore_Fold1 <- as.numeric(t(Fold1$Predict.Score));
Index_Fold1 <- Fold1$Index + 1;

Predict_Max <- max(c(PredictScore_Fold0, PredictScore_Fold1));
Predict_Min <- min(c(PredictScore_Fold0, PredictScore_Fold1));
Test_Max <- max(c(TestScore_Fold0, TestScore_Fold1));
Test_Min <- min(c(TestScore_Fold0, TestScore_Fold1));

Behavior <- readMat(paste0(WorkingFolder, '/Behavior_693.mat'));
# Fold 0
Behavior_Fold0 = data.frame(Age = as.numeric(Behavior$Age[Index_Fold0]));
Behavior_Fold0$Sex = as.numeric(Behavior$Sex[Index_Fold0]);
Behavior_Fold0$Motion = as.numeric(Behavior$Motion[Index_Fold0]);
Behavior_Fold0$F1_Exec_Comp_Res_Accuracy = as.numeric(Behavior$F1.Exec.Comp.Res.Accuracy[Index_Fold0]);
# Fold 1
Behavior_Fold1 = data.frame(Age = as.numeric(Behavior$Age[Index_Fold1]));
Behavior_Fold1$Sex = as.numeric(Behavior$Sex[Index_Fold1]);
Behavior_Fold1$Motion = as.numeric(Behavior$Motion[Index_Fold1]);
Behavior_Fold1$F1_Exec_Comp_Res_Accuracy = as.numeric(Behavior$F1.Exec.Comp.Res.Accuracy[Index_Fold1]);

Color_Fold0 = '#7F7F7F';
Color_Fold1 = '#000000'; 

# Fold 1
Energy_lm <- lm(PredictScore_Fold1 ~ F1_Exec_Comp_Res_Accuracy + Age + Sex + Motion, data = Behavior_Fold1);
plotdata <- visreg(Energy_lm, "F1_Exec_Comp_Res_Accuracy", type = "conditional", scale = "linear", plot = FALSE);
smooths_Fold1 <- data.frame(Variable = plotdata$meta$x,
                      x = plotdata$fit[[plotdata$meta$x]],
                      smooth = plotdata$fit$visregFit,
                      lower = plotdata$fit$visregLwr,
                      upper = plotdata$fit$visregUpr);
predicts_Fold1 <- data.frame(Variable = "dim1",
                      x = plotdata$res$F1_Exec_Comp_Res_Accuracy,
                      y = plotdata$res$visregRes)
Fig <- ggplot() +
       geom_point(data = predicts_Fold1, aes(x, y), colour = Color_Fold1, size = 2) +
       geom_line(data = smooths_Fold1, aes(x = x, y = smooth), colour = Color_Fold1, size = 1.5) +
       geom_ribbon(data = smooths_Fold1, aes(x = x, ymin = lower, ymax = upper), fill = Color_Fold1, alpha = 0.2)

# Fold 0
Energy_lm <- lm(PredictScore_Fold0 ~ F1_Exec_Comp_Res_Accuracy + Age + Sex + Motion, data = Behavior_Fold0);
plotdata <- visreg(Energy_lm, "F1_Exec_Comp_Res_Accuracy", type = "conditional", scale = "linear", plot = FALSE);
smooths <- data.frame(Variable = plotdata$meta$x, 
                      x = plotdata$fit[[plotdata$meta$x]],
                      smooth = plotdata$fit$visregFit,
                      lower = plotdata$fit$visregLwr,
                      upper = plotdata$fit$visregUpr);
predicts <- data.frame(Variable = "dim1",
                      x = plotdata$res$F1_Exec_Comp_Res_Accuracy,
                      y = plotdata$res$visregRes)
Fig <- Fig + 
       geom_point(data = predicts, aes(x, y), colour = Color_Fold0, size = 2, shape = 17) + 
       geom_line(data = smooths, aes(x = x, y = smooth), colour = Color_Fold0, size = 1.5) + 
       geom_ribbon(data = smooths, aes(x = x, ymin = lower, ymax = upper), fill = Color_Fold0, alpha = 0.2) +
       theme_classic() + labs(x = "Actual EF Performance", y = "Predicted EF Performance") +
       theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30)) +
       scale_y_continuous(limits = c(-1.6, 1.9), breaks = c(-1.6, -0.8, 0, 0.8, 1.6)) +
       scale_x_continuous(limits = c(-3.3, 2.3), breaks = c(-3.2, -1.6, 0, 1.6))
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFAccuracyPrediction_CorrACC.tiff', width = 17, height = 15, dpi = 600, units = "cm");
