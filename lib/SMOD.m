function [auc, f1] = SMOD(Xs, gnd, alpha, mu)

% get num of view
nView = length(Xs);
% get num of sample
nSmp = size(Xs{1,1}, 1);

% set parameter alpha and mu with default value
if ~exist('alpha', 'var')
    alpha = 0.1;
end
if ~exist('mu', 'var')
    mu = 0.045;
end

% construct neighbor graph G and k-th nearest neighbor distances w
[G, w] = compute_G_w(Xs, mu);

% compute score s1 by Eq. (5) and normalize it.
ws = cell2mat(w')';
ws2 = reshape(ws, nSmp, nView);
s1 = min(ws2, [], 2);
s1 = s1./max(s1);

% compute Z
Z = compute_Z(nView, G);

% compute Z_hat
Z_hat = zeros(nSmp);
for i = 1:length(Z)
    Z_hat = Z_hat + Z{1,i};
end

% compute G_hat
G_hat = zeros(nSmp,nSmp);
for i = 1:nView
    G_hat = G_hat + G{1,i}./nView;
end
% for 3 views example, 
% G_hat(i,j) = lambda
% lambda = {0, 1/3, 2/3, 1}

% conpute Z_bar
Z_bar = Z_hat .* G_hat;

% compute score s2
s2 = sum(Z_bar);
s2 = s2';
s2 = 1./s2;
s2 = s2 ./ max(s2);

% compute final score s and evaluate by AUC and F1
s = alpha * s1 + (1-alpha) * s2;
[~, ~, auc, f1] = eval_auc_f1(gnd, s);

end