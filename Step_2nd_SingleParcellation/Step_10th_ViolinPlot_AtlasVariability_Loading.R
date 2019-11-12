
library(R.matlab)
library(ggplot2);

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
AtlasFolder = paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis');
Variability_Visualize_Folder = paste0(AtlasFolder, '/Variability_Visualize');
Variability_Mat = readMat(paste0(Variability_Visualize_Folder, '/VariabilityLoading_Median_17SystemMean.mat'));

AtlasLabel_Mat = readMat(paste0(AtlasFolder, '/Group_AtlasLabel.mat'));

AllData = data.frame(Variability = matrix(0, 17734, 1));
AllData$Label = matrix(0, 17734, 1);
for (i in c(1:17734))
{
  AllData$Variability[i] = Variability_Mat$VariabilityLoading.Median.17SystemMean.NoMedialWall[i];
  AllData$Label[i] = AtlasLabel_Mat$sbj.AtlasLabel.NoMedialWall[i];
}
AllData$Variability = as.numeric(AllData$Variability);
AllData$Label = as.factor(AllData$Label);

# Order the network by the median value
MedianValue = matrix(0, 1, 17);
for (i in c(1:17)) {
  ind = which(AllData$Label == i);
  MedianValue[i] = median(AllData$Variability[ind]);
}
# Store network variability for correlation with effect size
writeMat(paste0(ResultsFolder, '/Corr_NetworkVariability_EffectSize/NetworkVariability.mat'), MedianValue = MedianValue);
tmp = sort(MedianValue, index.return = TRUE);

ColorScheme = c("#E76178", "#7499C2", "#F5BA2E", "#7499C2", "#00A131",
                "#AF33AD", "#E443FF", "#E76178", "#E443FF", "#AF33AD",
                "#7499C2", "#E76178", "#7499C2", "#00A131", "#F5BA2E",
                "#4E31A8", "#F5BA2E");
ColorScheme_XText = c("#AF33AD", "#AF33AD", "#7499C2", "#7499C2", "#4E31A8",
                "#7499C2", "#7499C2", "#F5BA2E", "#00A131", "#E76178",
                "#E443FF", "#E443FF", "#E76178", "#E76178", "#F5BA2E",
                "#00A131", "#F5BA2E");
Order = c(10, 6, 4, 2, 16, 11, 13, 15, 5, 12, 7, 9, 8, 1, 17, 14, 3);
ColorScheme_XText_New = ColorScheme_XText;
for (i in c(1:17)) {
  ind = which(Order == i);
  ColorScheme_XText_New[ind] = ColorScheme_XText[i];
}
ggplot(AllData, aes(x = Label, y = Variability, fill = Label, color = Label)) + 
      geom_violin(trim = FALSE) +
      scale_color_manual(values = ColorScheme) + 
      scale_fill_manual(values = ColorScheme) + 
      labs(x = "Networks", y = "Across-subject Variability") + theme_classic() +
      theme(axis.text.x = element_text(size = 22, color = ColorScheme_XText_New),
            axis.text.y = element_text(size = 22, color = "black"),
            axis.title = element_text(size = 22)) +
      theme(axis.text.x = element_text(angle = 22, hjust = 1)) + 
      theme(legend.position = "none") + 
      scale_x_discrete(
            limits = c(10, 6, 4, 2, 16, 11, 13, 15, 5, 12, 7, 9, 8, 1, 17, 14, 3),
            labels = c("12", "11", "2", "6", "14", "7", "8", "17", "16", "9", 
                       "13", "5", "15", "10", "3", "1", "4")) + 
      geom_boxplot(width=0.1, fill = "white");
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revisioni/Figures/Variability_Loading_Mean_Violin.tiff', width = 20, height = 15, dpi = 600, units = "cm");
