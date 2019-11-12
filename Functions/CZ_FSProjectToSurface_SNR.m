
function CZ_FSProjectToSurface(rawDir, ImagePath, targDir, BBLID, ScanID, StructuralFSFolder)

BBLID_Str = num2str(BBLID);
ScanID_Str = num2str(ScanID);
mkdir([targDir '/' BBLID_Str '/coreg']);
mkdir([targDir '/' BBLID_Str '/surf']);
% registering native functional volume to native T1 volume
disp(['start registering subject ' BBLID_Str]);
cmd = ['export SUBJECTS_DIR="' StructuralFSFolder '"; bbregister --s ' BBLID_Str ' --mov ' rawDir '/' BBLID_Str '/*' ScanID_Str '/prestats/*referenceVolumeBrain.nii.gz --reg ' targDir '/' BBLID_Str '/coreg/fs_ep2struct_fsl.dat --init-fsl --bold >> ' targDir '/' BBLID_Str '/coreg/' BBLID_Str '_coreg.log 2>&1'];
system(cmd);
disp(['complete registering subject ' BBLID_Str]);

hemi = {'lh', 'rh'};
for j = 1:2
    % project volume to the surface
    disp(['start vol2surf projection for subject ' BBLID_Str ' on ' hemi{j}]);
    cmd = ['export SUBJECTS_DIR="' StructuralFSFolder '"; mri_vol2surf --mov ' ImagePath ' --reg ' targDir '/' BBLID_Str '/coreg/fs_ep2struct_fsl.dat --hemi ' hemi{j} ' --o ' targDir '/' BBLID_Str '/surf/' hemi{j} '.sm6.residualised.mgh --projfrac 0.5 --interp trilinear --noreshape --surf-fwhm 6 >> ' targDir '/' BBLID_Str '/surf/' BBLID_Str '_projection.log 2>&1'];
    system(cmd);
    disp(['complete vol2surf projection for subject ' num2str(BBLID) ' on ' hemi{j}]);

    % down-sample the surface to fsaverage5
    disp(['start surf2surf resampling for subject ' num2str(BBLID) ' on ' hemi{j}]);
    cmd = ['export SUBJECTS_DIR="' StructuralFSFolder '"; mri_surf2surf --srcsubject ' BBLID_Str ' --srcsurfval ' targDir '/' BBLID_Str '/surf/' hemi{j} '.sm6.residualised.mgh --trgsubject ico --trgicoorder 5 --trgsurfval ' targDir '/' BBLID_Str '/surf/' hemi{j} '.fs5.sm6.residualised.mgh --hemi ' hemi{j} ' >> ' targDir '/' BBLID_Str '/surf/' BBLID_Str '_projection.log 2>&1'];
    system(cmd);
    disp(['complete surf2surf resampling for subject ' num2str(BBLID) ' on ' hemi{j}]);
end

