function filename = Construct_ds(ds, Y, ratio, nview, num, data)
X = cell(1, num);
out_label = cell(1,num);
ao_idx = cell(1,num);
co_idx = cell(1,num);
ac_idx = cell(1,num);
for i = 1:num
    X{1,i} = cell(1, nview);
    out_label{1,i} = zeros(size(Y'));
    [ X{1,i}, out_label{1,i}, ~, a, c, ac ] = gen_all_outliers(ds, Y, ratio, nview);
    % for glass
    ao_idx{1, i} = a;
    co_idx{1, i} = c;
    ac_idx{1, i} = ac;
end

r = [];
for i = 1:length(ratio)
    r = [r, num2str(ratio(i)*100)];
end
r1 = num2str(nview);
filename = [data, '_',num2str(num),'_',r,'_',r1,'view','.mat'];
save (filename, 'X', 'out_label', 'Y', 'ao_idx', 'co_idx', 'ac_idx')
    