
clear
seed_mesh = 'fsaverage3';
targ_mesh = 'fsaverage5';
out_dir = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision_rep/SingleParcellation_Kong/WorkingFolder';
num_sub = '693';
num_sess = '3';

% Step 1: average profiles
DataFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
CBIG_MSHBM_avg_profiles(seed_mesh,targ_mesh,out_dir,BBLID,num_sess)

% Step 2: Calculating group atlas
  % If using CBICA cluster
project_dir = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
num_clusters = '17';
num_initialization = '1000';
LogFolder = [project_dir '/logs'];
mkdir(LogFolder);
cmd = ['qsub-run --sge "-l h_vmem=300G" matlab -nosplash -nodesktop -r ' ...
       '"addpath(genpath(''' project_dir '/ParcellationMethods''));' ...
       'CBIG_MSHBM_generate_ini_params(''' seed_mesh ''', ''' ...
       target_mesh ''', ''17'', ''1000'', ''' project_dir ''');' ...
       'exit(1)">"' ...
       LogFolder '/log.txt" 2>&1'];
ScriptPath = [LogFolder '/script.sh'];
fid = fopen(ScriptPath, 'w');
fprintf(fid, cmd);
system(['sh ' ScriptPath]);
  % If using CFN cluster
project_dir = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
num_clusters = '17';
num_initialization = '1000';
CBIG_MSHBM_generate_ini_params(seed_mesh, targ_mesh, num_clusters, num_initialization, project_dir);

% Generating the profile list
DataFolder = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/data';
Demogra_Info = csvread([DataFolder '/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
WorkingFolder = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
ProfileFolder = [WorkingFolder '/profiles'];
training_dir = [WorkingFolder '/profile_list/training_set'];
mkdir(training_dir);
system(['rm ' training_dir '/*']);
hemi = {'lh', 'rh'};
Suffix = '_fsaverage5_roifsaverage3.surf2surf_profile.nii.gz';
for i = 1:length(BBLID)
    i
    ID_Str = num2str(BBLID(i));
    for j = 1:2
        % session 1
        cmd = ['echo ' WorkingFolder '/profiles/sub' ID_Str '/sess1/' hemi{j} '.sub' ID_Str '_sess1' Suffix ' >> ' training_dir '/' hemi{j} '_sess1.txt'];
        system(cmd);
        % session 2
        cmd = ['echo ' WorkingFolder '/profiles/sub' ID_Str '/sess2/' hemi{j} '.sub' ID_Str '_sess2' Suffix ' >> ' training_dir '/' hemi{j} '_sess2.txt'];
        system(cmd);
        % session 3
        cmd = ['echo ' WorkingFolder '/profiles/sub' ID_Str '/sess3/' hemi{j} '.sub' ID_Str '_sess3' Suffix ' >> ' training_dir '/' hemi{j} '_sess3.txt'];
        system(cmd);
    end
end

% Estimate priors
clear
Codes_dir = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/Toolbox/ParcellationMethods';
project_dir = '/gpfs/fs001/cbica/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
LogFolder = [project_dir '/logs'];
mkdir(LogFolder);
cmd = ['/cbica/software/external/matlab/R2018A/bin/matlab -nosplash -nodesktop -r ' ...
       '"addpath(genpath(''' Codes_dir '''));' ...
       'CBIG_MSHBM_estimate_group_priors(''' project_dir ''',' ...
       '''fsaverage5'', ''693'', ''3'', ''17'', ''200'');' ...
       'exit(1)">"' ...
       LogFolder '/log.txt" 2>&1'];
ScriptPath = [LogFolder '/script.sh'];
fid = fopen(ScriptPath, 'w');
fprintf(fid, cmd);
system(['qsub -l h_vmem=300G ' ScriptPath]);

% project_dir = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication/Revision/SingleParcellation_Kong/WorkingFolder';
% CBIG_MSHBM_estimate_group_priors(project_dir, 'fsaverage5', '40', '3', '17', '200');

