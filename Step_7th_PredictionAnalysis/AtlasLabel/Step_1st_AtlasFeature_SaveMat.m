
clear
ResultsFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results';
PredictionFolder = [ResultsFolder '/PredictionAnalysis'];
Behavior_Mat = load([PredictionFolder '/Behavior_693.mat']);
BBLID = Behavior_Mat.BBLID;

AtlasLabel_Folder = [ResultsFolder '/SingleParcellation/SingleAtlas_Analysis/FinalAtlasLabel'];
for i = 1:length(BBLID)
    i
    tmp = load([AtlasLabel_Folder '/' num2str(BBLID(i)) '.mat']); 
    AtlasLabel_All(i, :) = tmp.sbj_AtlasLabel_NoMedialWall;
end
mkdir([PredictionFolder '/AtlasLabel']);
save([PredictionFolder '/AtlasLabel/AtlasLabel_All.mat'], 'AtlasLabel_All');
