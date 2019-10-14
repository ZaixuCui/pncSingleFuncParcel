
%
% The script projects the fMRI volume data of the three modalities into surface space (fsaverage5)
% Further brain parcellation will be working on the surface space
%

clear
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
ScanID = Demogra_Info(:, 2);
StructuralFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/data/Structural';

% resting state processing
restingDir = '/data/joy/BBL/studies/pnc/processedData/restbold/restbold_201607151621'
targDir_resting = [DataFolder '/SNR_Mask/RawImage_FS_Smooth/RestingState'];
mkdir(targDir_resting);
for i = 1:length(BBLID)
    i
    Job_Name = ['RestingState_' num2str(i)];
    ImagePath = [DataFolder '/SNR_Mask/RawImage/RestingState/' num2str(BBLID(i)) '.nii.gz'];
    pipeline.(Job_Name).command = 'CZ_FSProjectToSurface_SNR(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5, opt.para6)';
    pipeline.(Job_Name).opt.para1 = restingDir;
    pipeline.(Job_Name).opt.para2 = ImagePath;
    pipeline.(Job_Name).opt.para3 = targDir_resting;
    pipeline.(Job_Name).opt.para4 = BBLID(i);
    pipeline.(Job_Name).opt.para5 = ScanID(i);
    pipeline.(Job_Name).opt.para6 = StructuralFolder;
end

% nback fmri processing
nbackDir = '/data/joy/BBL/studies/pnc/processedData/nback/xcptaskregressed'
targDir_nback = [DataFolder '/SNR_Mask/RawImage_FS_Smooth/NBack'];
mkdir(targDir_nback);
for i = 1:length(BBLID)
    i
    Job_Name = ['nback_' num2str(i)];
    ImagePath = [DataFolder '/SNR_Mask/RawImage/NBack/' num2str(BBLID(i)) '.nii.gz'];
    pipeline.(Job_Name).command = 'CZ_FSProjectToSurface_SNR(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5, opt.para6)';
    pipeline.(Job_Name).opt.para1 = nbackDir;
    pipeline.(Job_Name).opt.para2 = ImagePath;
    pipeline.(Job_Name).opt.para3 = targDir_nback;
    pipeline.(Job_Name).opt.para4 = BBLID(i);
    pipeline.(Job_Name).opt.para5 = ScanID(i);
    pipeline.(Job_Name).opt.para6 = StructuralFolder;
end

% emotion identification fmri processing
idemoDir = '/data/joy/BBL/studies/pnc/processedData/idemo/idemoConnect_201707'
targDir_idemo = [DataFolder '/SNR_Mask/RawImage_FS_Smooth/EmotionIden'];
mkdir(targDir_idemo);
for i = 1:length(BBLID)
    i
    Job_Name = ['idemo_' num2str(i)];
    ImagePath = [DataFolder '/SNR_Mask/RawImage/EmotionIden/' num2str(BBLID(i)) '.nii.gz'];
    pipeline.(Job_Name).command = 'CZ_FSProjectToSurface_SNR(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5, opt.para6)';
    pipeline.(Job_Name).opt.para1 = idemoDir;
    pipeline.(Job_Name).opt.para2 = ImagePath;
    pipeline.(Job_Name).opt.para3 = targDir_idemo;
    pipeline.(Job_Name).opt.para4 = BBLID(i);
    pipeline.(Job_Name).opt.para5 = ScanID(i);
    pipeline.(Job_Name).opt.para6 = StructuralFolder;
end

psom_gb_vars
Pipeline_opt.mode = 'qsub';
Pipeline_opt.qsub_options = '-q all.q,basic.q';
Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.max_queued = 1000;
Pipeline_opt.flag_verbose = 1;
Pipeline_opt.flag_pause = 0;
Pipeline_opt.path_logs = [DataFolder '/SNR_Mask/RawImage_FS_Smooth/logs_FSProjectSurface'];

psom_run_pipeline(pipeline, Pipeline_opt);

