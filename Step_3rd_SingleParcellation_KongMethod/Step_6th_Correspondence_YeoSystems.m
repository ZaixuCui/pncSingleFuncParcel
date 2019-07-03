
clear
% Correspondence to Yeo 17 systems

SingleParcellation_Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/results/SingleParcellation_Kong';
Parcellation_17_Path = [SingleParcellation_Folder '/WorkingFolder/group/group.mat'];
Parcellation_17_Mat = load(Parcellation_17_Path);
Parcellation_17_Label = [Parcellation_17_Mat.lh_labels, Parcellation_17_Mat.rh_labels];
Unique_LabelID = unique(Parcellation_17_Label);
Unique_LabelID = Unique_LabelID(2:end);
YeoAtlasFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/data/YeoAtlas';
% Yeo 17 systems
[~, Label_lh, ~] = read_annotation([YeoAtlasFolder '/Yeo_17system/lh.Yeo2011_17Networks_N1000.annot']);
[~, Label_rh, ~] = read_annotation([YeoAtlasFolder '/Yeo_17system/rh.Yeo2011_17Networks_N1000.annot']);
Yeo_17system_Label = [Label_lh; Label_rh]';

Correspondence_17Parcels_Yeo17Systems = zeros(1, 17);
for i = 1:length(Unique_LabelID)
    i
    Index = find(Parcellation_17_Label == Unique_LabelID(i));
    % Yeo 17 systems
    Label_Yeo_System17 = Yeo_17system_Label(Index);
    Label_Yeo_System17_Unique = unique(Label_Yeo_System17);
    for j = 1:length(Label_Yeo_System17_Unique)
        number(j) = length(find(Label_Yeo_System17 == Label_Yeo_System17_Unique(j)));
    end
    [~, Max_Index] = max(number);
    Correspondence_17Parcels_Yeo17Systems(Unique_LabelID(i)) = Label_Yeo_System17_Unique(Max_Index);
    clear number;
end
save([SingleParcellation_Folder '/WorkingFolder/Correspondence_Kong17Parcels_Yeo17Systems.mat'], 'Correspondence_17Parcels_Yeo17Systems');
