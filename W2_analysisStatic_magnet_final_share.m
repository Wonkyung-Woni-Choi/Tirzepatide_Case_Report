% analysis on static power

clear; close all; clc;
set(0,'DefaultFigureVisible','off');
set(groot,'defaultAxesFontSize',15)
addpath('');

%%%%%%%%%%%%%%%%%%%%%%%%%
patient = "";
ch = 3;
stim = 0;
newmon = 1;

magnet = 1;
artifact_preclean = 0;

showplot = 0; % 1 - show, 0 - not show
saveplot = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%
ver = ''; 
cate = '';
mon = '';
stimannot = '';

% uptodate
uptodate = "";

% save directory
if isequal(patient,"")
    target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
else
    target = sprintf("New%s_magnet_v%s%s_mon%s",patient,ver,stimannot,mon);
end
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,target);
% sub directory
subtarget = "static";
dir_target = fullfile(dir_target,subtarget);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

% load data
dir_data = sprintf("",patient);
varname = sprintf("%s_magnet_fieldtrip_%s",patient,uptodate);
dir_fullsesdatavar = fullfile(dir_data, varname);

% analize
epoch_len = 5; %sec - subtrial length
wf_static_analysis_cr(patient,target,dir_data,dir_target,dir_fullsesdatavar,ch,stim,magnet,artifact_preclean,showplot,saveplot,epoch_len);
%patient,target,dir_data,dir_target,dir_fullsesdatavar,ch,stim,magnet,artifact_preclean,showplot,saveplot,epoch_len

%end
%% get idxs
clear; clc; close all;
set(0,'DefaultFigureVisible','on');
addpath('');

%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
patient = "";
ch = 3;
stim = 0;
newmon = 1; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ver = '';
mon = '';
stimannot = '';

% uptodate
uptodate = "stimnewmoncrav_rev2";
apply_specific_ind = 0;
dose_ind_cond = []; 
doses = [""];
conditions = [];

% save directory
if isequal(patient,"")
    target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
else
    target = sprintf("New%s_magnet_v%s%s_mon%s",patient,ver,stimannot,mon);
end
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,target);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

% load analysis result
dir_data = sprintf("",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);

% load data - only trial nums
dir_data = sprintf("",patient);
varname = sprintf("%s_magnet_fieldtrip_%s",patient,uptodate);
dir_fullsesdatavar = fullfile(dir_data, varname);
load(dir_fullsesdatavar,"trial_nums");
% calculate trial numbers vector 
temp = trial_nums;
ncond = size(trial_nums,2);
trial_nums = zeros(1,ncond);
for i = 1:ncond
    trial_nums(1,i) = temp{2,i};
end

% loop to get index vectors
if isequal(patient,"")
    if ~stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    elseif stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    end
elseif isequal(patient,"") 
    if ~stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    elseif stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    end    
elseif isequal(patient,"")
    if ~stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    elseif stim
    end
end

% remove month 1
if isequal(patient,"") 
    if apply_specific_ind
        idx_cond1_dose{1,1} = idx_cond1_dose{1,1}(1,specific_ind(1)+1:end);
        idx_control_dose{1,1} = idx_control_dose{1,1}(1,specific_ind(3)+1:end);    
    end
end
if isequal(patient,"")
    if apply_specific_ind
        % remove the exact dose
        tem = idx_cond1_dose{1,1};
        tem(bad_trials_con1) = [];
        idx_cond1_dose{1,1} = tem;  
        % remove the exact dose
        tem = idx_control_dose{1,1};
        tem(bad_trials_cont) = [];
        idx_control_dose{1,1} = tem;    
    end
end

% get each raw chunks/spectrums per conditions
nfreq = size(raw_static_FFT{1,1}.powspctrm,3);

% control
[eachdata_t1_c,eachspec_t1_c,eachspec_t1foi_c,subtrlidx_t1_c] =... 
wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_control_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
% cond1
[eachdata_t1_con1,eachspec_t1_con1,eachspec_t1foi_con1,subtrlidx_t1_con1] =... 
wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond1_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
% cond2
[eachdata_t1_con2,eachspec_t1_con2,eachspec_t1foi_con2,subtrlidx_t1_con2] =... 
wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond2_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);

% save snippets
varname_result = sprintf("%s_ch%d_snip_%s",target,ch,ver);
dir_result = fullfile(dir_data, varname_result);
if isequal(patient,"")
    save(dir_result,""); 
end
