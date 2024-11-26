function [ view_data, out_label, num_outlier, ao_idx, co_idx, ac_idx ] = gen_all_outliers_multiview_DHGD_2022_for_sv_dataset( data, label, outlier_ratios, nview, varargin )

% rng('default')
% rng(0);
[nd, ns] = size(data);

if isempty(varargin)
   dim_per_view = ceil(nd / nview);
   view_dims =  [ones(nview-1,1) * dim_per_view; nd - (nview-1)*dim_per_view]; 
else
   view_dims = varargin{1}; 
end

num_type1 = floor(ns * outlier_ratios(1)+0.5);
num_type23 = floor(ns * (outlier_ratios(2)+outlier_ratios(3))+0.5);
rand_idx = randperm(ns);
type1_idx = rand_idx(1:num_type1);
num_outlier = num_type1 + num_type23;

% disp(type1_idx);

type23_idx = [];
% unselectable = type1_idx;
selectable = rand_idx(num_type1+1:end);

counter = 0;
while counter < num_type23
    cur_idx = selectable(1);
    cur_class = label(cur_idx);
    cc = 2;
    while 1
        next_idx = selectable(cc);
        if cur_class == label(next_idx)
           cc = cc + 1;
        else 
           selectable([1, cc]) = [];
%            unselectable = [unselectable, cur_idx, next_idx];
           counter = counter + 2;
           type23_idx = [type23_idx, [cur_idx; next_idx]];
           break;
        end
    end
end

ao_idx = [];
temp_data = data;
for i = 1:length(type1_idx)
   idx = type1_idx(i);
   temp_data(:,idx) = rand(nd,1);
   ao_idx = [ao_idx, idx];
end

co_idx = [];
ac_idx = [];
num_type2 = floor(size(type23_idx, 2) * outlier_ratios(2) / (outlier_ratios(2)+outlier_ratios(3)) );
swap_view_num = floor(nview/2);
for i = 1:size(type23_idx, 2)  
  view = [1:1:nview];
  swap_view = unidrnd(nview,1,swap_view_num);
  idx1 = type23_idx(1, i);
  idx2 = type23_idx(2, i);
  for j = 1:swap_view_num
    start = sum(view_dims(1:(swap_view(j)-1))) + 1;
    end1 = sum(view_dims(1:(swap_view(j))));
    swp_dat1 = temp_data(start:end1, idx1);
    swp_dat2 = temp_data(start:end1, idx2);
    temp_data(start:end1, idx2) = swp_dat1;
    temp_data(start:end1, idx1) = swp_dat2;
    view(swap_view(j)) = 0;
    if i <= num_type2
        co_idx = [co_idx, idx1, idx2];
    end
  end
  if i > num_type2
      for j1 = 1:length(view)
          if view(j1) == 0
             continue;
          end
      start = sum(view_dims(1:(view(j1)-1))) + 1;
      end1 = sum(view_dims(1:(view(j1))));
      temp_data(start:end1, idx1) = rand((end1-start+1), 1);
      temp_data(start:end1, idx2) = rand((end1-start+1), 1);
      ac_idx = [ac_idx, idx1, idx2];
      end
  end
end

for i = 1:nview
   if  i == 1
     row_range = 1 : view_dims(1);
   else
     row_range = 1 + sum(view_dims(1:i-1)) : sum(view_dims(1:i)); 
   end
   view_data{i} = temp_data(row_range,:);   
end
% 
% view1 = temp_data(1:dim_per_view, :);
% view2 = temp_data(dim_per_view+1:end, :);
% classLabel = label;
out_label = zeros(1, ns);
out_label( [type1_idx'; type23_idx(:)] ) = 1;

% save('Zoo_Type123_demo.mat', 'view1', 'view2', 'label', 'out_label');

end

