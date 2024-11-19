%% 06/13/2024 Woni
% magnet analysis
clear;clc;

addpath('C:\Users\XX\Box\XX_XX\scripts\XX\BITES\functions');
%%%%%%%%%%%%%%%%%%change here%%%%%%%%%%%%%%%%%%%
patient = "XX";
stim = 0; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% Create list variables and save the data
% set directory
if isequal(patient,"XX")
    dir_excel = sprintf("C:\\Users\\XX\\Box\\XX_XX\\data\\XX\\XX_XX_XX EXTERNAL #PHI\\%s_magnet_cr",patient);
elseif isequal(patient,"XX")
    dir_excel = sprintf("C:\\Users\\XX\\Box\\XX_XX\\data\\XX\\XX_XX_XX EXTERNAL #PHI\\Stanford_XX_XX EXTERNAL #PHI\\%s_magnet",patient);
elseif isequal(patient,"XX")
    dir_excel = sprintf("C:\\Users\\XX\\Box\\XX_XX\\data\\XX\\XX_XX_XX EXTERNAL #PHI\\Stanford_XX_XX EXTERNAL #PHI\\%s_magnet",patient);
end
dir_data = sprintf("C:\\Users\\XX\\Box\\XX_XX\\data\\%s\\alldata",patient);
% conditions
if isequal(patient,"XX")
    conditions = ["Severe","Mild","Normal"];
else isequal(patient,"XX") || isequal(patient,"XX")
    if isequal(cate,"hunger") 
        conditions = ["Craving","Hungry","Normal"];
    elseif isequal(cate,"craving")
        conditions = ["Severe","Mild","Normal"];
    end
end

wf_excel2data(dir_excel,dir_data,patient,conditions,uptodate);

%% sanity check of data in a loop
close all
%%%%%%%%%%Change Here%%%%%%%%%%%%%
showplot = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cnt = 1;

for whatcondition = 1:length(conditions) 
    condition = conditions(whatcondition);
    varname = sprintf("Magnet%s_%s",condition,uptodate);
    dir_datavar = fullfile(dir_data, varname);
    load(dir_datavar);    
    for trls = 1:length(trials_ieeg)
        if showplot
            figure(cnt);
            plot(trials_ieeg{1,trls}(1,:));
            ylim([-50 50])
        end
        cnt = cnt+1;
    end
end

%% crop data to fit the data length to 59 s or 119 s
clearvars -except patient uptodate cate mon stim dir_data conditions cnt;clc;close all

%%%%%%%%%%%%%%%
% total number of trials after ploting! % final cnt-1
totrl = cnt-1;

% 90 sec set
totlength1 = 89; %sec
timest1 = -60;
timeend1 = 29;
% 120 sec set
totlength2 = 179; %sec
timest2 = -120;
timeend2 = 59;

% doses
if isequal(patient,"XX")
    if ~stim
        if isequal(mon,"newmon")
            doses = "stimnewmon";
            dose_ind_cond = [10000,10000,10000]; 
        else
            doses = "prestimoldmon";
            dose_ind_cond = [10000,10000,10000]; 
        end
    else
        doses = "After 7 month stim (or since max dose)";
        dose_ind_cond =  [10000,10000,10000]; 
    end
elseif isequal(patient,"XX")
    if ~stim
        doses = "prestimnewmon";
        dose_ind_cond = [10000,10000,10000]; 
    else
        doses = "After 7 month stim (or since max dose)";
        dose_ind_cond = [10000,10000,10000];
    end
elseif isequal(patient,"XX")
    if ~stim
        doses = ["Nadir","Breakthrough"];
        dose_ind_cond = [5,57,26]; % [Severe, Mild, Control]
    else
        doses = ["1 mA","2 mA","3 mA","4 mA"];
    end
end
%%%%%%%%%%%%%%%%

% sanity check
if stim
    if size(dose_ind_cond,1) ~= (length(doses)-1) || size(dose_ind_cond,2) ~= length(conditions)
        warning("dose_ind_cond dose not match dimension of doses or conditions!")
    end
end

wf_preprocess_share(dir_data,patient,totrl,conditions,uptodate,doses,dose_ind_cond, totlength1, timest1, timeend1, totlength2,...
    timest2,timeend2)

