
library(R.matlab)
library(ggplot2)

ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
ResultsFolder = paste0(ReplicationFolder, '/results');
ID_CSV = read.csv(paste0(ReplicationFolder, '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'));
BBLID = ID_CSV$bblid;

Homogeneity_Folder = paste0(ResultsFolder, '/Atlas_Homogeneity_Reliability');
Homogeneity_Hongming = readMat(paste0(Homogeneity_Folder, '/Homogeneity_Hongming_Sig.mat'));

Homogeneity_Hongming_Actual = Homogeneity_Hongming$TS.Homogeneity;
Homogeneity_Hongming_Spin_Avg = rowMeans(Homogeneity_Hongming$TS.Homogeneity.Spin);

Homogeneity_Kong_Folder = paste0(Homogeneity_Folder, '/Homogeneity_Kong');
Homogeneity_HongmingGroupAtlas_Folder = paste0(Homogeneity_Folder, '/Homogeneity_HongmingGroupAtlas');
Homogeneity_Yeo17Atlas_Folder = paste0(Homogeneity_Folder, '/Homogeneity_Yeo17Atlas');
Homogeneity_Kong = matrix(0, 693, 1);
Homogeneity_HongmingGroupAtlas = matrix(0, 693, 1);
Homogeneity_Yeo17Atlas = matrix(0, 693, 1);
for (i in c(1:length(BBLID)))
{
  print(i)
  tmpData = readMat(paste0(Homogeneity_Kong_Folder, '/Homogeneity_Label_', as.character(BBLID[i]), '.mat')); 
  Homogeneity_Kong[i] = tmpData$TS.Homogeneity;
  tmpData = readMat(paste0(Homogeneity_HongmingGroupAtlas_Folder, '/Homogeneity_GroupLabel_', as.character(BBLID[i]), '.mat')); 
  Homogeneity_HongmingGroupAtlas[i] = tmpData$TS.Homogeneity;
  tmpData = readMat(paste0(Homogeneity_Yeo17Atlas_Folder, '/Homogeneity_Yeo17Label_', as.character(BBLID[i]), '.mat'));
  Homogeneity_Yeo17Atlas[i] = tmpData$TS.Homogeneity;
}

Homogeneity <- rbind(t(Homogeneity_Hongming_Actual), Homogeneity_Kong);
Homogeneity <- rbind(Homogeneity, Homogeneity_HongmingGroupAtlas)
Homogeneity <- rbind(Homogeneity, Homogeneity_Yeo17Atlas);
Homogeneity <- rbind(Homogeneity, as.matrix(Homogeneity_Hongming_Spin_Avg));

Label <- rbind(matrix(1, 693, 1), matrix(2, 693, 1));
Label <- rbind(Label, matrix(3, 693, 1));
Label <- rbind(Label, matrix(4, 693, 1));
Label <- rbind(Label, matrix(5, 693, 1));

tmp = data.frame(Homogeneity = Homogeneity, Label = Label);
tmp$Label <- factor(tmp$Label, levels = c(1:5), labels = c("Indiv. NMF", "Indiv. MS-HBM", "Group NMF", "Yeo 17", "Null Distribution"));
Fig <- ggplot(tmp, aes(x = Label, y = Homogeneity)) + geom_jitter(color = "#C0C0C0") + geom_boxplot(alpha = 0.1, lwd = 0.8, outlier.size = NA);
Fig <- Fig + labs(x = "", y = "Within-network Homogeneity") + theme_classic()
Fig <- Fig + theme(axis.text.x = element_text(size = 17, colour = "black"), axis.text.y = element_text(size = 25, colour = "black"), axis.title = element_text(size = 23));
Fig <- Fig + scale_y_continuous(limits = c(0, 0.45), breaks = c(0, 0.1, 0.2, 0.3, 0.4), expand = c(0, 0));
Fig + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/Figures/Homogeneity_hist.tiff', width = 17, height = 15, dpi = 600, units = "cm");
