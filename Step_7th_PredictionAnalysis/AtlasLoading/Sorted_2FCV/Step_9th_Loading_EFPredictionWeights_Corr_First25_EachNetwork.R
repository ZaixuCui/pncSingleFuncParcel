
library(R.matlab)
library(ggplot2)
library(hexbin)

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results';
AtlasFolder = paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis');
GroupLoadings_Mat = readMat(paste0(AtlasFolder, '/Group_AtlasLoading.mat'));
GroupLoadings = GroupLoadings_Mat$sbj.AtlasLoading.NoMedialWall;

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
w_Brain_EFAccuracy_Abs_FirstPercent = w_Brain_EFAccuracy_Abs;
w_Brain_EFAccuracy_Abs_FirstPercent[Sorted_IDs[1:round(length(Sorted_IDs) * 0.75)]] = 0;
VertexQuantity = 18715;
w_Brain_EFAccuracy_Abs_FirstPercent_All = matrix(0, 1, 18715*17);
w_Brain_EFAccuracy_Abs_FirstPercent_All[NonZeroIndex] = w_Brain_EFAccuracy_Abs_FirstPercent;

FigureFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/Loading_EFAccuracyWeight_First25Percent';
PearCorr_Loading_EFAccuracyWeightAbs = matrix(0, 1, 17);
myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
for (i in c(1:17)){
    Loading_NetworkI = GroupLoadings[, i];
    EFAccuracyWeight_NetworkI = w_Brain_EFAccuracy_Abs_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];
    # Extracting vertices with non-zero weight
    Index = which(EFAccuracyWeight_NetworkI != 0);
    Loading_NetworkI = Loading_NetworkI[Index];
    EFAccuracyWeight_NetworkI = EFAccuracyWeight_NetworkI[Index];
    # Correlation between mean variability and mean absolute effects
    print(paste0('Network_', as.character(i)));
    Correlation = cor.test(Loading_NetworkI, abs(EFAccuracyWeight_NetworkI), method = "pearson");
    print(paste0('Pearson Correlation: ', as.character(Correlation$estimate)));
    PearCorr_Loading_EFAccuracyWeightAbs[i] = Correlation$estimate;
    # plot
    data_EFAccuracy = data.frame(Loading_Data = as.numeric(t(Loading_NetworkI)));
    data_EFAccuracy$EFAccuracyWeight_Data = as.numeric(abs(EFAccuracyWeight_NetworkI));
    hexinfo <- hexbin(data_EFAccuracy$Loading_Data, data_EFAccuracy$EFAccuracyWeight_Data);
    data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
    if (is.element(i, c(5, 12))){
        LegendBreaksInfo = c(4, 8, 12);
    } else if (is.element(i, c(9, 17))) {
        LegendBreaksInfo = c(10, 20);
    } else if (is.element(i, c(1, 7, 8, 10, 11, 15))) {
        LegendBreaksInfo = c(5, 10, 15);
    } else if (is.element(i, c(2))){
        LegendBreaksInfo = c(3, 6);
    } else if (is.element(i, c(3))){
        LegendBreaksInfo = c(4, 8);
    } else if (is.element(i, c(4, 6, 13, 14, 16))) {
        LegendBreaksInfo = c(10, 20, 30);
    }
    ggplot() + 
        geom_hex(data = subset(data_hex), aes(x, y, fill = count), stat = "identity") +
        scale_fill_gradientn(colours = myPalette, breaks = LegendBreaksInfo) +
        geom_smooth(data = data_EFAccuracy, aes(x = Loading_Data, y = EFAccuracyWeight_Data), method = lm, color = "#FFFFFF", linetype = "dashed") +
        theme_classic() + labs(x = "Network Loading", y = "Contribution Weight") +
        theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
        #theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
        #theme(legend.justification = c(1, 1), legend.position = c(1, 0.93)) +
        theme(legend.position = "none") + 
        scale_x_continuous(limits = c(-0.000001, 1), breaks = c(0, 0.5, 1)) +
        scale_y_continuous(limits = c(0.004, 0.0165), breaks = c(0.004, 0.008, 0.012, 0.015));
    FileName = paste0(FigureFolder, '/Network_', as.character(i), '.tiff');
    ggsave(FileName, width = 17, height = 15, dpi = 200, units = "cm");
}

# Spin test for the significance of the correlation between loading and age prediction weight
SpinTest_Folder = paste0(AtlasFolder, '/Group_AtlasLoading_SpinPermutateData/PermuteData');
PearCorr_Loading_EFAccuracyWeightAbs_PValue = matrix(0, 1, 17);
for (i in c(1:17)){
    i
    EFAccuracyWeight_NetworkI = w_Brain_EFAccuracy_Abs_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];
    # Extracting vertices with non-zero weight
    Index = which(EFAccuracyWeight_NetworkI != 0);
    EFAccuracyWeight_NetworkI = EFAccuracyWeight_NetworkI[Index];
    tmpData_Mat = readMat(paste0(SpinTest_Folder, '/AtlasLoading_Network_', as.character(i), '.mat'));
    Loading_NetworkI = tmpData_Mat$bigrot.NoMedialWall;
    Loading_NetworkI = Loading_NetworkI[,Index];
    PearCorr_Loading_EFAccuracyWeightAbs_Permutation = matrix(0, 1, 1000);
    for (j in c(1:1000)){
        print(j);
        Correlation = cor.test(Loading_NetworkI[j,], abs(EFAccuracyWeight_NetworkI), method = "pearson");
        PearCorr_Loading_EFAccuracyWeightAbs_Permutation[j] = Correlation$estimate;
    }
    if (PearCorr_Loading_EFAccuracyWeightAbs[i] < 0) {
      PearCorr_Loading_EFAccuracyWeightAbs_PValue[i] =
          length(which(PearCorr_Loading_EFAccuracyWeightAbs_Permutation < PearCorr_Loading_EFAccuracyWeightAbs[i])) / 1000;
    } else {
      PearCorr_Loading_EFAccuracyWeightAbs_PValue[i] =
          length(which(PearCorr_Loading_EFAccuracyWeightAbs_Permutation > PearCorr_Loading_EFAccuracyWeightAbs[i])) / 1000;
    }
}

