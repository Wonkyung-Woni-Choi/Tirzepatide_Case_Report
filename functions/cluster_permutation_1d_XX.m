function [zmap, zmapthresh, zmapthresh_correc] = cluster_permutation_1d_XX(cond1,cond2,ncond1,ncond2,pval,tail,cluster_pval,npermutes)
% COND2 - COND1 is the output

% INPUT
% input : trials x timepoints
% ncond1, ncond2: number of trials
% tail: 1 : one tail, 2: two tails
% pval: p-value you want to use (if tail is 1, the same value, if tail is 2, it will be divided by 2 later)
% cluster_pval : percentile from the right

% OUTPUT
% zmap : z-values from permutation testing
% zmapthresh : thresholded (0 if it is not over pval)
% zmapthresh_correc : cluster-corrected chuncks if any

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(cond1,1) ~= ncond1
    warning("Input cond1 is not trials x timepoints!")
end
if size(cond2,1) ~= ncond2
    warning("Input cond1 is not trials x timepoints!")
end

both_conds = cat(1,cond1, cond2); % trials x timepoints

%% perform perm testing
real_condition_mapping = [-ones(1,size(cond1,1)) ones(1,size(cond2,1))];
nTimepoints            = size(both_conds,2);
if tail == 1
    voxel_pval             = pval;
elseif tail == 2
    voxel_pval             = pval/2; % two tails
end
mcc_cluster_pval       = cluster_pval; % percentile from the right, not two tails
n_permutes             = npermutes;

% compute actual t-test of difference (using unequal N and std)
tnum   = squeeze(nanmean(both_conds(real_condition_mapping == 1,:),1) - nanmean(both_conds(real_condition_mapping == -1,:),1));
tdenom = sqrt((nanstd(both_conds(real_condition_mapping==1,:),0,1).^2)./sum(real_condition_mapping==1)...
    + (nanstd(both_conds(real_condition_mapping==-1,:),0,1).^2)./sum(real_condition_mapping==-1));
real_t = tnum./tdenom;

% initialize null hypothesis matrices
permuted_tvals  = zeros(n_permutes,nTimepoints);
% max_pixel_pvals = zeros(n_permutes,2);
max_clust_info  = zeros(n_permutes,1);

% generate pixel-specific null hypothesis parameter distributions
for permi = 1:n_permutes
    % choose how many subj to perm
    %     fake_condition_mapping = real_condition_mapping;
    %     shuf_cntr = [];
    %
    %     for ii = 1:size(both_conds,3)
    %         shuf_cntr = [shuf_cntr randi([0 1],1)];
    %     end
    %     shuffle = logical([shuf_cntr]);
    %     fake_condition_mapping(shuffle) = -1*real_condition_mapping(shuffle);

    % if the number of cond1 and cond2 is different, the ratio of fake
    % condition should be balanced. So I adjusted.
    fake_condition_mapping = ones(1,size(both_conds,1));
    ind_cond1 = randperm(size(cond1,1),round(size(cond1,1)^2/size(both_conds,1)));
    ind_cond2 = size(cond1,1)+randperm(size(cond2,1),size(cond1,1)-length(ind_cond1));
    fake_condition_mapping(ind_cond1) = -1; % choose from cond1 a bit
    fake_condition_mapping(ind_cond2) = -1; % and choose the rest from cond2

    % compute t-map of null hypothesis
    tnum   = squeeze(nanmean(both_conds(fake_condition_mapping == 1,:),1)-nanmean(both_conds(fake_condition_mapping == -1,:),1));
    tdenom = sqrt( ((nanstd(both_conds(fake_condition_mapping==-1,:),0,1).^2)./sum(fake_condition_mapping==-1)) ...
        + ((nanstd(both_conds(fake_condition_mapping==1,:),0,1).^2)./sum(fake_condition_mapping==1)) );
    tmap   = tnum./tdenom;

    % save all permuted values
    permuted_tvals(permi,:,:) = tmap;

    % for cluster correction, apply uncorrected threshold and get maximum cluster sizes
    % here, clusters obtained by parametrically thresholding the t-maps
    % [Note]
    % the degree of freedom will be in between n-1(n: number of samples with condition
    % that has larger standard error of a mean) and n1+n2-2. 
    % exact calculation of DoF with unequal variance : use integer portion
    % of it if it is not an integer
    
    dofnom = ( ((nanstd(both_conds(fake_condition_mapping==-1,:),0,1).^2)./sum(fake_condition_mapping==-1)) ...
        + ((nanstd(both_conds(fake_condition_mapping==1,:),0,1).^2)./sum(fake_condition_mapping==1)) ).^2;
    dofdenom1 = ( ((nanstd(both_conds(fake_condition_mapping==-1,:),0,1).^2)./sum(fake_condition_mapping==-1)) ).^2 ./ ( sum(fake_condition_mapping==-1) - 1 );
    dofdenom2 = ( ((nanstd(both_conds(fake_condition_mapping==1,:),0,1).^2)./sum(fake_condition_mapping==1)) ).^2 ./ ( sum(fake_condition_mapping==1) - 1 );
    exactdof = floor(dofnom./(dofdenom1+dofdenom2));
    if tail == 1
        tmap(tmap<tinv(1-voxel_pval,exactdof))=0;
    elseif tail == 2
        tmap(abs(tmap)<tinv(1-voxel_pval,exactdof))=0;
    end
    %tmap(abs(tmap)<tinv(1-voxel_pval,size(both_conds,3)-2))=0; % more liberal (setting the max dof with assumption that the variance is almost similar)

    % get number of elements in largest supra-threshold cluster
    clustinfo = bwconncomp(tmap);
    max_clust_info(permi) = max([0 cellfun(@numel,clustinfo.PixelIdxList)]); % zero accounts for empty maps

    disp(permi)
end

% compute Z-map
zmap = (real_t-squeeze(nanmean(permuted_tvals,1)))./squeeze(nanstd(permuted_tvals));

% statistical testing
% going from Z value to p value % norminv(1-voxel_pval) is the standard def unit that corrsep to p<.05
% apply cluster-level corrected threshold
zmapthresh = zmap;
% uncorrected pixel-level threshold
if tail == 1
    zmapthresh(zmapthresh<norminv(1-voxel_pval)) = 0;
elseif tail == 2
    zmapthresh(abs(zmapthresh)<norminv(1-voxel_pval)) = 0;
end
% corrected version
zmapthresh_correc = zmapthresh;

% cluster correction
clustinfo  = bwconncomp(zmapthresh);
clust_info = cellfun(@numel,clustinfo.PixelIdxList);
% % MC based on size
clust_size_threshold   = prctile(max_clust_info,100-mcc_cluster_pval*100);
% identify clusters to remove
whichclusters2remove   = find(clust_info < clust_size_threshold);

% remove clusters
for i=1:length(whichclusters2remove)
    zmapthresh_correc(clustinfo.PixelIdxList{whichclusters2remove(i)})=0;
end

end

