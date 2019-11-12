
%
% The script projects the fMRI volume data of the three modalities into surface space (fsaverage5)
% The data was smooth with 6mm kernel size in the surface space
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
targDir_resting = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/RestingState'
for i = 1:length(BBLID)
    i
    Job_Name = ['RestingState_' num2str(i)];
    pipeline.(Job_Name).command = 'CZ_FSProjectToSurface(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5)';
    pipeline.(Job_Name).opt.para1 = restingDir;
    pipeline.(Job_Name).opt.para2 = targDir_resting;
    pipeline.(Job_Name).opt.para3 = BBLID(i);
    pipeline.(Job_Name).opt.para4 = ScanID(i);
    pipeline.(Job_Name).opt.para5 = StructuralFolder;
end

% nback fmri processing
nbackDir = '/data/joy/BBL/studies/pnc/processedData/nback/xcptaskregressed'
targDir_nback = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/NBack'
for i = 1:length(BBLID)
    i
    Job_Name = ['nback_' num2str(i)];
    pipeline.(Job_Name).command = 'CZ_FSProjectToSurface(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5)';
    pipeline.(Job_Name).opt.para1 = nbackDir;
    pipeline.(Job_Name).opt.para2 = targDir_nback;
    pipeline.(Job_Name).opt.para3 = BBLID(i);
    pipeline.(Job_Name).opt.para4 = ScanID(i);
    pipeline.(Job_Name).opt.para5 = StructuralFolder;
end

% emotion identification fmri processing
idemoDir = '/data/joy/BBL/studies/pnc/processedData/idemo/idemoConnect_201707'
targDir_idemo = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data/EmotionIden'
for i = 1:length(BBLID)
    i
    Job_Name = ['idemo_' num2str(i)];
    pipeline.(Job_Name).command = 'CZ_FSProjectToSurface(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5)';
    pipeline.(Job_Name).opt.para1 = idemoDir;
    pipeline.(Job_Name).opt.para2 = targDir_idemo;
    pipeline.(Job_Name).opt.para3 = BBLID(i);
    pipeline.(Job_Name).opt.para4 = ScanID(i);
    pipeline.(Job_Name).opt.para5 = StructuralFolder;
end

psom_gb_vars
Pipeline_opt.mode = 'qsub';
Pipeline_opt.qsub_options = '-q all.q,basic.q';
Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.max_queued = 1000;
Pipeline_opt.flag_verbose = 1;
Pipeline_opt.flag_pause = 0;
Pipeline_opt.path_logs = [DataFolder '/logs_FSProjectSurface'];

psom_run_pipeline(pipeline, Pipeline_opt);

