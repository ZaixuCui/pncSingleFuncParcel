
import scipy.io as sio
import numpy as np
import os
import sys
sys.path.append('/cbica/projects/pncSingleFuncParcel/Replication/scripts_Final/Functions');
import Ridge_CZ_LOOCV
import Ridge_CZ_LOOCV_2
import Ridge_CZ_LOOCV_3

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
SubjectsData = SubjectsData[Order[0:100],];
Motion = Motion[Order[0:100]];
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Motion_100LeastMotion';
os.makedirs(ResultantFolder);
# Store sex, age for the calculation of partial correlation
Sex = Behavior_Mat['Sex'][Order[0:100]];
AgeYears = Behavior_Mat['AgeYears'][Order[0:100]];
Data_Mat = {'AgeYears': AgeYears, 'Sex': Sex, 'Motion': Motion};
sio.savemat(ResultantFolder + '/data.mat', Data_Mat);
# Predict motion
Ridge_CZ_LOOCV.Ridge_LOOCV(SubjectsData, Motion, Alpha_Range, ResultantFolder, 1, 0);
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Motion_100LeastMotion_2';
os.makedirs(ResultantFolder);
Ridge_CZ_LOOCV_2.Ridge_LOOCV(SubjectsData, Motion, Alpha_Range, ResultantFolder, 1, 0);
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Motion_100LeastMotion_3';
os.makedirs(ResultantFolder);
Ridge_CZ_LOOCV_3.Ridge_LOOCV(SubjectsData, Motion, Alpha_Range, ResultantFolder, 1, 0);

# Predict age
AgeYears = Behavior_Mat['AgeYears'];
AgeYears = np.transpose(AgeYears);
AgeYears = AgeYears[Order[0:100]];
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Age_100LeastMotion';
os.makedirs(ResultantFolder);
# Store sex, motion for the calculation of partial correlation
sio.savemat(ResultantFolder + '/data.mat', Data_Mat);
# Predict age
Ridge_CZ_LOOCV.Ridge_LOOCV(SubjectsData, AgeYears, Alpha_Range, ResultantFolder, 1, 0);
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Age_100LeastMotion_2';
os.makedirs(ResultantFolder);
Ridge_CZ_LOOCV_2.Ridge_LOOCV(SubjectsData, AgeYears, Alpha_Range, ResultantFolder, 1, 0);
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Age_100LeastMotion_3';
os.makedirs(ResultantFolder);
Ridge_CZ_LOOCV_3.Ridge_LOOCV(SubjectsData, AgeYears, Alpha_Range, ResultantFolder, 1, 0);

Times_IDRange = np.arange(1000);
# Permutation test, 1,000 times, Motion prediction
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Permutation_Motion_100LeastMotion';
Ridge_CZ_LOOCV.Ridge_LOOCV_Permutation(SubjectsData, Motion, Times_IDRange, Alpha_Range, ResultantFolder, 1, 1000, '-q all.q,basic.q');

# Permutation test, 1,000 times, Age prediction
ResultantFolder = AtlasLoading_Folder + '/2Fold_LOOCV_Permutation_Age_100LeastMotion';
Ridge_CZ_LOOCV.Ridge_LOOCV_Permutation(SubjectsData, AgeYears, Times_IDRange, Alpha_Range, ResultantFolder, 1, 1000, '-q all.q,basic.q');

