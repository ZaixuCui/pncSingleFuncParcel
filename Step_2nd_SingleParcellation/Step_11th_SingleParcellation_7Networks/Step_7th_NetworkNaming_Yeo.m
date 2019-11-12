
clear
% Correspondence to Yeo 7 systems

SingleParcellation_Folder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_7Networks';
Parcellation_7_Path = [SingleParcellation_Folder '/SingleAtlas_Analysis/Group_AtlasLabel.mat'];
Parcellation_7_Mat = load(Parcellation_7_Path);
Parcellation_7_Label = [Parcellation_7_Mat.sbj_AtlasLabel_lh, Parcellation_7_Mat.sbj_AtlasLabel_rh];
Unique_LabelID = unique(Parcellation_7_Label);
Unique_LabelID = Unique_LabelID(2:end);
YeoAtlasFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/YeoAtlas';
% Yeo 7 systems
[~, Label_lh, ~] = read_annotation([YeoAtlasFolder '/Yeo_7system/lh.Yeo2011_7Networks_N1000.annot']);
[~, Label_rh, names_rh] = read_annotation([YeoAtlasFolder '/Yeo_7system/rh.Yeo2011_7Networks_N1000.annot']);
Yeo_7system_Label = [Label_lh; Label_rh]';

NetworkID = names_rh.table(2:end, 5);
NetworkName = {'Visual', 'Motor', 'DA', 'VA', 'Limbic', 'FP', 'DM'};

Correspondence_7Parcels_Yeo7Systems = zeros(1, 7);
for i = 1:length(Unique_LabelID)
    Index = find(Parcellation_7_Label == Unique_LabelID(i));
    % Yeo 7 systems
    Label_Yeo_System7 = Yeo_7system_Label(Index);
    Label_Yeo_System7_Unique = unique(Label_Yeo_System7);
    for j = 1:length(Label_Yeo_System7_Unique)
        number(j) = length(find(Label_Yeo_System7 == Label_Yeo_System7_Unique(j)));
    end
    [~, Max_Index] = max(number);
    Correspondence_7Parcels_Yeo7Systems(Unique_LabelID(i)) = Label_Yeo_System7_Unique(Max_Index);

    % display the network name
    ind = find(NetworkID == Label_Yeo_System7_Unique(Max_Index));
    disp([num2str(i) ': ' num2str(NetworkName{ind})]);
    clear number;
end
save([SingleParcellation_Folder '/Correspondence_7Parcels_Yeo7Systems.mat'], 'Correspondence_7Parcels_Yeo7Systems');

