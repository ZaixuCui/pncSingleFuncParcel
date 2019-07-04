
library(R.matlab)
library(ggplot2);

ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results';
AtlasFolder = paste0(ResultsFolder, '/SingleParcellation/SingleAtlas_Analysis');
Variability_Visualize_Folder = paste0(AtlasFolder, '/Variability_Visualize');
Variability_Mat = readMat(paste0(Variability_Visualize_Folder, '/VariabilityLoading_Median_17SystemMean.mat'));

AtlasLabel_Mat = readMat(paste0(AtlasFolder, '/Group_AtlasLabel.mat'));

AllData = data.frame(Variability = matrix(0, 18715, 1));
AllData$Label = matrix(0, 18715, 1);
for (i in c(1:18715))
{
  AllData$Variability[i] = Variability_Mat$VariabilityLoading.Median.17SystemMean.NoMedialWall[i];
  AllData$Label[i] = AtlasLabel_Mat$sbj.AtlasLabel.NoMedialWall[i];
}
AllData$Variability = as.numeric(AllData$Variability);
AllData$Label = as.factor(AllData$Label);
ColorScheme = c("#E76178", "#AF33AD", "#7499C2", "#E76178", "#AF33AD", "#E443FF",
                "#EBE297", "#7499C2", "#F5BA2E", "#7499C2", "#F5BA2E", "#00A131",
                "#E443FF", "#E76178", "#00A131", "#F5BA2E", "#F5BA2E");
ColorScheme_XText = c("#AF33AD", "#AF33AD", "#7499C2", "#7499C2", "#EBE297", 
                "#7499C2", "#E443FF", "#00A131", "#E76178", "#E76178",
                "#00A131", "#F5BA2E", "#E76178", "#F5BA2E", "#E443FF", "#F5BA2E", "#F5BA2E");
Order = c(2, 5, 10, 8, 7, 3, 13, 15, 4, 14, 12, 9, 1, 17, 6, 11, 16);
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
            limits = c(2, 5, 10, 8, 7, 3, 13, 15, 4, 14, 12, 9, 1, 17, 6, 11, 16),
            labels = c("5", "7", "14", "15", "13", "10", "1", "6", "8", "17", 
                       "9", "4", "2", "16", "3", "12", "11")) + 
      geom_boxplot(width=0.1, fill = "white");
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/Variability_Violin.tiff', width = 20, height = 15, dpi = 600, units = "cm");
