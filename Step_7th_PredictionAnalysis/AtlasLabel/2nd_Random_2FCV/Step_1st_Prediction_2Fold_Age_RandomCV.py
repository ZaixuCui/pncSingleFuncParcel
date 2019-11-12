
import scipy.io as sio
import numpy as np
import os
import sys
sys.path.append('/cbica/projects/pncSingleFuncParcel/Replication/scripts_Final/Functions');
import Ridge_CZ_Random_CategoricalFeatures

PredictionFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
AtlasLabel_Folder = PredictionFolder + '/AtlasLabel';
# Import data
AtlasLabel_Mat = sio.loadmat(AtlasLabel_Folder + '/AtlasLabel_All.mat');
Behavior_Mat = sio.loadmat(PredictionFolder + '/Behavior_693.mat');
SubjectsData = AtlasLabel_Mat['AtlasLabel_All'];
AgeYears = Behavior_Mat['AgeYears'];
AgeYears = np.transpose(AgeYears);
# Range of parameters
Alpha_Range = np.exp2(np.arange(16) - 10);

FoldQuantity = 2;

ResultantFolder = AtlasLabel_Folder + '/2Fold_RandomCV_Age';
Ridge_CZ_Random_CategoricalFeatures.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, AgeYears, FoldQuantity, Alpha_Range, 100, ResultantFolder, 1, 0, 'all.q');

# Permutation test, 1,000 times
ResultantFolder = AtlasLabel_Folder + '/2Fold_RandomCV_Age_Permutation';
Ridge_CZ_Random_CategoricalFeatures.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, AgeYears, FoldQuantity, Alpha_Range, 1000, ResultantFolder, 1, 1, 'all.q,basic.q')

