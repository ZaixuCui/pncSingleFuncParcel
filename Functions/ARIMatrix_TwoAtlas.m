
function ARIMatrix_TwoAtlas(AtlasLabel_Hongming_Path, AtlasLabel_Kong_Path_Cell, RowNum, ResultantFolder)

Hongming_Data_Mat = load(AtlasLabel_Hongming_Path);
Hongming_Label = [Hongming_Data_Mat.sbj_AtlasLabel_lh'; Hongming_Data_Mat.sbj_AtlasLabel_rh'];
NonZeroIndex = find(Hongming_Label ~= 0); % Removing medial wall & low signal regions which we did not use
for i = 1:length(AtlasLabel_Kong_Path_Cell)
  Kong_Data_Mat = load(AtlasLabel_Kong_Path_Cell{i});
  Kong_Label = [Kong_Data_Mat.lh_labels; Kong_Data_Mat.rh_labels];
  ARI(i) = rand_index(Hongming_Label(NonZeroIndex), Kong_Label(NonZeroIndex), 'adjusted');
end
save([ResultantFolder '/ARIMatrix_Row_' num2str(RowNum) '.mat'], 'ARI');
