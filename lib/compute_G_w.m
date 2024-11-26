function [G, w] = compute_G_w(Xs, mu)

% get num of view
nView = length(Xs);
% get num of sample
nSmp = size(Xs{1,1}, 1);

% set parameter mu with default value
if ~exist('nn_ratio', 'var')
    mu = 0.045;
end

% get size of neighborhood
k = ceil(nSmp * mu);

% init G and w
G = cell(1, nView);
w = cell(1, nView);
% G = {G1, G2, ..., G_V} where Gv is n * n
% w = {w1, w2, ..., w_V} where wv is n * 1

% construct G and compute W for each view
for v = 1:nView
    Xi = Xs{1, v};
    % Step 1: construct neighbor graph Gv
    % compute distance matrix Dv
    Dv = EuDist2(Xi, Xi, 0); 
    Dv = Dv + max(max(Dv)) * eye(nSmp);
    [Dv_sort, ~] = sort(Dv, 1, 'ascend');
    Dv_f = Dv_sort(k, :);
    Gv = Dv < repmat(Dv_f, nSmp, 1);
    Gv = Gv - diag(diag(Gv));
    G{1, v} = real(Gv);
    
    % Step 2: Compute k-th nearest neighbor distances wv
    temp = sum(Dv_sort(1:k,:), 1);

    temp = max(temp, 1e-10);

    wv = 1./temp;
    w{1, v} = wv/sum(wv);
end
end