
library(R.matlab)
library(ggplot2)

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results';
PredictionFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLoading');
WeightFolder = paste0(PredictionFolder, '/Weight_EFAccuracy');
Weight_EFAccuracy_Mat = readMat(paste0(WeightFolder, '/w_Brain_EFAccuracy_Matrix.mat'));
Weight_EFAccuracy_Matrix = Weight_EFAccuracy_Mat$w.Brain.EFAccuracy.Matrix;
Weight_EFAccuracy_Mat = readMat(paste0(WeightFolder, '/w_Brain.mat'));
Weight_EFAccuracy = Weight_EFAccuracy_Mat$w.Brain;
NonZeroIndex_Mat = readMat(paste0(PredictionFolder, '/AtlasLoading_All_RemoveZero.mat'));
NonZeroIndex = NonZeroIndex_Mat$NonZeroIndex;

w_Brain_EFAccuracy_Abs = abs(Weight_EFAccuracy);
w_Brain_EFAccuracy_Abs_Sort = sort(w_Brain_EFAccuracy_Abs, index.return = TRUE);
Sorted_IDs = w_Brain_EFAccuracy_Abs_Sort$ix;
w_Brain_EFAccuracy_FirstPercent = Weight_EFAccuracy;
VertexQuantity = 18715;
w_Brain_EFAccuracy_FirstPercent_All = matrix(0, 1, 18715*17);
w_Brain_EFAccuracy_FirstPercent_All[NonZeroIndex] = w_Brain_EFAccuracy_FirstPercent;

EFAccuracyEffect_Folder = paste0(ResultsFolder, '/GamAnalysis/AtlasProbability_17_100_20190422/CognitionEffects');
# plot contributing weight for age prediction
data <- data.frame(group = matrix(0, 34, 1));
data$x <- matrix(0, 34, 1);
data$y <- matrix(0, 34, 1);
Pos_Weight <- matrix(0, 1, 17);
for (i in c(1:17)){
    EFAccuracyWeight_tmp = w_Brain_EFAccuracy_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];

    EFAccuracyEffects_Mat = readMat(paste0(EFAccuracyEffect_Folder, '/CognitionEffect_AtlasProbability_17_Network_', as.character(i), '.mat'));
    EFAccuracyZ = EFAccuracyEffects_Mat$Gam.Z.Cognition.Vector.All;
    EFAccuracyZ[which(EFAccuracyZ < 0)] = -1;
    EFAccuracyZ[which(EFAccuracyZ > 0)] = 1;
    EFAccuracyWeight_tmp = abs(EFAccuracyWeight_tmp) * EFAccuracyZ;

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
ColorScheme_XAxis <- c("#AF33AD", "#7499C2", "#7499C2", "#AF33AD", "#00A131",
            "#F5BA2E", "#EBE297", "#E76178", "#7499C2", "#00A131", "#E76178",
            "#E76178", "#F5BA2E", "#F5BA2E", "#F5BA2E", "#E443FF", "#E443FF"); 
ColorScheme_Fill_Manual <- c("#AF33AD", "#7499C2", "#7499C2", "#AF33AD", "#00A131",
            "#F5BA2E", "#EBE297", "#E76178", "#7499C2", "#00A131", "#E76178", 
            "#E76178", "#F5BA2E", "#F5BA2E", "#F5BA2E", "#E443FF", "#E443FF",
            "#AF33AD", "#7499C2", "#7499C2", "#AF33AD", "#00A131",
            "#F5BA2E", "#EBE297", "#E76178", "#7499C2", "#00A131", "#E76178", 
            "#E76178", "#F5BA2E", "#F5BA2E", "#F5BA2E", "#E443FF", "#E443FF");
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
             labels = c("2", "10", "3", "5", "12", "9", "7", "4", "8", "15", "1",
                 "14", "11", "17", "16", "6", "13"))
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/VertexLevel_EFPredictionWeight.tiff', width = 19, height = 15, dpi = 600, units = "cm");

