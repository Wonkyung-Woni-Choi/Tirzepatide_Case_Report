% magnet analysis
clear;clc;

addpath('');
%%%%%%%%%%%%%%%%%%change here%%%%%%%%%%%%%%%%%%%
patient = "";
stim = 0; 
newmon = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cate = ""; 
mon = ""; 

% uptodate
uptodate = "";

% uptodate_save: what name to save after preprocessing
uptodate_save = "";
  
% Create list variables and save the data
% set directory
dir_excel = sprintf("",patient);
dir_data = sprintf("",patient);
% conditions
conditions = [""];

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
            %plot(trials_ieeg{1,trls}');
            plot(trials_ieeg{1,trls}(1,:));
            ylim([-50 50])
        end
        cnt = cnt+1;
    end
end

%% crop data to fit the data length to 59 s or 119 s
clearvars -except patient uptodate cate mon stim dir_data conditions cnt uptodate_save;clc;close all

%%%%%%%%%%%%%%%
% total number of trials after ploting! % final cnt-1
totrl = cnt-1;

% 90 sec set
totlength1 = 89; %sec
timest1 = -60;
timeend1 = 29;
% 180 sec set
totlength2 = 179; %sec
timest2 = -120;
timeend2 = 59;

% doses
doses = "";
dose_ind_cond = []; 
%%%%%%%%%%%%%%%%

% sanity check
if stim
    if size(dose_ind_cond,1) ~= (length(doses)-1) || size(dose_ind_cond,2) ~= length(conditions)
        warning("dose_ind_cond dose not match dimension of doses or conditions!")
    end
end

% rev2 version has uptodate and uptodate_save
wf_preprocess_rev2(dir_data,patient,totrl,conditions,uptodate,uptodate_save,doses,dose_ind_cond, totlength1, timest1, timeend1, totlength2,...
    timest2,timeend2)

