
function Atlas_Homogeneity_Pipeline(Label_File_Cell, Image_lh_Path_Cell, Image_rh_Path_Cell, ResultantFile_Cell, Flag)

for i = 1:length(Label_File_Cell)
    JobName = ['Homogeneity_' num2str(i)];
    pipeline.(JobName).command = 'Atlas_Homogeneity(opt.Label_File_Path, opt.Image_lh_Path, opt.Image_rh_Path, opt.ResultantFile, opt.Flag)';
    pipeline.(JobName).opt.Label_File_Path = Label_File_Cell{i};
    pipeline.(JobName).opt.Image_lh_Path = Image_lh_Path_Cell{i};
    pipeline.(JobName).opt.Image_rh_Path = Image_rh_Path_Cell{i};
    pipeline.(JobName).opt.ResultantFile = ResultantFile_Cell{i};
    pipeline.(JobName).opt.Flag = Flag;
end

psom_gb_vars

Pipeline_opt.mode = 'qsub';
Pipeline_opt.qsub_options = '-q all.q,basic.q -l h_vmem=5G,s_vmem=5G';
Pipeline_opt.mode_pipeline_manager = 'batch';
Pipeline_opt.max_queued = 1000;
Pipeline_opt.flag_verbose = 1;
Pipeline_opt.flag_pause = 0;
[ParentFolder, ~, ~] = fileparts(ResultantFile_Cell{1});
Pipeline_opt.path_logs = [ParentFolder filesep 'Homogeneity_logs'];

psom_run_pipeline(pipeline,Pipeline_opt);

