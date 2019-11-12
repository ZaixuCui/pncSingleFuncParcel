
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
w_Brain_Age_FirstPercent = Weight_Age;
w_Brain_Age_FirstPercent[Sorted_IDs[1:round(length(Sorted_IDs) * 0.75)]] = 0;
VertexQuantity = 17734;
w_Brain_Age_FirstPercent_All = matrix(0, 1, 17734*17);
w_Brain_Age_FirstPercent_All[NonZeroIndex] = w_Brain_Age_FirstPercent;

FigureFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/Figures/Loading_AgeWeight_First25Percent_New';
dir.create(FigureFolder);
PearCorr_Loading_AgeWeightPos = matrix(0, 1, 17);
PearCorr_Loading_AgeWeightPos_PValue = matrix(0, 1, 17);
myPalette <- c("#333333", "#4C4C4C", "#666666", "#7F7F7F", "#999999", "#B2B2B2", "#CCCCCC");
AgeEffect_Folder = paste0(ResultsFolder, '/GamAnalysis/AtlasLoading/AgeEffects');
for (i in c(1:17)){
    Loading_NetworkI = GroupLoadings[, i];
    AgeWeight_NetworkI = w_Brain_Age_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];
    
    Index = which(AgeWeight_NetworkI > 0);
    Loading_NetworkI = Loading_NetworkI[Index];
    AgeWeight_NetworkI = AgeWeight_NetworkI[Index];
    
    # Correlation between mean variability and mean absolute effects
    print(paste0('Network_', as.character(i)));
    Correlation = cor.test(Loading_NetworkI, abs(AgeWeight_NetworkI), method = "pearson");
    print(paste0('Pearson Correlation: ', as.character(Correlation$estimate)));
    PearCorr_Loading_AgeWeightPos[i] = Correlation$estimate;

    # Permutation
    PearCorr_Loading_AgeWeightPos_Permutation = c(1:10000);
    for (j in c(1:10000)){
      ind = sample(c(1:length(AgeWeight_NetworkI)), length(AgeWeight_NetworkI));
      AgeWeight_NetworkI_Rand = AgeWeight_NetworkI[ind];
      Correlation = cor.test(Loading_NetworkI, abs(AgeWeight_NetworkI_Rand), method = "pearson");
      PearCorr_Loading_AgeWeightPos_Permutation[j] = Correlation$estimate;
    }
    if (PearCorr_Loading_AgeWeightPos[i] < 0) {
      PearCorr_Loading_AgeWeightPos_PValue[i] =
          length(which(PearCorr_Loading_AgeWeightPos_Permutation < PearCorr_Loading_AgeWeightPos[i])) / 10000;
    } else {
      PearCorr_Loading_AgeWeightPos_PValue[i] =
          length(which(PearCorr_Loading_AgeWeightPos_Permutation > PearCorr_Loading_AgeWeightPos[i])) / 10000;
    }

    # plot
    data_Age = data.frame(Loading_Data = as.numeric(t(Loading_NetworkI)));
    data_Age$AgeWeight_Data = as.numeric(abs(AgeWeight_NetworkI));
    hexinfo <- hexbin(data_Age$Loading_Data, data_Age$AgeWeight_Data);
    data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
    if (is.element(i, c(1, 7, 14, 16))){
        YLimits = c(0.003, 0.0125);  YBreaks = c(0.003, 0.007, 0.011);
    } else if (is.element(i, c(9, 10))){
        YLimits = c(0.003, 0.0115); YBreaks = c(0.003, 0.007, 0.011);
    } else if (is.element(i, c(2, 3, 5, 6, 11, 12, 13, 15))){
        YLimits = c(0.003, 0.0106);  YBreaks = c(0.003, 0.006, 0.009);
    } else if (is.element(i, c(8))){
        YLimits = c(0.003, 0.009); YBreaks = c(0.003, 0.006, 0.009);
    } else if (is.element(i, c(4))){
        YLimits = c(0.003, 0.007);   YBreaks = c(0.003, 0.006);
    } else {
        YLimits = c(0.003, 0.015); YBreaks = c(0.003, 0.007, 0.011, 0.015);
    }
    ggplot() +
        geom_hex(data = subset(data_hex), aes(x, y, fill = count), stat = "identity") +
        scale_fill_gradientn(colours = myPalette) +
        geom_smooth(data = data_Age, aes(x = Loading_Data, y = AgeWeight_Data), method = lm, color = "#FFFFFF", linetype = "dashed") +
        theme_classic() + labs(x = "Network Loading", y = "Contribution Weight") +
        theme(axis.text=element_text(size=35, color='black'), axis.title=element_text(size=35), aspect.ratio = 1) +
#        theme(legend.text = element_text(size = 40), legend.title = element_text(size = 40)) +
#        theme(legend.justification = c(1, 1), legend.position = LegendPosition) +
        theme(legend.position = 'none') + 
        scale_x_continuous(limits = c(-0.000001, 1.1), breaks = c(0, 0.5, 1)) +
        scale_y_continuous(limits = YLimits, breaks = YBreaks);
    FileName = paste0(FigureFolder, '/Network_', as.character(i), '.tiff');
    ggsave(FileName, width = 17, height = 15, dpi = 200, units = "cm");
}

PearCorr_Loading_AgeWeightPos_PValue_Bonf = p.adjust(PearCorr_Loading_AgeWeightPos_PValue, 'bonferroni');
print(PearCorr_Loading_AgeWeightPos);
print(PearCorr_Loading_AgeWeightPos_PValue);
print(PearCorr_Loading_AgeWeightPos_PValue_Bonf);
print(length(which(PearCorr_Loading_AgeWeightPos<0 & PearCorr_Loading_AgeWeightPos_PValue_Bonf<0.05)));
print(length(which(PearCorr_Loading_AgeWeightPos>0 & PearCorr_Loading_AgeWeightPos_PValue_Bonf<0.05)));

# plot for network 17 for main figure 5
i = 17;
Loading_NetworkI = GroupLoadings[, i];
AgeWeight_NetworkI = w_Brain_Age_FirstPercent_All[((i-1)*VertexQuantity+1):(i*VertexQuantity)];
# Extracting vertices with non-zero weight and positive relationship between age and loading 
Index = which(AgeWeight_NetworkI > 0);
Loading_NetworkI = Loading_NetworkI[Index];
AgeWeight_NetworkI = AgeWeight_NetworkI[Index];

# Correlation between mean variability and mean absolute effects
print(paste0('Network_', as.character(i)));
Correlation = cor.test(Loading_NetworkI, abs(AgeWeight_NetworkI), method = "pearson");
print(paste0('Pearson Correlation: ', as.character(Correlation$estimate)));
PearCorr_Loading_AgeWeightPos[i] = Correlation$estimate;

# Permutation
PearCorr_Loading_AgeWeightPos_Permutation = c(1:10000);
for (j in c(1:10000)){
   ind = sample(c(1:length(AgeWeight_NetworkI)), length(AgeWeight_NetworkI));
   AgeWeight_NetworkI_Rand = AgeWeight_NetworkI[ind];
   Correlation = cor.test(Loading_NetworkI, abs(AgeWeight_NetworkI_Rand), method = "pearson");
   PearCorr_Loading_AgeWeightPos_Permutation[j] = Correlation$estimate;
}
if (PearCorr_Loading_AgeWeightPos[i] < 0) {
   PearCorr_Loading_AgeWeightPos_PValue[i] =
      length(which(PearCorr_Loading_AgeWeightPos_Permutation < PearCorr_Loading_AgeWeightPos[i])) / 10000;
} else {
   PearCorr_Loading_AgeWeightPos_PValue[i] =
      length(which(PearCorr_Loading_AgeWeightPos_Permutation > PearCorr_Loading_AgeWeightPos[i])) / 10000;
}

data_Age = data.frame(Loading_Data = as.numeric(t(Loading_NetworkI)));
data_Age$AgeWeight_Data = as.numeric(abs(AgeWeight_NetworkI));
hexinfo <- hexbin(data_Age$Loading_Data, data_Age$AgeWeight_Data);
data_hex <- data.frame(hcell2xy(hexinfo), count = hexinfo@count);
LegendBreaksInfo = c(5, 10);
YLimits = c(0.003, 0.015);
YBreaks = c(0.003, 0.007, 0.011, 0.015);
ggplot() +
    geom_hex(data = subset(data_hex), aes(x, y, fill = count), stat = "identity") +
    scale_fill_gradientn(colours = myPalette, breaks = LegendBreaksInfo) +
    geom_smooth(data = data_Age, aes(x = Loading_Data, y = AgeWeight_Data), method = lm, color = "#FFFFFF", linetype = "dashed") +
    theme_classic() + labs(x = "Network Loading", y = "Contribution Weight") +
    theme(axis.text=element_text(size=30, color='black'), axis.title=element_text(size=30), aspect.ratio = 1) +
    theme(legend.text = element_text(size = 30), legend.title = element_text(size = 30)) +
    theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
    #theme(legend.position = 'none') +
    scale_x_continuous(limits = c(-0.000001, 1.1), breaks = c(0, 0.5, 1)) +
    scale_y_continuous(limits = YLimits, breaks = YBreaks);
FileName = paste0(FigureFolder, '/Network_', as.character(i), '_MainFigure.tiff');
ggsave(FileName, width = 17, height = 15, dpi = 200, units = "cm");

# plot for permutation testing
Break_Min = -0.2;
Break_Max = 0.2;
PermutationData = data.frame(x = PearCorr_Loading_AgeWeightPos_Permutation);
PermutationData$Line_x = as.numeric(matrix(PearCorr_Loading_AgeWeightPos[i], 1, 10000));
PermutationData$Line_y = as.numeric(seq(0,1670,length.out=10000));
Range_Min = min(PearCorr_Loading_AgeWeightPos[i], min(PearCorr_Loading_AgeWeightPos_Permutation, -0.2));
Range_Max = max(PearCorr_Loading_AgeWeightPos[i], max(PearCorr_Loading_AgeWeightPos_Permutation, 0.2));
ggplot(PermutationData) +
    geom_histogram(aes(x = x), bins = 30, color = "#999999", fill = "#999999") +
    geom_line(aes(x = Line_x, y = Line_y, group = 1), size = 1, color = 'red', linetype = "dashed") +
    theme_classic() + labs(x = "", y = "") +
    theme(axis.text=element_text(size=80, color='black'), aspect.ratio = 1) +
    theme(axis.line.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(limits = c(Range_Min-0.01, Range_Max+0.01), breaks = c(Break_Min, 0, Break_Max), labels = c(as.character(Break_Min), '0', as.character(Break_Max)))
ggsave(paste0(FigureFolder,'/PearCorr_SpinTest_Loading_AgeWeightPos_Network17_MainFigure.pdf'), width = 17, height = 15, dpi = 600, units = "cm");

