
import scipy.io as sio
import numpy as np
import os
import sys
sys.path.append('/cbica/projects/pncSingleFuncParcel/Replication/scripts_Final/Functions');
import Ridge_CZ_Random

PredictionFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu/PredictionAnalysis';
AtlasLoading_Folder = PredictionFolder + '/AtlasLoading_RandomCV_Validation';
# Import data
AtlasLoading_Mat = sio.loadmat(AtlasLoading_Folder + '/AtlasLoading_All_SomatoSensory_RemoveZero.mat');
Behavior_Mat = sio.loadmat(PredictionFolder + '/Behavior_693.mat');
SubjectsData = AtlasLoading_Mat['AtlasLoading_All_SomatoSensory_RemoveZero'];
AgeYears = Behavior_Mat['AgeYears'];
AgeYears = np.transpose(AgeYears);
# Range of parameters
Alpha_Range = np.exp2(np.arange(16) - 10);

FoldQuantity = 2;

RandIndex_File_List = [''] * 100;
for i in np.arange(100):
  RandIndex_File_List[i] = PredictionFolder + \
                 '/AtlasLoading_RandomCV_Validation/2Fold_RandomCV_Age_Association/' + \
                 'Time_' + str(i) + '/RandIndex.mat';

ResultantFolder = AtlasLoading_Folder + '/2Fold_RandomCV_Age_SomatoSensory';
Ridge_CZ_Random.Ridge_KFold_RandomCV_MultiTimes(SubjectsData, AgeYears, FoldQuantity, Alpha_Range, 100, ResultantFolder, 1, 0, 'all.q', RandIndex_File_List);

