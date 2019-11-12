
library(R.matlab)
library(ggplot2)

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
PredictionFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLoading');
WeightFolder = paste0(PredictionFolder, '/WeightVisualize_EFAccuracy_RandomCV');
Weight_EFAccuracy_Mat = readMat(paste0(WeightFolder, '/w_Brain_EFAccuracy_Matrix.mat'));
Weight_EFAccuracy_Matrix = Weight_EFAccuracy_Mat$w.Brain.EFAccuracy.Matrix;

EFAccuracyEffect_Folder = paste0(ResultsFolder, '/GamAnalysis/AtlasLoading/CognitionEffects');
# plot contributing weight for age prediction
data <- data.frame(group = matrix(0, 34, 1));
data$x <- matrix(0, 34, 1);
data$y <- matrix(0, 34, 1);
Pos_Weight <- matrix(0, 1, 17);
for (i in c(1:17)){
    EFAccuracyWeight_tmp = Weight_EFAccuracy_Matrix[i,];
    data$group[i] = 'Below';
    data$x[i] = i;
    data$y[i] = sum(EFAccuracyWeight_tmp[which(EFAccuracyWeight_tmp > 0)]);
    data$group[i + 17] = 'Above';
    data$x[i + 17] = i;
    data$y[i + 17] = sum(EFAccuracyWeight_tmp[which(EFAccuracyWeight_tmp < 0)]);
    Pos_Weight[i] = data$y[i];
}
WeightSort <- sort(Pos_Weight, index.return = TRUE);
Rank <- WeightSort$ix;
data$x[1:17] <- data$x[1:17][Rank];
data$y[1:17] <- data$y[1:17][Rank];
data$x[18:34] <- data$x[18:34][Rank];
data$y[18:34] <- data$y[18:34][Rank];
data$x_New <- rbind(as.matrix(c(1:17)),as.matrix(c(1:17)));
data$x_ <- as.character(data$x_New);
ColorScheme_XAxis <- c("#7499C2", "#7499C2", "#AF33AD", "#F5BA2E", "#7499C2",
            "#AF33AD", "#7499C2", "#E443FF", "#E76178", "#4E31A8", "#E76178", 
            "#00A131", "#00A131", "#E76178", "#F5BA2E", "#F5BA2E", "#E443FF");
ColorScheme_Fill_Manual <- c("#7499C2", "#7499C2", "#AF33AD", "#F5BA2E", "#7499C2", 
            "#AF33AD", "#7499C2", "#E443FF", "#E76178", "#4E31A8", "#E76178", 
            "#00A131", "#00A131", "#E76178", "#F5BA2E", "#F5BA2E", "#E443FF",
            "#7499C2", "#7499C2", "#AF33AD", "#F5BA2E", "#7499C2", 
            "#AF33AD", "#7499C2", "#E443FF", "#E76178", "#4E31A8", "#E76178", 
            "#00A131", "#00A131", "#E76178", "#F5BA2E", "#F5BA2E", "#E443FF");
Fig <- ggplot(data, aes(x=x_New, y=y, fill = x_, alpha = group)) +
            geom_bar(stat = "identity", colour = "#000000", width = 0.8) +
       scale_fill_manual(limits = data$x_, values = ColorScheme_Fill_Manual) +
       scale_alpha_manual(limits = c('Above', 'Below'), values = c(0.3, 1)) +
       labs(x = "Networks", y = expression("Sum of Weights")) + theme_classic() +
       theme(axis.text.x = element_text(size= 27, color = ColorScheme_XAxis),
            axis.text.y = element_text(size= 31, color = "black"),
            axis.title=element_text(size = 31)) +
       theme(legend.position = "none") +
       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
             scale_x_discrete(limits = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                 13, 14, 15, 16, 17),
             labels = c("4", "13", "10", "15", "2", "6", "11", "7", "8", "16", "12",
                 "14", "5", "1", "17", "3", "9"))
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/EFPredictionWeight_Sum_Bar.tiff', width = 19, height = 15, dpi = 600, units = "cm");

