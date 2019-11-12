
library(R.matlab)
library(ggplot2)
library(hexbin)

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
AtlasFolder = paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis');
GroupLoadings_Mat = readMat(paste0(AtlasFolder, '/Group_AtlasLoading.mat'));
GroupLoadings = GroupLoadings_Mat$sbj.AtlasLoading.NoMedialWall;

PredictionFolder = paste0(ResultsFolder, '/PredictionAnalysis/AtlasLoading');
WeightFolder = paste0(PredictionFolder, '/WeightVisualize_Age_RandomCV');
Weight_Age_Mat = readMat(paste0(WeightFolder, '/w_Brain_Age.mat'));
Weight_Age = Weight_Age_Mat$w.Brain.Age;
NonZeroIndex_Mat = readMat(paste0(PredictionFolder, '/AtlasLoading_All_RemoveZero.mat'));
NonZeroIndex = NonZeroIndex_Mat$NonZeroIndex;

w_Brain_Age_Abs = abs(Weight_Age);
w_Brain_Age_Abs_Sort = sort(w_Brain_Age_Abs, index.return = TRUE);
Sorted_IDs = w_Brain_Age_Abs_Sort$ix;
w_Brain_Age_Abs_FirstPercent = w_Brain_Age_Abs;
w_Brain_Age_Abs_FirstPercent[Sorted_IDs[1:round(length(Sorted_IDs) * 0.75)]] = 0;
VertexQuantity = 17734;
w_Brain_Age_Abs_FirstPercent_All = matrix(0, 1, 17734*17);
w_Brain_Age_Abs_FirstPercent_All[NonZeroIndex] = w_Brain_Age_Abs_FirstPercent;

FigureFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Loading_AgeWeight_First25Percent';
dir.create(FigureFolder);
PearCorr_Loading_AgeWeightAbs = matrix(0, 1, 17);
myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
for (i in c(1:17)){
    Loading_NetworkI = GroupLoadings[, i];
    AgeWeight_NetworkI = w_Brain_Age_Abs_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];
    # Extracting vertices with non-zero weight
    Index = which(AgeWeight_NetworkI != 0);
    Loading_NetworkI = Loading_NetworkI[Index];
    AgeWeight_NetworkI = AgeWeight_NetworkI[Index];
    # Correlation between mean variability and mean absolute effects
    print(paste0('Network_', as.character(i)));
    Correlation = cor.test(Loading_NetworkI, abs(AgeWeight_NetworkI), method = "pearson");
    print(paste0('Pearson Correlation: ', as.character(Correlation$estimate)));
    PearCorr_Loading_AgeWeightAbs[i] = Correlation$estimate;
    # plot
    data_Age = data.frame(Loading_Data = as.numeric(t(Loading_NetworkI)));
    data_Age$AgeWeight_Data = as.numeric(abs(AgeWeight_NetworkI));
    hexinfo <- hexbin(data_Age$Loading_Data, data_Age$AgeWeight_Data);
    data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
    if (is.element(i, c(1, 5, 12))){
        LegendBreaksInfo = c(4, 8, 12);
    } else if (is.element(i, c(9, 17))) {
        LegendBreaksInfo = c(10, 20);
    } else if (is.element(i, c(4, 7, 8, 10, 11, 15))) {
        LegendBreaksInfo = c(5, 10, 15);
    } else if (is.element(i, c(2, 3))){
        LegendBreaksInfo = c(10, 20, 30);
    } else if (is.element(i, c(6, 13, 14, 16))) {
        LegendBreaksInfo = c(10, 20, 30);
    }
    ggplot() + 
        geom_hex(data = subset(data_hex), aes(x, y, fill = count), stat = "identity") +
        scale_fill_gradientn(colours = myPalette, breaks = LegendBreaksInfo) +
        geom_smooth(data = data_Age, aes(x = Loading_Data, y = AgeWeight_Data), method = lm, color = "#FFFFFF", linetype = "dashed") +
        theme_classic() + labs(x = "Network Loading", y = "Contribution Weight") +
        theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
        theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
        theme(legend.justification = c(1, 1), legend.position = c(1, 0.93)) +
    #    theme(legend.position = "none") + 
        scale_x_continuous(limits = c(-0.000001, 1.1), breaks = c(0, 0.5, 1)) +
        scale_y_continuous(limits = c(0.003, 0.015), breaks = c(0.003, 0.007, 0.011, 0.015));
    FileName = paste0(FigureFolder, '/Network_', as.character(i), '.tiff');
    ggsave(FileName, width = 17, height = 15, dpi = 200, units = "cm");
}

# Spin test for the significance of the correlation between loading and age prediction weight
SpinTest_Folder = paste0(AtlasFolder, '/Group_AtlasLoading_SpinPermutateData/PermuteData');
PearCorr_Loading_AgeWeightAbs_PValue = matrix(0, 1, 17);
for (i in c(1:17)){
    i
    AgeWeight_NetworkI = w_Brain_Age_Abs_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];
    # Extracting vertices with non-zero weight
    Index = which(AgeWeight_NetworkI != 0);
    AgeWeight_NetworkI = AgeWeight_NetworkI[Index];
    tmpData_Mat = readMat(paste0(SpinTest_Folder, '/AtlasLoading_Network_', as.character(i), '.mat'));
    Loading_NetworkI = tmpData_Mat$bigrot.NoMedialWall;
    Loading_NetworkI = Loading_NetworkI[,Index];
    PearCorr_Loading_AgeWeightAbs_Permutation = matrix(0, 1, 1000);
    for (j in c(1:1000)){
        print(j);
        Correlation = cor.test(Loading_NetworkI[j,], abs(AgeWeight_NetworkI), method = "pearson");
        PearCorr_Loading_AgeWeightAbs_Permutation[j] = Correlation$estimate;
    }
    if (PearCorr_Loading_AgeWeightAbs[i] < 0) {
      PearCorr_Loading_AgeWeightAbs_PValue[i] = 
          length(which(PearCorr_Loading_AgeWeightAbs_Permutation < PearCorr_Loading_AgeWeightAbs[i])) / 1000;
    } else {
      PearCorr_Loading_AgeWeightAbs_PValue[i] =
          length(which(PearCorr_Loading_AgeWeightAbs_Permutation > PearCorr_Loading_AgeWeightAbs[i])) / 1000;
    }

    # plot histogram for network 17
    PermutationData = data.frame(x = t(PearCorr_Loading_AgeWeightAbs_Permutation));
    PermutationData$Line_x = as.numeric(matrix(PearCorr_Loading_AgeWeightAbs[i], 1, 1000));
    PermutationData$Line_y = as.numeric(seq(0,100,length.out=1000));
    ggplot(PermutationData) +
        geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
        geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
        theme_classic() + labs(x = "", y = "") +
        theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
        theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
        scale_y_continuous(expand = c(0, 0)) +
        scale_x_continuous(limits = c(-0.3, 0.35), breaks = c(-0.3, 0, 0.3), labels = c('-0.3', '0', '0.3'))     
    ggsave(paste0(FigureFolder,'/PearCorr_SpinTest_Loading_AgeWeightAbs_Network', as.character(i), '.pdf'), width = 17, height = 15, dpi = 600, units = "cm");
}

