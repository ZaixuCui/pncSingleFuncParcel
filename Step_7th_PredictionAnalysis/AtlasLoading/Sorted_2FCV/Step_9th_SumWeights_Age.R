
library(R.matlab)
library(ggplot2)

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results';
PredictionFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLoading');
WeightFolder = paste0(PredictionFolder, '/Weight_Age');
Weight_Age_Mat = readMat(paste0(WeightFolder, '/w_Brain_Age_Matrix.mat'));
Weight_Age_Matrix = Weight_Age_Mat$w.Brain.Age.Matrix;
Weight_Age_Mat = readMat(paste0(WeightFolder, '/w_Brain.mat'));
Weight_Age = Weight_Age_Mat$w.Brain;
NonZeroIndex_Mat = readMat(paste0(PredictionFolder, '/AtlasLoading_All_RemoveZero.mat'));
NonZeroIndex = NonZeroIndex_Mat$NonZeroIndex;

w_Brain_Age_Abs = abs(Weight_Age);
w_Brain_Age_Abs_Sort = sort(w_Brain_Age_Abs, index.return = TRUE);
w_Brain_Age_FirstPercent = Weight_Age;
VertexQuantity = 18715;
w_Brain_Age_FirstPercent_All = matrix(0, 1, 18715*17);
w_Brain_Age_FirstPercent_All[NonZeroIndex] = w_Brain_Age_FirstPercent;

AgeEffect_Folder = paste0(ResultsFolder, '/GamAnalysis/AtlasProbability_17_100_20190422/AgeEffects');
# plot contributing weight for age prediction
data <- data.frame(group = matrix(0, 34, 1));
data$x <- matrix(0, 34, 1);
data$y <- matrix(0, 34, 1);
Pos_Weight <- matrix(0, 1, 17);
for (i in c(1:17)){
    AgeWeight_tmp = w_Brain_Age_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];

    AgeEffect_Folder = paste0(ResultsFolder, '/GamAnalysis/AtlasProbability_17_100_20190422/AgeEffects');
    AgeEffects_Mat = readMat(paste0(AgeEffect_Folder, '/AgeEffect_AtlasProbability_17_Network_', as.character(i), '.mat'));
    AgeZ = AgeEffects_Mat$Gam.Z.Vector.All;
    AgeZ[which(AgeZ < 0)] = -1;
    AgeZ[which(AgeZ > 0)] = 1;
    AgeWeight_tmp = abs(AgeWeight_tmp) * AgeZ;

    data$group[i] = 'Below';
    data$x[i] = i;
    data$y[i] = sum(AgeWeight_tmp[which(AgeWeight_tmp > 0)]);
    data$group[i + 17] = 'Above';
    data$x[i + 17] = i;
    data$y[i + 17] = sum(AgeWeight_tmp[which(AgeWeight_tmp < 0)]);
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
ColorScheme_XAxis <- c("#AF33AD", "#AF33AD", "#7499C2", "#7499C2", "#E76178",  
            "#E76178", "#00A131", "#F5BA2E", "#00A131", "#7499C2", "#F5BA2E",
            "#F5BA2E", "#E443FF", "#EBE297", "#E76178", "#F5BA2E", "#E443FF");
ColorScheme_Fill_Manual <- c("#AF33AD", "#AF33AD", "#7499C2", "#7499C2", "#E76178", 
            "#E76178", "#00A131", "#F5BA2E", "#00A131", "#7499C2", "#F5BA2E",
            "#F5BA2E", "#E443FF", "#EBE297", "#E76178", "#F5BA2E", "#E443FF",
            "#AF33AD", "#AF33AD", "#7499C2", "#7499C2", "#E76178", 
            "#E76178", "#00A131", "#F5BA2E", "#00A131", "#7499C2", "#F5BA2E",
            "#F5BA2E", "#E443FF", "#EBE297", "#E76178", "#F5BA2E", "#E443FF");
Fig <- ggplot(data, aes(x=x_New, y=y, fill = x_, alpha = group)) +
            geom_bar(stat = "identity", colour = "#000000", width = 0.8) +
       scale_fill_manual(limits = data$x_, values = ColorScheme_Fill_Manual) +
       scale_alpha_manual(limits = c('Above', 'Below'), values = c(0.3, 1)) +
       labs(x = "Networks", y = expression("Sum of Weights")) + theme_classic() +
       theme(axis.text.x = element_text(size= 27, color = ColorScheme_XAxis),
            axis.text.y = element_text(size= 33, color = "black"),
            axis.title=element_text(size = 33)) +
       theme(legend.position = "none") +
       theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
       scale_x_discrete(limits = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
                 13, 14, 15, 16, 17),
              labels = c("2", "5", "3", "10", "4", "1", "12", "9", "15", "8", "17", "11", 
                 "6", "7", "14", "16", "13"))
Fig
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/VertexLevel_AgePredictionWeight.tiff', width = 19, height = 15, dpi = 600, units = "cm");
