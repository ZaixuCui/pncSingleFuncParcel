
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
InputFolder = [ReplicationFolder '/results/Old/SingleParcellation/Initialization/Input'];
Resultant_InputFolder = [ReplicationFolder '/results/SingleParcellation/Initialization/Input'];

Demogra_Info = csvread([ReplicationFolder '/data/pncSingleFuncParcel_n693_SubjectsIDs.csv'],1);
BBLID = Demogra_Info(:, 1);
ScanID = Demogra_Info(:, 2);

CombinedDataPath = '/cbica/projects/pncSingleFuncParcel/Replication/data/CombinedData';

for i = 1:50
  fid = fopen([InputFolder '/sbjListFile_' num2str(i) '.txt'], 'r');
  num = 0;
  while ~feof(fid)
    num = num + 1;
    dataPath{num} = fgets(fid);
  end
  for j = 1:200
    [ParentFolder, ~, ~] = fileparts(dataPath{j});
    [~, ID_Str, ~] = fileparts(ParentFolder);
    ID{i}(j) = str2num(ID_Str);
  end
  ID{i} = unique(ID{i});
  fclose(fid);
  
  % Create IDs
  Diff_ID = setdiff(ID{i}, BBLID);
  Diff_Num = length(Diff_ID);
  if Diff_Num == 0
    NewID{i} = ID{i};
  else
    NewID{i} = setdiff(ID{i}, Diff_ID);
    for j = 1:Diff_Num
      while 1
        SelectedID = BBLID(randperm(693, 1));
        if ~ismember(SelectedID, NewID{i});
          NewID{i} = [NewID{i} SelectedID]; 
          break;
        end       
      end
    end
  end

  % Create input path file
  sbjListFile_output = [Resultant_InputFolder '/sbjListFile_' num2str(i) '.txt'];
  system(['rm ' sbjListFile_output]);
  for j = 1:length(NewID{i});
    cmd = ['echo ' CombinedDataPath '/' num2str(NewID{i}(j)) '/lh.fs5.sm6.residualised.mgh >> ' sbjListFile_output];
    system(cmd);
    cmd = ['echo ' CombinedDataPath '/' num2str(NewID{i}(j)) '/rh.fs5.sm6.residualised.mgh >> ' sbjListFile_output];
    system(cmd);
  end
end


