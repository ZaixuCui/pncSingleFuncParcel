
import scipy.io as sio
import numpy as np
import os
import sys
sys.path.append('/cbica/projects/pncSingleFuncParcel/Replication/scripts_Final/Functions');
import Ridge_CZ_Random_RegressCovariates

PredictionFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision/PredictionAnalysis';
AtlasLoading_Folder = PredictionFolder + '/AtlasLoading';
# Import data
AtlasLoading_Mat = sio.loadmat(AtlasLoading_Folder + '/AtlasLoading_All_RemoveZero.mat');
Behavior_Mat = sio.loadmat(PredictionFolder + '/Behavior_693.mat');
SubjectsData = AtlasLoading_Mat['AtlasLoading_All_RemoveZero'];
Motion = Behavior_Mat['Motion'];
Motion = np.transpose(Motion);
Covariates = np.zeros((693, 2));
Covariates[:,0] = Behavior_Mat['Motion'];
Covariates[:,1] = Behavior_Mat['Sex'];
# Range of parameters
Alpha_Range = np.exp2(np.arange(16) - 10);

FoldQuantity = 2;

ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Motion_RegressMotion';
Ridge_CZ_Random_RegressCovariates.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, Motion, Covariates, FoldQuantity, Alpha_Range, 100, ResultantFolder, 1, 0, 'all.q');

# Permutation test, 1,000 times
Times_IDRange = np.arange(1000);
ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Permutation_Motion_RegressMotion';
Ridge_CZ_Random_RegressCovariates.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, Motion, Covariates, FoldQuantity, Alpha_Range, 1000, ResultantFolder, 1, 1, 'all.q');

