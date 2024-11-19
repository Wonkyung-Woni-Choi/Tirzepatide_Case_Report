function  [p_val] = perm_mdiff(vec1,vec2,nperm)

    ncond1 = length(vec1);
    ncond2 = length(vec2);
    
    % vec 1,2: should be row vectors
    if size(vec1,1) ~= 1
        vec1 = vec1';
    end

    if size(vec2,1) ~= 1
        vec2 = vec2';
    end
    real_label = [-ones(1,ncond1) ones(1,ncond2)];
    both_conds = cat(2,vec1, vec2);

    true_diff = mean(both_conds(:,real_label==1)) - mean(both_conds(:,real_label==-1));


    permuted_vals = zeros(1,nperm);
    for permi = 1:nperm
    % permute conditions
    % For a very imbalanced case
    fake_label = ones(1,size(both_conds,2)); % first set to the same conditions for all
    % Take into account the ratio btw diff conds
    portion_cond1 = randperm(ncond1,round(ncond1*ncond1/size(both_conds,2)));
    portion_cond2 = ncond1+randperm(ncond2,ncond1-length(portion_cond1));
    temp = cat(2,portion_cond1,portion_cond2);
    fake_label(temp) = -1;

    % permuted difference
    permuted_vals(1,permi)  = mean(both_conds(fake_label==1))-mean(both_conds(fake_label==-1));
    end
    % compute Z-map
    mean_h0 = mean(permuted_vals); % default dim = 1
    std_h0 = std(permuted_vals);
    zvalue = (true_diff-mean_h0)./std_h0;
    
    %histogram(permuted_vals);ylim([0, 1000])
    if normcdf(abs(zvalue)) == 1
        p_val = 2*(normcdf(abs(zvalue),'upper')); % two tails
    else
        p_val = 2*(1-normcdf(abs(zvalue))); % two tails
    end
end