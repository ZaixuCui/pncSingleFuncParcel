
import scipy.io as sio
import numpy as np
import os
import sys
sys.path.append('/data/jux/BBL/projects/pncSingleFuncParcel/Replication/scripts_Final/Functions');
import Ridge_CZ_Sort

PredictionFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/PredictionAnalysis';
AtlasLoading_Folder = PredictionFolder + '/AtlasLoading';
# Import data
AtlasLoading_Mat = sio.loadmat(AtlasLoading_Folder + '/AtlasLoading_All_RemoveZero.mat');
Behavior_Mat = sio.loadmat(PredictionFolder + '/Behavior_693.mat');
Subjects_Data = AtlasLoading_Mat['AtlasLoading_All_RemoveZero'];
F1_Exec_Comp_Res_Accuracy = Behavior_Mat['F1_Exec_Comp_Res_Accuracy'];
F1_Exec_Comp_Res_Accuracy = np.transpose(F1_Exec_Comp_Res_Accuracy);
# Range of parameters
Alpha_Range = np.exp2(np.arange(16) - 10);

ResultantFolder = AtlasLoading_Folder + '/Weight_EFAccuracy';
Ridge_CZ_Sort.Ridge_Weight(Subjects_Data, F1_Exec_Comp_Res_Accuracy, 1, 2, Alpha_Range, ResultantFolder, 1)



