
clear
ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision';
PredictionFolder = [ResultsFolder '/PredictionAnalysis'];
Behavior_Mat = load([PredictionFolder '/Behavior_693.mat']);
BBLID = Behavior_Mat.BBLID;

AtlasLoading_Folder = [ResultsFolder '/SingleParcellation_7Networks/SingleAtlas_Analysis/FinalAtlasLoading'];
for i = 1:length(BBLID)
    i
    tmp = load([AtlasLoading_Folder '/' num2str(BBLID(i)) '.mat']); 
    sbj_AtlasLoading_NoMedialWall_Tmp = tmp.sbj_AtlasLoading_NoMedialWall;
    [rowQuantity, colQuantity] = size(sbj_AtlasLoading_NoMedialWall_Tmp);
    AtlasLoading_All(i, :) = reshape(sbj_AtlasLoading_NoMedialWall_Tmp, 1, rowQuantity * colQuantity);
end
AtlasLoading_Sum = sum(AtlasLoading_All);
NonZeroIndex = find(AtlasLoading_Sum);
AtlasLoading_All_RemoveZero = AtlasLoading_All(:, NonZeroIndex);
mkdir([PredictionFolder '/AtlasLoading_7Networks']);
save([PredictionFolder '/AtlasLoading_7Networks/AtlasLoading_All.mat'], 'AtlasLoading_All');
save([PredictionFolder '/AtlasLoading_7Networks/AtlasLoading_All_RemoveZero.mat'], 'AtlasLoading_All_RemoveZero', 'NonZeroIndex');

