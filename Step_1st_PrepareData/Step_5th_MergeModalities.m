
clear

DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
ScanID = Demogra_Info(:, 2);
RSFolder = [DataFolder '/RestingState'];
NBackFolder = [DataFolder '/NBack'];
EmotionFolder = [DataFolder '/EmotionIden'];
ResultantFolder = [DataFolder '/CombinedData'];

for i = 1:length(BBLID)
    Job_Name = ['MergeModality_' num2str(i)];
    pipeline.(Job_Name).command = 'CZ_Merge3Modality_FS(opt.para1, opt.para2, opt.para3, opt.para4, opt.para5)';
    pipeline.(Job_Name).opt.para1 = RSFolder;
    pipeline.(Job_Name).opt.para2 = NBackFolder;
    pipeline.(Job_Name).opt.para3 = EmotionFolder;
    pipeline.(Job_Name).opt.para4 = BBLID(i);
    pipeline.(Job_Name).opt.para5 = ResultantFolder;
end

psom_gb_vars
Pipeline_opt.mode = 'qsub';
Pipeline_opt.qsub_options = '-q all.q,basic.q';
Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.max_queued = 1000;
Pipeline_opt.flag_verbose = 1;
Pipeline_opt.flag_pause = 0;
Pipeline_opt.path_logs = [ResultantFolder '/logs'];

psom_run_pipeline(pipeline, Pipeline_opt);
