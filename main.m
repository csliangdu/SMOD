%% run SMOD
% select dataset
id_ds = 3;
% 1: UMIST, 2: Kolod, 3: Liver

% set parameter alpha and mu
alpha = 0.1;
mu = 0.045;

% run SMOD main experiment, record all auc and f1
% compute average AUC and F1
[auc_mid, f1_mid, time_mid, auc, f1, time] = SMOD_run(id_ds, alpha, mu);





