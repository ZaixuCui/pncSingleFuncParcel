
import scipy.io as sio
import numpy as np
import os
import sys
sys.path.append('/cbica/projects/pncSingleFuncParcel/Replication/scripts_Final/Functions');
import Ridge_CZ_Random

PredictionFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
AtlasLoading_Folder = PredictionFolder + '/AtlasLoading';
# Import data
AtlasLoading_Mat = sio.loadmat(AtlasLoading_Folder + '/AtlasLoading_All_RemoveZero.mat');
Behavior_Mat = sio.loadmat(PredictionFolder + '/Behavior_693.mat');
SubjectsData = AtlasLoading_Mat['AtlasLoading_All_RemoveZero'];
# Range of parameters
Alpha_Range = np.exp2(np.arange(16) - 10);
FoldQuantity = 2;

Motion = Behavior_Mat['Motion'];
Motion = np.transpose(Motion);
Order = np.argsort(Motion);
SubjectsData = SubjectsData[Order[0:500],];
Motion = Motion[Order[0:500]];
ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Motion_500LeastMotion';
# Store sex, age for the calculation of partial correlation
Sex = Behavior_Mat['Sex'][Order[0:500]];
AgeYears = Behavior_Mat['AgeYears'][Order[0:500]];
Data_Mat = {'AgeYears': AgeYears, 'Sex': Sex, 'Motion': Motion};
sio.savemat(ResultantFolder + '/data.mat', Data_Mat);
# Predict motion
Ridge_CZ_Random.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, Motion, FoldQuantity, Alpha_Range, 100, ResultantFolder, 1, 0, 'all.q');

# Predict age
AgeYears = Behavior_Mat['AgeYears'];
AgeYears = np.transpose(AgeYears);
AgeYears = AgeYears[Order[0:500]];
ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Age_500LeastMotion';
# Store sex, motion for the calculation of partial correlation
sio.savemat(ResultantFolder + '/data.mat', Data_Mat);
# Predict age
Ridge_CZ_Random.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, AgeYears, FoldQuantity, Alpha_Range, 100, ResultantFolder, 1, 0, 'all.q');

# Permutation test, 1,000 times, Motion prediction
ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Permutation_Motion_500LeastMotion';
Ridge_CZ_Random.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, Motion, FoldQuantity, Alpha_Range, 1000, ResultantFolder, 1, 1, 'all.q');

# Permutation test, 1,000 times, Age prediction
ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Permutation_Age_500LeastMotion';
Ridge_CZ_Random.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, AgeYears, FoldQuantity, Alpha_Range, 1000, ResultantFolder, 1, 1, 'all.q');

