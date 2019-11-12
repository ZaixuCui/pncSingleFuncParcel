
function Atlas_Homogeneity(AtlasLabel_File_Path, Image_lh_Path, Image_rh_Path, ResultantFile, Flag)
    
    tmp = load(AtlasLabel_File_Path);
    if strcmp(Flag, 'Hongming')
      sbj_AtlasLabel = [tmp.sbj_AtlasLabel_lh tmp.sbj_AtlasLabel_rh];
    elseif strcmp(Flag, 'Kong')
      sbj_AtlasLabel = [tmp.lh_labels' tmp.rh_labels'];
    end

    Data_lh = MRIread(Image_lh_Path);
    Data_lh = squeeze(Data_lh.vol);
    Data_rh = MRIread(Image_rh_Path);
    Data_rh = squeeze(Data_rh.vol);
    Data_All = [Data_lh; Data_rh];
    
    AtlasLabel_Unique = unique(sbj_AtlasLabel);
    AtlasLabel_Unique = setdiff(AtlasLabel_Unique, 0);
    AtlasLabel_Quantity = length(AtlasLabel_Unique);
    for j = 1:AtlasLabel_Quantity
        System_Index{j} = find(sbj_AtlasLabel == AtlasLabel_Unique(j));
        Vertex_Quantity(j) = length(System_Index{j});
        Conn_System = Data_All(System_Index{j}, :)';
        Corr_WithinSystem = corr(Conn_System); % correlation between each two time points
        Corr_WithinSystem(find(eye(size(Corr_WithinSystem)))) = 0; % Assign the diag elements with 0
        Corr_WithinSystem_Avg(j) = sum(sum(Corr_WithinSystem)) / (Vertex_Quantity(j) * Vertex_Quantity(j) - Vertex_Quantity(j)); 
    end
    Conn_Homogeneity = sum(Corr_WithinSystem_Avg .* Vertex_Quantity) / sum(Vertex_Quantity);
    Corr_WithinSystem_Avg = (Corr_WithinSystem_Avg .* Vertex_Quantity) / sum(Vertex_Quantity); % Correct the homogeneity of each system by the parcel size
    save(ResultantFile, 'Corr_WithinSystem_Avg', 'Conn_Homogeneity');

