function [auc_mid, f1_mid, time_mid, auc, f1, time] = SMOD_run(id_ds, alpha, mu)
% set parameter alpha and mu
% default value: alpha = 0.1, mu = 0.045
if ~exist('alpha', 'var')
    alpha = 0.1;
end

if ~exist('mu', 'var')
    mu = 0.045;
end

% select dataset
% UMIST, Kolod, Liver
if id_ds == 1
    data = 'UMist';
elseif id_ds == 2
    data = 'Kolod';
else
    data = 'Liver-counts';
end

% we repeat 15 times for each ratio
num = 15;
% each dataset has 3/4/5 views
nview = 3;
%nview = 4;
%nview = 5;

fprintf("SMOD test start...\n")


% we have 6 types of ratios i.e.
se = [0.02,0.05,0.08];
outlier_ratios = perms(se);
[rnum, ~] = size(outlier_ratios);
% rnum is number of ratios
% [0.02,0.05,0.08].  id 1
% [0.02,0.08,0.05],  id 2
% [0.05,0.02,0.08],  id 3
% [0.05,0.08,0.02],  id 4
% [0.08,0.02,0.05],  id 5
% [0.08,0.05,0.02],  id 6

% record AUC and F1 on each dataset with 6 types of ratios
auc = zeros(15,rnum);
f1 = zeros(15,rnum);
time = zeros(15,rnum);

% record averaged AUC and averaged F1 on each dataset with 6 types of ratios
auc_mid = zeros(rnum, 1);
f1_mid = zeros(rnum, 1);
time_mid = zeros(rnum, 1);
r1 = num2str(nview);

% loop with 6 types of ratios
for i_idx = 1:rnum
    % get coresponding ratio, i.e. [0.02, 0.05, 0.08]
    ra = outlier_ratios(i_idx,:);
    r = [];
    for j = 1:length(ra)
        r = [r, num2str(ra(j)*100)];
    end
    filename = [data, '_', num2str(num), '_', r, '_', r1, 'view', '.mat'];
	if ~exist(filename, 'file')
        load([data,'.mat'])
        if ~exist('Y', 'var')
            Y = y;
        end
        Construct_ds(X', Y, outlier_ratios(i_idx,:), nview, num, data);
	end
    

    % construct new dataset with three types of outliers.
    % filename = Construct_batch_ds_sv_albation(X', Y, outlier_ratios(i_idx,:), nview, num, type);
    
    fprintf('%s\n', filename);
    
    % load dataset
    load(filename)
    
    % each ratio repeats 15 times
    for i = 1:15
        fprintf('Experiment %d start...\n', i);
        % predeal dataset
        for j = 1:length(X{1,i})
            X{1,i}{1,j} = X{1,i}{1,j}';
            % Normalize
            X{1,i}{1,j} = NormalizeFea(X{1,i}{1,j},1);
        end
        gnd = out_label{1,i};
        
        % run SMOD
        tic;
        [auc_S, f1_S] = SMOD(X{1,i}, gnd, alpha, mu);
        time_S = toc;
        % record auc and f1
        auc(i, i_idx) = auc_S;
        f1(i, i_idx) = f1_S;
        time(i, i_idx) = time_S;
    end
    
    % calculate average of AUC and F1
    auc_mid(i_idx, 1) = mean(auc(:, i_idx));
    f1_mid(i_idx, 1) = mean(f1(:, i_idx));
    time_mid(i_idx, 1) = mean(time(:, i_idx));
    
    fprintf('SMOD: AUC = %f, F1 = %f, time = %f\n', auc_mid(i_idx, 1), f1_mid(i_idx, 1), time_mid(i_idx, 1));
end
fprintf("Misson Completed\n")


