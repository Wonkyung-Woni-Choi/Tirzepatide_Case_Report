%% 06/13/2024 Woni
% analysis on static power
clear; close all; clc;
set(0,'DefaultFigureVisible','off');
set(groot,'defaultAxesFontSize',15)
addpath('C:\Users\XX\XX\XX_XX\scripts\XX\XX\functions');

%%%%%%%%%%%%%%%%%%%%%%%%%
patient = "XX";
ch = 1;
stim = 0;
magnet = 1;

showplot = 1; % 1 - show, 0 - not show
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%
ver = 'cr'; 

if isequal(patient,"XX") || isequal(patient,"XX")
    cate = "craving"; %"hunger";
else
    cate = 'no';
end
if isequal(patient,"XX")
    mon = "newmon"; %"";
else
    mon = 'no';
end
if ~stim
    stimannot = '';
else
    stimannot = 'stim';
end
% uptodate
if isequal(patient,"XX") 
    if isequal(cate,"hunger") 
        uptodate = "prestimoldmon";
    elseif isequal(cate,"craving")
        if ~stim
            if isequal(mon,"newmon")
                uptodate = "stimnewmoncrav";
            else
                uptodate = "prestimoldmoncrav";
            end
        else
            uptodate = "stimrealnewmoncravnostim_cr";
        end
    end
elseif isequal(patient,"XX")
    if isequal(cate,"hunger") 
        uptodate = "prestimnewmon";
    elseif isequal(cate,"craving")
        if ~stim
            uptodate = "prestimnewmoncrav";
        else
            uptodate = "stimnewmoncravnostim_cr";
        end
    end
elseif isequal(patient,"XX")
    uptodate = "cr";
end

% save directory
target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
fig_dir = "C:\Users\XX\XX\XX_XX\scripts\XX\figures\Magnet\"; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,target);
% sub directory
subtarget = "static";
dir_target = fullfile(dir_target,subtarget);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

% load data
dir_data = sprintf("C:\\Users\\XX\\XX\\XX_XX\\data\\%s\\alldata\\",patient);
varname = sprintf("%s_magnet_fieldtrip_%s",patient,uptodate);
dir_fullsesdatavar = fullfile(dir_data, varname);

% analize
epoch_len = 5; %sec - subtrial length
wf_static_analysis(patient,target,dir_data,dir_target,dir_fullsesdatavar,ch,stim,magnet,showplot,saveplot,epoch_len);

%% get idxs
clear; clc; close all;
set(0,'DefaultFigureVisible','on');
addpath('C:\Users\XX\XX\XX_XX\scripts\XX\XX\functions');

%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
patient = "XX";
ch = 1;
stim = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ver = 'cr';

if isequal(patient,"XX")
    mon = "newmon"; 
else
    mon = 'no';
end
if isequal(mon,"newmon")
    enablemon = 1;
else
    enablemon = 0;
end
if ~stim
    stimannot = '';
else
    stimannot = 'stim';
end
% uptodate
if isequal(patient,"XX") 
    if ~stim
        if isequal(mon,"newmon")
            uptodate = "stimnewmoncrav";
        else
            uptodate = "prestimoldmoncrav";
        end
    else
        uptodate = "stimrealnewmoncravnostim_cr";
    end
elseif isequal(patient,"XX")
    if ~stim
        uptodate = "prestimnewmoncrav";
    else
        uptodate = "stimnewmoncravnostim_cr";
    end
elseif isequal(patient,"XX")
    uptodate = "cr";
end

if isequal(patient,"XX")
    if ~stim
        apply_specific_ind = 0;
        dose_ind_cond = [10000,10000,10000]; 
        if enablemon
            doses = ["Stimulation"];
        else
            doses = ["Pre-stimulation"];
        end
        conditions = ["Mild","Severe","Control"];
    elseif stim
        apply_specific_ind = 0;
        if isequal(uptodate,"stimrealnewmoncrav_cr")
            if ch == 1
                apply_specific_ind = 1;
                bad_trials_con1 = [4];
                bad_trials_cont = [31,33];
            end
        end
        doses = "After 7 month stim (or since max dose)";
        dose_ind_cond =  [10000,10000,10000]; 
        conditions = ["Mild","Severe","Control"];
    end
elseif isequal(patient,"XX")
    if ~stim
        apply_specific_ind = 0;
        dose_ind_cond = [10000,10000,10000]; 
        doses = ["Pre-stimulation"];
        conditions = ["Mild","Severe","Control"];
    elseif stim
        apply_specific_ind = 0;
        doses = "After 7 month stim (or since max dose)";
        dose_ind_cond =  [10000,10000,10000]; 
        conditions = ["Mild","Severe","Control"];
    end
elseif isequal(patient,"XX")
    if ~stim
        apply_specific_ind = 1;
        specific_ind = [1,0,2]; % [severe,mild,control]
        doses = ["Nadir","Breakthrough"];
        dose_ind_cond = [5,57,26]; % [severe,mild,control]
        conditions = ["Mild","Severe","Control"];
    elseif stim
    end
end

% save directory
target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
fig_dir = "C:\Users\XX\XX\XX_XX\scripts\XX\figures\Magnet\"; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,target);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

% load analysis result
dir_data = sprintf("C:\\Users\\XX\\XX\\XX_XX\\data\\%s\\alldata\\",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);

% load data - only trial nums
dir_data = sprintf("C:\\Users\\XX\\XX\\XX_XX\\data\\%s\\alldata\\",patient);
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
if isequal(patient,"XX")
    if ~stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    elseif stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    end
elseif isequal(patient,"XX") 
    if ~stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    elseif stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    end    
elseif isequal(patient,"XX")
    if ~stim
        [idx_cond1_dose,idx_cond2_dose,idx_control_dose] = wf_get_magnetidx(trial_nums,length(conditions),length(doses),dose_ind_cond);
    elseif stim
    end
end

% remove month 1
if isequal(patient,"XX") % to make sure
    if apply_specific_ind
        idx_cond1_dose{1,1} = idx_cond1_dose{1,1}(1,specific_ind(1)+1:end);
        idx_control_dose{1,1} = idx_control_dose{1,1}(1,specific_ind(3)+1:end);    
    end
end
if isequal(patient,"XX") % to make sure
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

if isequal(patient,"XX")
    if ~stim
        % control
        [eachdata_t1_c,eachspec_t1_c,eachspec_t1foi_c,subtrlidx_t1_c] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_control_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % severe
        [eachdata_t1_s,eachspec_t1_s,eachspec_t1foi_s,subtrlidx_t1_s] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond1_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % mild
        [eachdata_t1_m,eachspec_t1_m,eachspec_t1foi_m,subtrlidx_t1_m] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond2_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
    elseif stim
        % control
        [eachdata_t1_c,eachspec_t1_c,eachspec_t1foi_c,subtrlidx_t1_c] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_control_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % severe
        [eachdata_t1_s,eachspec_t1_s,eachspec_t1foi_s,subtrlidx_t1_s] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond1_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
    end
elseif isequal(patient,"XX")
    if ~stim
        % control
        [eachdata_t1_c,eachspec_t1_c,eachspec_t1foi_c,subtrlidx_t1_c] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_control_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % severe
        [eachdata_t1_s,eachspec_t1_s,eachspec_t1foi_s,subtrlidx_t1_s] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond1_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % mild
        [eachdata_t1_m,eachspec_t1_m,eachspec_t1foi_m,subtrlidx_t1_m] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond2_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
    elseif stim
        % control
        [eachdata_t1_c,eachspec_t1_c,eachspec_t1foi_c,subtrlidx_t1_c] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_control_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % severe
        [eachdata_t1_s,eachspec_t1_s,eachspec_t1foi_s,subtrlidx_t1_s] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond1_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % mild
        [eachdata_t1_m,eachspec_t1_m,eachspec_t1foi_m,subtrlidx_t1_m] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond2_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
    end
elseif isequal(patient,"XX")
    if ~stim
        % control
        [eachdata_t1_c,eachspec_t1_c,eachspec_t1foi_c,subtrlidx_t1_c,...
        eachdata_t2_c,eachspec_t2_c,eachspec_t2foi_c,subtrlidx_t2_c] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_control_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % severe
        [eachdata_t1_s,eachspec_t1_s,eachspec_t1foi_s,subtrlidx_t1_s,...
        eachdata_t2_s,eachspec_t2_s,eachspec_t2foi_s,subtrlidx_t2_s] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond1_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
        % mild
        [eachdata_t1_m,eachspec_t1_m,eachspec_t1foi_m,subtrlidx_t1_m,...
        eachdata_t2_m,eachspec_t2_m,eachspec_t2foi_m,subtrlidx_t2_m] =... 
        wf_chunks(raw_static_FFT, static_freq, raw_chunks, idx_cond2_dose, length(doses), 179, subtrllen, [1,6], nfreq, 250);
    elseif stim
    end
end

% save snippets
varname_result = sprintf("%s_ch%d_snip_cr",target,ch);
dir_result = fullfile(dir_data, varname_result);
if isequal(patient,"XX")
    if ~stim
        save(dir_result,"eachdata_t1_c","eachspec_t1_c","eachspec_t1foi_c","subtrlidx_t1_c",...
        "eachdata_t1_s","eachspec_t1_s","eachspec_t1foi_s","subtrlidx_t1_s",...
        "eachdata_t1_m","eachspec_t1_m","eachspec_t1foi_m","subtrlidx_t1_m"); 
    elseif stim
        save(dir_result,"eachdata_t1_c","eachspec_t1_c","eachspec_t1foi_c","subtrlidx_t1_c",...
        "eachdata_t1_s","eachspec_t1_s","eachspec_t1foi_s","subtrlidx_t1_s"); 
    end
elseif isequal(patient,"XX")
    if ~stim
        save(dir_result,"eachdata_t1_c","eachspec_t1_c","eachspec_t1foi_c","subtrlidx_t1_c",...
        "eachdata_t1_s","eachspec_t1_s","eachspec_t1foi_s","subtrlidx_t1_s",...
        "eachdata_t1_m","eachspec_t1_m","eachspec_t1foi_m","subtrlidx_t1_m"); 
    elseif stim
        save(dir_result,"eachdata_t1_c","eachspec_t1_c","eachspec_t1foi_c","subtrlidx_t1_c",...
        "eachdata_t1_s","eachspec_t1_s","eachspec_t1foi_s","subtrlidx_t1_s",...
        "eachdata_t1_m","eachspec_t1_m","eachspec_t1foi_m","subtrlidx_t1_m"); 
    end
elseif isequal(patient,"XX")
    if ~stim
        save(dir_result,"eachdata_t1_c","eachspec_t1_c","eachspec_t1foi_c","subtrlidx_t1_c","eachdata_t2_c","eachspec_t2_c","eachspec_t2foi_c","subtrlidx_t2_c",...
        "eachdata_t1_s","eachspec_t1_s","eachspec_t1foi_s","subtrlidx_t1_s","eachdata_t2_s","eachspec_t2_s","eachspec_t2foi_s","subtrlidx_t2_s",...
        "eachdata_t1_m","eachspec_t1_m","eachspec_t1foi_m","subtrlidx_t1_m","eachdata_t2_m","eachspec_t2_m","eachspec_t2foi_m","subtrlidx_t2_m"); 
    elseif stim
    end
end
