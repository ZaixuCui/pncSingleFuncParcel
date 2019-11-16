
clear
ReplicationFolder = '/data/jux/BBL/projects/pncSingleFuncParcel/Replication';
% load data of cortical organization
EvoEtc_DataFolder = [ReplicationFolder '/data/EvoMyelinCBF'];
% loading evo
Evo_rh_gifti = gifti([EvoEtc_DataFolder '/EvolutionaryExpansion/rh.Hill2010_evo_fsaverage5.func.gii']);
Evo_rh = Evo_rh_gifti.cdata;
% loading myelin
Myelin_lh_gifti = gifti([EvoEtc_DataFolder '/Myelin/MyelinMap.lh.fsaverage5.func.gii']);
Myelin_lh = Myelin_lh_gifti.cdata;
Myelin_rh_gifti = gifti([EvoEtc_DataFolder '/Myelin/MyelinMap.rh.fsaverage5.func.gii']);
Myelin_rh = Myelin_rh_gifti.cdata;
% loading mean CBF
MeanCBF_lh_gifti = gifti([EvoEtc_DataFolder '/MeanCBF/lh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_lh = MeanCBF_lh_gifti.cdata;
MeanCBF_rh_gifti = gifti([EvoEtc_DataFolder '/MeanCBF/rh.MeanCBF.fsaverage5.func.gii']);
MeanCBF_rh = MeanCBF_rh_gifti.cdata;

WorkingFolder = [ReplicationFolder '/Revision/Corr_EvoMyelinCBF'];
WorkingFolder_MyelinCBF = [WorkingFolder '/BetweenCorr_MyelinCBF'];
mkdir(WorkingFolder_MyelinCBF);
save([WorkingFolder_MyelinCBF '/Myelin.mat'], 'Myelin_lh', 'Myelin_rh');
save([WorkingFolder_MyelinCBF '/MeanCBF.mat'], 'MeanCBF_lh', 'MeanCBF_rh');
save([WorkingFolder_MyelinCBF '/Evo.mat'], 'Evo_rh');

