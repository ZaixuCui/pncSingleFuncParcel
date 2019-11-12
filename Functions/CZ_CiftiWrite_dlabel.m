
function CZ_CiftiWrite_dlabel(lh_data, rh_data, lh_gifti_Path, rh_gifti_Path, cifti_Path)

% left hemi
V_lh = gifti;
V_lh.cdata = lh_data;
V_lh_File = lh_gifti_Path;
save(V_lh, V_lh_File);
% right hemi
V_rh = gifti;
V_rh.cdata = rh_data;
V_rh_File = rh_gifti_Path;
save(V_rh, V_rh_File);
% Convert into cifti file
cmd = ['wb_command -cifti-create-dense-scalar ' cifti_Path ' -left-metric ' ...
       lh_gifti_Path ' -right-metric ' rh_gifti_Path];
system(cmd);


