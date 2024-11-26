function Z = compute_Z(nView, G)
num = sum(1:(nView-1));
% Total number of view combinations
Z = cell(1,num);

temp = 1;
for p = 1:nView
    for q = p+1:nView
        if p==q
            continue
        end
        Z{1,temp} = abs(G{1,p} - G{1,q});
        temp = temp + 1;
    end
end
        
end