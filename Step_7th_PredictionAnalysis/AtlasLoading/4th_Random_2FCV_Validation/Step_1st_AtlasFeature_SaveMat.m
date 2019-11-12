
clear
ResultsFolder = '/cbica/projects/pncSingleFuncParcel/Replication/Revision_Zaixu';
PredictionFolder = [ResultsFolder '/PredictionAnalysis'];
Behavior_Mat = load([PredictionFolder '/Behavior_693.mat']);
BBLID = Behavior_Mat.BBLID;

AtlasLabel_Group = load([ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/Group_AtlasLabel.mat']);
AtlasLabel_Group = AtlasLabel_Group.sbj_AtlasLabel_NoMedialWall;
Association_Index = [1 3 5 7 8 9 12 14 15 17];
SomatoSensory_Index = [2 4 6 10 11 13 16]; 
Association_VertexIndex = find(ismember(AtlasLabel_Group, Association_Index));
SomatoSensory_VertexIndex = find(ismember(AtlasLabel_Group, SomatoSensory_Index));

AtlasLoading_Folder = [ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLoading'];
for i = 1:length(BBLID)
    i
    tmp = load([AtlasLoading_Folder '/' num2str(BBLID(i)) '.mat']); 
    sbj_AtlasLoading_NoMedialWall_Association = tmp.sbj_AtlasLoading_NoMedialWall(Association_VertexIndex, Association_Index);
    [rowQuantity, colQuantity] = size(sbj_AtlasLoading_NoMedialWall_Association);
    AtlasLoading_All_Association(i, :) = ...
          reshape(sbj_AtlasLoading_NoMedialWall_Association, 1, rowQuantity * colQuantity);

    sbj_AtlasLoading_NoMedialWall_SomatoSensory = tmp.sbj_AtlasLoading_NoMedialWall(SomatoSensory_VertexIndex, SomatoSensory_Index);
    [rowQuantity, colQuantity] = size(sbj_AtlasLoading_NoMedialWall_SomatoSensory);
    AtlasLoading_All_SomatoSensory(i, :) = ...
          reshape(sbj_AtlasLoading_NoMedialWall_SomatoSensory, 1, rowQuantity * colQuantity);
end
% Association cortex
AtlasLoading_Sum = sum(AtlasLoading_All_Association);
NonZeroIndex = find(AtlasLoading_Sum);
AtlasLoading_All_Association_RemoveZero = AtlasLoading_All_Association(:, NonZeroIndex);
WorkingFolder = [PredictionFolder '/AtlasLoading_RandomCV_Validation'];
mkdir(WorkingFolder);
save([WorkingFolder '/AtlasLoading_All_Association.mat'], 'AtlasLoading_All_Association');
save([WorkingFolder '/AtlasLoading_All_Association_RemoveZero.mat'], ...
          'AtlasLoading_All_Association_RemoveZero', 'NonZeroIndex');
% Visual, motor, auditory networks
AtlasLoading_Sum = sum(AtlasLoading_All_SomatoSensory);
NonZeroIndex = find(AtlasLoading_Sum);
AtlasLoading_All_SomatoSensory_RemoveZero = AtlasLoading_All_SomatoSensory(:, NonZeroIndex);
save([WorkingFolder '/AtlasLoading_All_SomatoSensory.mat'], 'AtlasLoading_All_SomatoSensory');
save([WorkingFolder '/AtlasLoading_All_SomatoSensory_RemoveZero.mat'], ...
          'AtlasLoading_All_SomatoSensory_RemoveZero', 'NonZeroIndex');

