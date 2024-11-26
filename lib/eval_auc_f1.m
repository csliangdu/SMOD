function [x1, y1, auc, f1_score] = eval_auc_f1(gnd, score)

% AUC and F1 score
% get auc
[x1, y1, ~, auc] = perfcurve(gnd, score, 0);

% get F1 score
%   case 1 : calculate F1_score from preset num -> point_num * 0.15 as standard
%   case 2 : top k 

% case 1:
score_sort = sort(score);
% sort all scores
select_flag = sum(gnd);
% get outlier_num as flag_index
score_flag = score(select_flag);
% set flag score
predict_label = (score <= repmat(score_flag, length(gnd), 1)) * 1;
% predict label 
[f1_score, ~, ~] = f1_score_test(gnd(:),predict_label(:));

end