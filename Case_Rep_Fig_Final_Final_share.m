%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case Report Figure Generating Codes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Final version after revision

%% Raw data, Powerspectrum, and Box-whisker
clear; clc; close all;
set(0,'DefaultFigureVisible','on');
set(groot,'defaultAxesXTickLabelRotationMode','manual'); 
addpath('');

%%%%%%%%%%%%%%%%%%%%%%%%
patient = "";
ch = 3;
stim = 0;
newmon = 0;

showplot = 1;
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%
ver = '';

if isequal(patient,"")
    mon = "newmon"; %"";
else
    mon = 'no';
end
if isequal(mon,"newmon") && isequal(patient,"")
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
if isequal(patient,"") 
    if ~stim
        if isequal(mon,"newmon")
            uptodate = "";
        elseif isequal(mon,"no")
            uptodate = "";
        end
    else
        uptodate = "";
    end
elseif isequal(patient,"")
    if ~stim
        if isequal(mon,"newmon")
                uptodate = "";
        elseif isequal(mon,"no")
            uptodate = "";
        end
    else
        uptodate = "";
    end
elseif isequal(patient,"")
    uptodate = "";
end

% load data - only trial nums
dir_data = sprintf("",patient);
varname = sprintf("%s_magnet_fieldtrip_%s",patient,uptodate);
dir_fullsesdatavar = fullfile(dir_data, varname);
load(dir_fullsesdatavar);

% calculate trial numbers vector 
temp = trial_nums;
ncond = size(trial_nums,2);
trial_nums = zeros(1,ncond);
for i = 1:ncond
    trial_nums(1,i) = temp{2,i};
end

%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
if isequal(patient,"")
    ptname = "Participant 3";
elseif isequal(patient,"")
    ptname = "Participant 1";
elseif isequal(patient,"")
    ptname = "Participant 2";
end

expcond = "Ambulatory Data";
locations = ["lNAc","lNAc","rNAc","rNAc"];

if isequal(patient,"")
    apply_specific_ind = 1;
    specific_ind = [1,0,2];
    dose_ind_cond = [5,57,26]; 
    doses = ["Mon.2 - Mon.4","Mon.5 - Mon.7"];
    cond_string_lgnd = [compose("Severe Food\nPreoccupation"),"Control"];
    cond_string = {"Severe Food\newlinePreoccupation","Control"};
else
    apply_specific_ind = 0;
    dose_ind_cond = [10000,10000,10000]; 
    if enablemon
        doses = ["NewmonStimulation"];
    else
        doses = ["Pre-stimulation"];
    end
    if stim
        doses = ["Stimulation"]
    end
    cond_string_lgnd = [compose("Severe Food\nPreoccupation"),"Control"];
    cond_string = {"Severe Food\newlinePreoccupation","Control"};
end

xlogon = 1;
ylogon = 1;
titleon = 1;
sgtitleon = 0;
annoton = 0; % PVAL

if annoton
    annotopt = "pval";
else
    annotopt = "";
end
% miscellaneous
show_etc = 0;

interested_bandpowers = [1,7;];
interested_bandpowers_str = ["Delta-Theta"]; 
interested_bandpowers_str_filesave = ["Delta-Theta"];

if isequal(patient,"") 
    if ylogon
        if ch == 3
            ylim_bandpower = [[1e-1, 1e1];];
        elseif ch == 1
            ylim_bandpower = [[1e-1, 1e1];];
        else
            ylim_bandpower = [[1e-1, 1e1];];
        end
    else
        ylim_bandpower = [[0, 2];];
    end
elseif isequal(patient,"") 
    if ylogon
        ylim_bandpower = [[0.3, 38];];
    else
        ylim_bandpower = [[0, 6];];
    end
elseif isequal(patient,"") 
    if ylogon
        ylim_bandpower = [[1e-1, 30];];
    else
        ylim_bandpower = [[0, 20];];
    end
end

if isequal(patient,"")
    if ylogon
        y_lim = [5e-3 5e0];
    else
        y_lim = [0 3.5];
    end
elseif isequal(patient,"")
    if ylogon
        y_lim = [5e-3 1e1];
    else
        y_lim = [0 11];
    end
elseif isequal(patient,"")
    if ylogon
        y_lim = [5e-3 1e1];
    else
        y_lim = [0 10];
    end
end

x_lim = [1 100];%freq

if isequal(patient,"")
    set(groot,'defaultAxesFontSize',23)
    sgtisz = 23;
    tisz = 23;
    tilefont = 23;
else
    set(groot,'defaultAxesFontSize',35)
    sgtisz = 35;
    tisz = 35;
    tilefont = 35;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set directory
% folder name
fig_folder = "";
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end
% load analysis result
if isequal(patient,"")
    target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
else
    target = sprintf("New%s_magnet_v%s%s_mon%s",patient,ver,stimannot,mon);
end
dir_data = sprintf("",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);
varname_result = sprintf("%s_ch%d_snip_%s",target,ch,ver);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);

freq = static_freq{1};

% plot examplary sawtooth waveform
close all;
xt = [0:1/250:10];

if newmon
    if ~stim
        if isequal(patient,"")
            fig = figure('units','normalized','outerposition',[0 0 0.5 2]);
            t0 = tiledlayout(2,1,'TileSpacing','Compact');
            % time1
            nexttile
            axis off
            hold on
            % control
            time2plot = [-86,-76];
            trl = 153;
            tidxs = dsearchn(time{1,trl}',time2plot');
            plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2)),'Color',[62 193 211]/255)
            % cond1
            time2plot = [-38,-28];
            trl = 5;
            tidxs = dsearchn(time{1,trl}',time2plot');
            plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-300,'Color',[255 22 93]/255)
            % measure
            plot([9+1/250:1/250:10],-340*ones(length([9+1/250:1/250:10]),1),'Color','k','LineWidth',2) % 1 sec
            plot(ones(length(-25:25),1)*0,[-25:25],'Color','k','LineWidth',2) % 50 uV
            ylim([-350,50])
        
            % time2
            nexttile
            axis off
            hold on
            % control
            time2plot = [-32,-22];
            trl = 162;
            tidxs = dsearchn(time{1,trl}',time2plot');
            plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2)),'Color',[62 193 211]/255)
            % cond1
            time2plot = [-18,-8];
            trl = 9;%8;
            tidxs = dsearchn(time{1,trl}',time2plot');
            plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-300,'Color',[255 22 93]/255)
            % measure
            plot([9+1/250:1/250:10],-340*ones(length([9+1/250:1/250:10]),1),'Color','k','LineWidth',2) % 1 sec
            plot(ones(length(-25:25),1)*0,[-25:25],'Color','k','LineWidth',2) % 50 uV
            ylim([-350,50])
        
            if sgtitleon
                sgtitle_str = sprintf("%s",ptname);
                sgtitle(sgtitle_str,'Fontsize',sgtisz,'FontWeight','bold')
            end      
        end
    
        if saveplot
            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        
            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
    end
end

cluster_corr = {};
cnt = 1;
% Spectrum and box whisker plots 
if isequal(patient,"")
    fig1 = figure('units','normalized','outerposition',[0 0 0.35 2]);
    t1 = tiledlayout(2,1,'TileSpacing','Compact');
    for dose = 1:length(doses)
        if dose == 1 
            con1 = eachspec_t1_SFP; % Trial x Freq
            control = eachspec_t1_c; % Trial x Freq
        else
            con1 = eachspec_t2_SFP; % Trial x Freq
            control = eachspec_t2_c; % Trial x Freq
        end
        dose_amount = doses(1,dose);
        
        if showplot
            % line plot
            nexttile
            hold on
            % control
            db_changes_1= control;
            STE=squeeze(nanstd(db_changes_1,[],1)/sqrt((size(db_changes_1,1))));
            ck_shadedErrorBar(freq,nanmean(db_changes_1,1),STE,[62 193 211]/255,1);
            % Condition1
            db_changes_1 = con1;
            STE=squeeze(nanstd(db_changes_1,[],1)/sqrt((size(db_changes_1,1))));
            ck_shadedErrorBar(freq,nanmean(db_changes_1,1),STE,[255 22 93]/255,1);

            % permutation + cluster-based correction
            % parameters
            % input: trials x frequency
            % cond2 - cond1
            % cont vs. severe
            condition1 = control;
            condition2 = con1;
            numcond1 = size(control,1);
            numcond2 = size(con1,1);
            pval = 0.05;
            tail = 2; % two tail
            cluster_pval = 0.025;
            npermutes = 1000;
            rng(102)
            [zmap, zmapthresh, zmapthresh_correc] = cluster_permutation_1d_woni(condition1,condition2,numcond1,numcond2,pval,tail,cluster_pval,npermutes);
            % what to plot
            temtem = zmapthresh_correc;
            temtem(temtem == 0) = nan;
            temtem(~isnan(temtem)) = y_lim(1)+0.001;          
            plot(freq,temtem,'color','k','linewidth',3)
            cluster_corr{1,cnt} = "Control vs. Severe";
            cluster_corr{2,cnt} = temtem;
            cnt = cnt+1;

            if ylogon
                set(gca,'YScale','log')
            end
            if xlogon
                set(gca,'XScale','log')
            end
            xlim(x_lim);
            ylim(y_lim);
            xticks([0,10,100]);
            xticklabels(["0","10","100"]);
            xlabel(t1,'Frequency (Hz)','FontSize',tilefont);
            if ylogon
                ylabel(t1,'Average Log Power (a.u.)','fontsize',tilefont);  
            else
                ylabel(t1,'Average power (a.u.)','fontsize',tilefont);  
            end
            if sgtitleon
                sgtitle_str = sprintf("%s",ptname);
                sgtitle(sgtitle_str,'Fontsize',sgtisz,'FontWeight','bold')
            end
            if titleon
                title_str = sprintf("%s", dose_amount);
                title(title_str,'FontSize',tisz,'FontWeight','normal')
            end
            lgnd = legend(cond_string_lgnd(1,2)+" (n="+num2str(size(control,1))+")",'',cond_string_lgnd(1,1)+" (n="+num2str(size(con1,1))+")",'',"location","northeast");
            if ~titleon
                dim = lgnd.Position + [0.07 -0.08 0 0]; % [x y w h]
                pstr = {sprintf("%s", dose_amount)};
                annotation('textbox',dim,'String',pstr,'FitBoxToText','on','EdgeColor','none','FontSize',16);
            end
            grid on
        end
    end
    %box-whisker
    for i = 1:size(interested_bandpowers,1)
        fig2 = figure('units','normalized','outerposition',[0 0 0.35 2]);
        t2 = tiledlayout(2,1,'TileSpacing','Compact');
        y_lim = ylim_bandpower(i,:);
        [~,mind] = max(abs(y_lim));
        fqoi = interested_bandpowers(i,:);
        bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind 
        bandfq = bandfq_idx(1):bandfq_idx(2);

        for dose = 1:length(doses)
            if dose == 1 
                con1 = eachspec_t1_SFP; % Trial x Freq
                control = eachspec_t1_c; % Trial x Freq
            else
                con1 = eachspec_t2_SFP; % Trial x Freq
                control = eachspec_t2_c; % Trial x Freq
            end
            dose_amount = doses(1,dose); 
            control_band = nanmean(control(:,bandfq),2);
            cond1_band = nanmean(con1(:,bandfq),2);
            if i == 1 % delta
                delta_band_power{1,(dose-1)*3+1} = control_band;
                delta_band_power{1,(dose-1)*3+2} = cond1_band;
            end    
            length_bandfq = length(bandfq); 
            
            if showplot
                nexttile
                x_cont = ones(1,length(control_band))';
                x_cond1 = 2 * ones(1,length(cond1_band))';
                y_cont = control_band;
                y_cond1 = cond1_band;
                
                tot_x = [x_cont;x_cond1];
                tot_y = [y_cont;y_cond1];
                boxplot(tot_y,tot_x,'Colors',[[62 193 211]/255;[255 22 93]/255],...
                'Labels',[cond_string{1,2},cond_string{1,1}]);
                hold on
                ax = gca;
                ax.TickLabelInterpreter = 'tex';
                outlier = findobj(gcf,'tag','Outliers');
                for oo = 1:numel(outlier)
                    if oo == 2 || oo == 4
                        outlier(oo).MarkerEdgeColor = [62 193 211]/255;
                    elseif oo == 1 || oo == 3
                        outlier(oo).MarkerEdgeColor = [255 22 93]/255;
                    end
                end                
                h2_d2 = 0;
                % permutation testing
                rng(102)
                perm_ctcd1 = perm_mdiff(control_band,cond1_band,10000) 
                if perm_ctcd1 <= 0.05
                    h2_d2 = 1;
                end

                % draw * if significant
                if h2_d2 == 1
                    if ylogon
                       yv =  [0.73; 0.83];
                    else
                       yv  = [0.78; 0.8];
                    end
                    plot([0.8,2.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                    plot(1.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                end
                hold off
                
                if ylogon
                    set(gca,'YScale','log')
                end
                ylim(y_lim)
                if ylogon
                    ylabel(t2,sprintf('Average %s Log Power (a.u.)',interested_bandpowers_str{1,i}),'fontsize',tilefont);
                else
                    ylabel(t2,'Average power (a.u.)');
                end
                if sgtitleon
                    sgtitle_str = sprintf("%s",ptname);
                    sgtitle(sgtitle_str,'Fontsize',sgtisz,'FontWeight','bold')
                end
                if titleon
                    title_str = sprintf("%s", dose_amount);
                    title(title_str,'FontSize',tisz,'FontWeight','normal')
                end  
            end

            if saveplot
                varname_fig = ;
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(fig2,savedir_figure);
        
                varname_fig = ;
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(fig2,savedir_figure);
            end
        end
    end      

    if saveplot
        varname_fig = ;
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(fig1,savedir_figure);

        varname_fig = ;
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(fig1,savedir_figure);
    end
else
    for dose = 1:length(doses)
        con1 = eachspec_t1_SFP; % Trial x Freq
        control = eachspec_t1_c; % Trial x Freq
        dose_amount = doses(1,dose);
        
        if showplot
            % line plot
            fig = figure('units','normalized','outerposition',[0 0 0.75 1]);
            hold on
            % control
            db_changes_1= control;
            STE=squeeze(nanstd(db_changes_1,[],1)/sqrt((size(db_changes_1,1))));
            ck_shadedErrorBar(freq,nanmean(db_changes_1,1),STE,[62 193 211]/255,1);
            % Condition1
            db_changes_1 = con1;
            STE=squeeze(nanstd(db_changes_1,[],1)/sqrt((size(db_changes_1,1))));
            ck_shadedErrorBar(freq,nanmean(db_changes_1,1),STE,[255 0 93]/255,1);

            % permutation + cluster-based correction
            % parameters
            % input: trials x frequency
            % cond2 - cond1
            % cont vs. severe
            condition1 = control;
            condition2 = con1;
            numcond1 = size(control,1);
            numcond2 = size(con1,1);
            pval = 0.05; % if tail = 2, voxel_pval = pval/2; % two tails
            tail = 2; % two tails
            cluster_pval = 0.025;
            npermutes = 1000;
            rng(102)
            [zmap, zmapthresh, zmapthresh_correc] = cluster_permutation_1d_woni(condition1,condition2,numcond1,numcond2,pval,tail,cluster_pval,npermutes);
            % what to plot
            temtem = zmapthresh_correc;
            temtem(temtem == 0) = nan;
            temtem(~isnan(temtem)) = y_lim(1)+0.001;          
            plot(freq,temtem,'color','k','linewidth',3)
            cluster_corr{1,cnt} = "Control vs. Severe";
            cluster_corr{2,cnt} = temtem;
            cnt = cnt+1;
          
            if ylogon
                set(gca,'YScale','log')
            end
            if xlogon
                set(gca,'XScale','log')
            end          
            xlim(x_lim);
            ylim(y_lim);
            xticks([0,10,100]);
            xticklabels(["0","10","100"]);
            xlabel('Frequency (Hz)');
            if ylogon
                ylabel('Average Log Power (a.u.)');  
            else
                ylabel('Average power (a.u.)');  
            end      
            if titleon
                title_str = sprintf("%s",ptname);
                title(title_str)
            end
            lgnd = legend(cond_string_lgnd(1,2)+" (n="+num2str(size(control,1))+")",'',cond_string_lgnd(1,1)+" (n="+num2str(size(con1,1))+")",'',"location","northeast");
            grid on
        end
        if saveplot
            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
        
        % box whisker
        for i = 1:size(interested_bandpowers,1)
            y_lim = ylim_bandpower(i,:);
            [~,mind] = max(abs(y_lim));
            fqoi = interested_bandpowers(i,:);
            bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind 
            bandfq = bandfq_idx(1):bandfq_idx(2);
    
            control_band = nanmean(control(:,bandfq),2);
            cond1_band = nanmean(con1(:,bandfq),2);
            if i == 1
                delta_band_power{1,(dose-1)*3+1} = control_band;
                delta_band_power{1,(dose-1)*3+2} = cond1_band;
            end    
            length_bandfq = length(bandfq); 
            
            if showplot
                fig = figure('units','normalized','outerposition',[0 0 0.75 1]);
                x_cont = ones(1,length(control_band))';
                x_cond1 = 2 * ones(1,length(cond1_band))';
                y_cont = control_band;
                y_cond1 = cond1_band;
                            
                tot_x = [x_cont;x_cond1];
                tot_y = [y_cont;y_cond1];

                boxplot(tot_y,tot_x,'Colors',[[62 193 211]/255;[255 22 93]/255],...
                'Labels',[cond_string{1,2},cond_string{1,1}]);
                hold on
                ax = gca;
                ax.TickLabelInterpreter = 'tex';
                outlier = findobj(gcf,'tag','Outliers');
                for oo = 1:numel(outlier)
                    if oo == 2 || oo == 4
                        outlier(oo).MarkerEdgeColor = [62 193 211]/255;
                    elseif oo == 1 || oo == 3
                        outlier(oo).MarkerEdgeColor = [255 22 93]/255;
                    end
                end 
                h2_d2 = 0;
                % permutation testing
                rng(102)
                perm_ctcd1 = perm_mdiff(control_band,cond1_band,10000) 
                if perm_ctcd1 <= 0.05
                    h2_d2 = 1;
                end
                % draw * if significant
                if h2_d2 == 1
                   if ylogon
                       yv =  [0.59; 0.66];
                   else
                       yv  = [0.78; 0.8];
                   end
                   plot([0.8,2.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                   plot(1.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                end
                hold off
                
                if ylogon
                    set(gca,'YScale','log')
                end
                ylim(y_lim)
                if ylogon
                    ylabel(sprintf('Average Log %s Power (a.u.)',interested_bandpowers_str{1,i}));
                else
                    ylabel('Average power (a.u.)');
                end

                if titleon
                    title_str = sprintf("%s",ptname);
                    title(title_str,'FontSize',tisz);
                end
            end        
            if saveplot
                varname_fig = ;
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(gcf,savedir_figure);

                varname_fig = ;
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(gcf,savedir_figure);
            end
        end
    end
end

%% Powerspectrum for Magnet swipes
clear;clc;close all
%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
patient = "";
ch = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uptodate
if isequal(patient,"") 
    if ~stim
        if isequal(mon,"newmon")
            uptodate = "";
        elseif isequal(mon,"no")
            uptodate = "";
        end
    else
        uptodate = "";
    end
elseif isequal(patient,"")
    if ~stim
        if isequal(mon,"newmon")
                uptodate = "";
        elseif isequal(mon,"no")
            uptodate = "";
        end
    else
        uptodate = "";
    end
elseif isequal(patient,"")
    uptodate = "";
end

% timeline bandpower plot
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

%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
ver = '';
stimannot = '';

uptodate = "";
detect_uptodate = uptodate;
% detection
if ch == 3
    detect_uptodate = "";
end

% data excel file name
dataname = "_magnet_%s_%s";
% detection file name
detectionname = "_magnet_%s_%s";
locations = ["left NAc","left NAc","right NAc","right NAc"];

apply_specific_ind = 1;
specific_ind = [1,0,2];
conditions = ["","",""]; % filename
dose_ind_cond = [5,57,26]; 
doses = ["Mon.2 - Mon.4","Mon.5 - Mon.7"];
cond_string = ["Mild Food Preoccupation","Severe Food Preoccupation","Control"];

titleon = 0;
showplot = 1;
saveplot = 1;
showdetectionplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set directory
% folder name
fig_folder = "";
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end
% load analysis resultarget
if isequal(patient,"")
    target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
else
    target = sprintf("New%s_magnet_v%s%s_mon%s",patient,ver,stimannot,mon);
end
dir_data = sprintf("",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);
% directory to get timelists/detections
dir_excel = sprintf("",patient);

% get timelist
timelist = [];
cnt = 1;
for whatcondition = 1:length(conditions)
    condition = conditions(whatcondition);
    filename = sprintf(dataname,condition,uptodate);
    dir_excelfile = fullfile(dir_excel, filename);
    % call spreadsheet
    list = readcell(dir_excelfile); % datetime var (cell array)
    for i = 1: size(list,1)
        timelist = [timelist, list{i,1}];
        cnt = cnt+1;
    end
end
timelist_search = datetime(timelist,'Format','dd-MMM-yyyy');
% create variable name in the designated directory
varname = sprintf("timelist_Magnet%s",condition);
dir_listvar = fullfile(dir_data, varname);
save(dir_listvar,"timelist")

% get detection
filename = sprintf(detectionname,"detection",detect_uptodate);
dir_excelfile = fullfile(dir_excel, filename);
% call spreadsheet
list = readcell(dir_excelfile); % datetime var (cell array)
cnt = 1;
detection_dates = [];
detection_nums = [];
for i = 1: length(list)
    detection_dates = [detection_dates, list{i,1}];
    detection_nums = [detection_nums, list{i,2}];
    cnt = cnt+1;
end
detection_dates = dateshift(detection_dates, 'start', 'day');
timelist_search = dateshift(timelist_search, 'start', 'day');
commondates = detection_dates(ismember(detection_dates,timelist_search)); % will only find out corresponding dates w/o rep
commondates_detect = detection_nums(ismember(detection_dates,timelist_search));
temp = [];
swipedates = [];
swipedates_detect = [];
for i = 1:length(timelist_search) 
    temp = timelist_search(1,i);
    swipedates = [swipedates, commondates(commondates == temp)];
    swipedates_detect = [swipedates_detect, commondates_detect(commondates == temp)];
end

% parameters
for ind = 1:length(raw_static_FFT)
    staticpower(ind,:) = static_power{ind};
end
freq = static_freq{1};

% calculate indexes for each condition
% initialization
idx_SFP_dose = cell(length(doses),1);
idx_MFP_dose = cell(length(doses),1);
idx_normal_dose = cell(length(doses),1);
idx_etc_dose = cell(length(doses),1);

% loop to get index vectors
for i = 1:sum(trial_nums)
    if i <= trial_nums(1)
       if i <= dose_ind_cond(1)
          dose_idx = 1;
       else
          dose_idx = 2;
       end
       idx_SFP_dose{dose_idx,1} = [idx_SFP_dose{dose_idx,1}, i];
    elseif i <= sum(trial_nums(1:2)) 
       if i <= (dose_ind_cond(2) + trial_nums(1))
          dose_idx = 1;
       else
          dose_idx = 2;
       end
       idx_MFP_dose{dose_idx,1} = [idx_MFP_dose{dose_idx,1}, i];
    elseif i <= sum(trial_nums(1:3)) 
       if i <= (dose_ind_cond(3) + sum(trial_nums(1:2)))
          dose_idx = 1;
       else
          dose_idx = 2;
       end
       idx_normal_dose{dose_idx,1} = [idx_normal_dose{dose_idx,1}, i];
   elseif i <= sum(trial_nums(1:4)) 
       if i <= (dose_ind_cond(4) + sum(trial_nums(1:3)))
          dose_idx = 1;
       else
          dose_idx = 2;
       end
       idx_etc_dose{dose_idx,1} = [idx_etc_dose{dose_idx,1}, i];
    end
end

if apply_specific_ind
    idx_SFP_dose{1,1} = idx_SFP_dose{1,1}(1,2:end);
    idx_normal_dose{1,1} = idx_normal_dose{1,1}(1,3:end);    
end

idx_SFP_dose_all = [];
idx_MFP_dose_all = [];
idx_normal_dose_all = [];
idx_etc_dose_all = [];
for dose = 1:2
    idx_SFP_dose_all = [idx_SFP_dose_all, idx_SFP_dose{dose,1}];
    idx_MFP_dose_all = [idx_MFP_dose_all, idx_MFP_dose{dose,1}];
    idx_normal_dose_all = [idx_normal_dose_all, idx_normal_dose{dose,1}];
    idx_etc_dose_all = [idx_etc_dose_all, idx_etc_dose{dose,1}];
end

% all (aggregate doses)
close all;

%%%% Change here %%%%
colorlim = [0 5];
set(groot,'defaultAxesFontSize',14)
XSFP_fontsize = 14;
Xm_fontsize = 14;
Xctrl_fontsize = 14;
YSFP_fontsize = 16;
Ym_fontsize = 16;
Yctrl_fontsize = 16;
YLSFP_fontsize = 25;
YLm_fontsize = 25;
YLctrl_fontsize = 25;
SFP_fig_size = [0 0 0.5 0.75];
m_fig_size = [0 0 1.25 0.75];
ctrl_fig_size = [0 0 0.5 0.75];

anonymity = 1; % change to months relative to surgery for patient's privacy
Sur_start_month = [6]; % how many months should subtract to get month relative to surgery before year changes
% ex. July: month1, then 6./ex. April: month1, then 3.
Jan_relative_month = [6];% what number should add to make Jan to relative month (e.x. if Jan -> Month 7, +6)
%%%%%%%%%%%%%%%%%%%%%

SFP = staticpower(idx_SFP_dose_all,:)'; % Freq x Trial
MFP = staticpower(idx_MFP_dose_all,:)'; % Freq x Trial
control = staticpower(idx_normal_dose_all,:)'; % Freq x Trial

% get delta-bandpower
fqoi = [1,4];
bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind % want to do ttest up to fq: 20
bandfq = bandfq_idx(1):bandfq_idx(2);
SFP_delta = nanmean(SFP(bandfq,:),1); % 1 x Trial
MFP_delta = nanmean(MFP(bandfq,:),1); % 1 x Trial
ctrl_delta = nanmean(control(bandfq,:),1); % 1 x Trial

dose_amount = doses(1,dose);

SFP_xtick = timelist(1,idx_SFP_dose_all); % datetime 1 x # array
MFP_xtick = timelist(1,idx_MFP_dose_all);
ctrl_xtick = timelist(1,idx_normal_dose_all);

SFP_detect_xtick = swipedates(1,idx_SFP_dose_all);
SFP_detect_nums = swipedates_detect(1,idx_SFP_dose_all);
MFP_detect_xtick = swipedates(1,idx_MFP_dose_all);
MFP_detect_nums = swipedates_detect(1,idx_MFP_dose_all);
ctrl_detect_xtick = swipedates(1,idx_normal_dose_all);
ctrl_detect_nums = swipedates_detect(1,idx_normal_dose_all);

% Detection
if showplot
    % SFP - detection numbers
    if showdetectionplot
        fig = figure('units','normalized','outerposition',SFP_fig_size);
        %figure(dose*10+1);
        imagesc([1:length(SFP_xtick)],freq,SFP)
        ylabel('Frequency (Hz)','FontSize',YLSFP_fontsize)
        ylim([1 10])
        xticks([1:length(SFP_xtick)])
        hAx=gca;
        hAx.XAxis.TickLabelRotation=90;
        hAx.XAxis.FontSize= XSFP_fontsize;
        hAx.YAxis.FontSize= YSFP_fontsize;
        colorbar;
        axis xy;
        set(gca,'CLim', colorlim);
        hold on
        xticks([1:length(SFP_detect_xtick)])
        if anonymity
            mm_raw = month(SFP_detect_xtick);
            mm = mm_raw;
            % find ind for the start of Jan per each year
            temtem = find(mm_raw==1);
            if length(temtem) > 1
                Jan_ind = temtem(logical(cat(2,[1],diff(temtem)>1)));
                Jan_length = length(Jan_ind);
                mm(1:Jan_ind(1)-1) = mm_raw(1:Jan_ind(1)-1)-Sur_start_month;
                for i = 1:Jan_length
                    if i == Jan_length
                        mm(Jan_ind(i):end) = mm_raw(Jan_ind(i):end)+Jan_relative_month(i);
                    else
                        mm(Jan_ind(i):Jan_ind(i+1)-1) = mm_raw(Jan_ind(i):Jan_ind(i+1)-1)+Jan_relative_month(i);
                    end
                end
            else
                mm = mm_raw-Sur_start_month;
            end
            dd = day(SFP_detect_xtick);
            anon_xticklabel = strings([length(mm),1]);
            for i = 1:length(mm)
                anon_xticklabel(i) = ["M"+num2str(mm(i))+"-D"+num2str(dd(i))];
            end
            xticklabels(anon_xticklabel)
        else
            xticklabels(string(datetime(SFP_detect_xtick,'Format','MMM-dd')))  
        end             
        if titleon
            title_str = sprintf("Frequency power along time - %s (%s)",cond_string(2),locations(ch));
            title(title_str,'FontSize', YSFP_fontsize)
        end
        if saveplot
            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
    end
    % Control - detection plot
    if showdetectionplot
        fig = figure('units','normalized','outerposition',ctrl_fig_size);
        imagesc([1:length(ctrl_xtick)],freq,control)
        ylabel('Frequency (Hz)','FontSize',YLctrl_fontsize)
        ylim([1 10])
        xticks([1:length(ctrl_xtick)])
        hAx=gca;
        hAx.XAxis.TickLabelRotation=90;
        hAx.XAxis.FontSize=Xctrl_fontsize;
        hAx.YAxis.FontSize=Yctrl_fontsize;
        colorbar;
        axis xy;
        set(gca,'CLim', colorlim);
        hold on
        xticks([1:length(ctrl_detect_xtick)])
        if anonymity
            mm_raw = month(ctrl_detect_xtick);
            mm = mm_raw;
            % find ind for the start of Jan per each year
            temtem = find(mm_raw==1);
            if length(temtem) > 1
                Jan_ind = temtem(logical(cat(2,[1],diff(temtem)>1)));
                Jan_length = length(Jan_ind);
                mm(1:Jan_ind(1)-1) = mm_raw(1:Jan_ind(1)-1)-Sur_start_month;
                for i = 1:Jan_length
                    if i == Jan_length
                        mm(Jan_ind(i):end) = mm_raw(Jan_ind(i):end)+Jan_relative_month(i);
                    else
                        mm(Jan_ind(i):Jan_ind(i+1)-1) = mm_raw(Jan_ind(i):Jan_ind(i+1)-1)+Jan_relative_month(i);
                    end
                end
            else
                mm = mm_raw-Sur_start_month;
            end
            dd = day(ctrl_detect_xtick);
            anon_xticklabel = strings([length(mm),1]);
            for i = 1:length(mm)
                anon_xticklabel(i) = ["M"+num2str(mm(i))+"-D"+num2str(dd(i))];
            end
            xticklabels(anon_xticklabel)
        else
            xticklabels(string(datetime(ctrl_detect_xtick,'Format','MMM-dd')))
        end  
        if titleon
            title_str = sprintf("Frequency power along time - %s (%s)",cond_string(3),locations(ch));
            title(title_str,'FontSize', Yctrl_fontsize)
        end
        if saveplot
            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = ;
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
    end 
end

%% Behavioral plot for P3 (Figure 2)
clear;clc;close all
%%%%%%%%%%%%%%%%
patient = "";
saveplot = 1;
%%%%%%%%%%%%%%%%

% save dir
fig_folder = "";
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

switch patient
    case ""
        severe = [1 4 0; 1 3 7];
end

fig = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
hold on
bh = bar(1:2,severe,'stacked');
set(bh,'FaceColor','Flat')
set(bh,'EdgeColor','Flat')
bh(1).FaceColor = [255 0 93]/255;
bh(1).EdgeColor = [255 0 93]/255;
xlim([0.5 2.5])
ylim([0 12])
yticks([0:2:12])
grid on
title("Severe Food Preoccupation Episodes")

if saveplot
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end

%% Figure S4
clear;clc;close all;
set(groot,'defaultAxesFontSize',30)
%%%%%%%%%%%%%%%%%%%%%%%%
patient = "";
annot = '';

saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%

% save dir
fig_folder = "";
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

if isequal(patient,"")
    nepi = [12.7 7.3];
    error = [5.5 4.5];
    FP_epilabels = ["Biomarker Discovery", "Stimulation"];
elseif isequal(patient,"")
    nepi = [9.6 1.3];
    error = [5.5 1.5];
    FP_epilabels = ["Biomarker Discovery", "Stimulation"];
end

fig = figure('units','normalized','outerposition',[0 0 1 1]); 
bh = bar(1:length(FP_epilabels),nepi,'stacked');
hold on
er = errorbar(1:length(FP_epilabels),nepi,error);
er.Color = [0 0 0];
er.LineWidth = 2;
er.LineStyle = 'none';

set(bh,'FaceColor','Flat')
set(bh,'EdgeColor','Flat')
bh(1).FaceColor = [255 0 93]/255;
bh(1).EdgeColor = [255 0 93]/255;
if isequal(patient,'')
    ylim([0 20])
elseif isequal(patient,'')
    ylim([0 20])
end
xticklabels(FP_epilabels)
title("Number of Severe Food Preoccupation Episodes")
grid on

if saveplot
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end

%% Figure S6
%%%%%%%%%%%%%%%%%%%%%%%%
patient = "";
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%

Weight = [];
BMI = [];

fig = figure('units','normalized','outerposition',[0 0 1.5 1]);
t0 = tiledlayout(2,1,'TileSpacing','Compact');
nexttile
plot(weight)
nexttile
plot(BMI)

xticklabels(epilabels)
ylabel("Number of Food Preoccupation Swipes")
title("Number of Food Preoccupation Swipes")
grid on

if saveplot
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end

%% Figure S7
clear;clc;close all;
set(groot,'defaultAxesFontSize',30)
%%%%%%%%%%%%%%%%%%%%%%%%
earlypostsurgery = 1; 
if earlypostsurgery
    annot = 'earlypostsurgery';
else
    annot = '';
end
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%

% save dir
fig_folder = "";
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

nepi = [20,8,nan,...
       15,9,nan,...
       19,2]; 
epilabels = ["Pre-surgery","Postsurgery-Months 2-4 (Avg)","",...
                 "Pre-surgery","Postsurgery-Months 2-4 (Avg)","",...
                 "Pre-surgery","Postsurgery-Months 2-4 (Avg)"];

fig = figure('units','normalized','outerposition',[0 0 1 0.7]);
hold on
bh = bar(1:length(nepi),nepi,'stacked');
set(bh,'FaceColor','Flat')
set(bh,'EdgeColor','Flat')
bh(1).FaceColor = [255 0 93]/255;
bh(1).EdgeColor = [255 0 93]/255;
ylim([0 25])
grid on
set(gca, 'XColor', 'none')
if saveplot
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end

%% Figures S8
clear;clc;close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
patient = "";
ch = 3;
stim = 0;
uptodate =  "";
ver = '';

showplot = 1;
saveplot = 0;
fqoi = [1,7;];
specific_idx = 2; % ignore 3 datapoints which are in July
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir_data = sprintf("",patient);

if ~stim
    stimannot = '';
else
    stimannot = 'stim';
end

% load ratings
if isequal(patient,"")
    if ~stim
        dir_datavar = fullfile(dir_data, sprintf("%s_magnet_ratings_%s",patient,uptodate));
        Ratings = load(dir_datavar);
        apply_specific_ind = 1;
    elseif stim
    end
end
% cut out control
Ratings.Rcraving = Ratings.Rcraving(1:132);
Ratings.Rhunger = Ratings.Rhunger(1:132);  
Ratings.Rthirst = Ratings.Rthirst(1:132);
Ratings.Rloc = Ratings.Rloc(1:132);
Ratings.Rdriven = Ratings.Rdriven(1:132);

% load analysis result
if isequal(patient,"")
    target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
else
    target = sprintf("New%s_magnet_v%s%s_mon%s",patient,ver,stimannot,mon);
end
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);
static_power = static_power(1,1:132);

% get timelist
dataname = "_magnet_%s_%s";
conditions = ["SFPtime","MFPtime"];
dir_excel = sprintf("",patient);
timelist = [];
cnt = 1;
for whatcondition = 1:length(conditions)
    condition = conditions(whatcondition);
    filename = sprintf(dataname,condition,uptodate);
    dir_excelfile = fullfile(dir_excel, filename);
    % call spreadsheet
    list = readcell(dir_excelfile); % datetime var (cell array)
    for i = 1: size(list,1)
        timelist = [timelist, list{i,1}];
        cnt = cnt+1;
    end
end
timelist_search = datetime(timelist,'Format','dd-MMM-yyyy');
[sorted_timelist, sorted_idx] = sort(timelist_search);
sorted_timelist_2plot = sorted_timelist(:,specific_idx:end);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq = static_freq{1};
bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind % want to do ttest up to fq: 20
bandfq = bandfq_idx(1):bandfq_idx(2);

bandpowers = zeros(length(static_power),length(freq));
bandpower_oi = zeros(length(static_power),1);
for i = 1:length(static_power)
    bandpowers(i,:) = static_power{1,i};
    bandpower_oi(i,:) = nanmean(static_power{1,i}(1,bandfq));
end

% Example Data: Power + Ratings over time
raw_data = bandpowers;
raw_data2 = bandpower_oi;
raw_data3 = [Ratings.Rcraving,...
        Ratings.Rhunger,...
        Ratings.Rthirst,...
        Ratings.Rloc,...
        Ratings.Rdriven];
raw_data4 = [bandpower_oi,raw_data3]; % (timepoints - magnet swipes, features)

data = raw_data(sorted_idx,:); % sorted according to date
data = data(specific_idx:end,:); % ignore Month 1
data2 = raw_data2(sorted_idx,:); % sorted according to date
data2 = data2(specific_idx:end,:); % ignore Month 1
data3 = raw_data3(sorted_idx,:); % sorted according to date
data3 = data3(specific_idx:end,:); % ignore Month 1
data4 = raw_data4(sorted_idx,:); % sorted according to date
data4 = data4(specific_idx:end,:); % ignore Month 1

% % Detect a single most significant change point
changePoint = findchangepts(data', 'Statistic', 'rms','MaxNumChanges', 1)
changePoint2 = findchangepts(data2', 'Statistic', 'rms','MaxNumChanges', 1)
changePoint3 = findchangepts(data3', 'Statistic', 'rms','MaxNumChanges', 1)
changePoint4 = findchangepts(data4', 'Statistic', 'rms','MaxNumChanges', 1)

% Plot results
time = 1:size(data2,1);
fig1 = figure('units','normalized','outerposition',[0 0 1 1]);
hold on
t = tiledlayout(4,1,'TileSpacing','Compact');

nexttile
imagesc(time,freq,data') % Freq x Trial
xline(changePoint-0.6, '--r', 'LineWidth', 2);
set(gca,'CLim', [0 5])
xticks([1:30:length(sorted_timelist_2plot)])
xticklabels(["Month2 D7","Month3 D27","Month4 D31","Month6 D7","Month7 D19"]) 

ylim([1 10])
axis xy;
colorbar;
title('Spectrograms from magnet swipes - Participant 3');

nexttile
plot(time, nanmean(data3,2), 'k', 'LineWidth', 2); 
if ~isempty(changePoint3)
    xline(changePoint3, '--r', 'LineWidth', 2);
end
xticks([1:30:length(sorted_timelist_2plot)])
xticklabels(["Month2 D7","Month3 D27","Month4 D31","Month6 D7","Month7 D19"]) 
ylim([0 5])
yticks([1:5])
legend('averaged features (a.u.)','location','northwest')
title('Used 5 different ratings as features');

nexttile
plot(time, nanmean(data2,2), 'k', 'LineWidth', 2); 
xline(changePoint2, '--r', 'LineWidth', 2);
xticks([1:30:length(sorted_timelist_2plot)])
xticklabels(["Month2 D7","Month3 D27","Month4 D31","Month6 D7","Month7 D19"]) 
ylim([0 5])
yticks([1:5])
title('Used 1-7 Hz averaged band power as a feature');

nexttile
plot(time, nanmean(data4,2), 'k', 'LineWidth', 2); 
xline(changePoint4, '--r', 'LineWidth', 2);
xticks([1:30:length(sorted_timelist_2plot)])
xticklabels(["Month2 D7","Month3 D27","Month4 D31","Month6 D7","Month7 D19"]) 
ylim([0 5])
yticks([1:5])
legend('averaged features (a.u.)','location','northwest')
title('Used 1-7 Hz averaged band power and 5 different ratings as features');

if saveplot
    fig_folder = "";
    fig_dir = ""; % figures saved in the folder named "(target)"
    dir_target = fullfile(fig_dir,fig_folder);
    if ~exist(dir_target, 'dir')
      mkdir(dir_target)
    end

    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(fig1,savedir_figure);

    varname_fig = ;
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(fig1,savedir_figure);
end

%% Figure S10
clear; clc; close all
%%%%%%%%%%%%%%%%%%%%%%%%
patient = "";
ch = 1;
stim = 0;

fqoi = [1,7];

showplot = 1;
saveplot = 0;
titleon = 0;
%%%%%%%%%%%%%%%%%%%%%%%%
ver = '';
mon = 'no';
enablemon = 0;
if ~stim
    stimannot = '';
else
    stimannot = 'stim';
end
% uptodate
if isequal(patient,"")
    uptodate = "";
end

% load data - only trial nums
dir_data = sprintf("",patient);
varname = sprintf("%s_magnet_fieldtrip_%s",patient,uptodate);
dir_fullsesdatavar = fullfile(dir_data, varname);
load(dir_fullsesdatavar);

% calculate trial numbers vector 
temp = trial_nums;
ncond = size(trial_nums,2);
trial_nums = zeros(1,ncond);
for i = 1:ncond
    trial_nums(1,i) = temp{2,i};
end

% save dir
fig_folder = "";
fig_dir = ""; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end

% load analysis resultarget
target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
dir_data = sprintf("",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);
static_power = static_power(1,1:132);

% parameters
freq = static_freq{1};
bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind % want to do ttest up to fq: 20
bandfq = bandfq_idx(1):bandfq_idx(2);
staticpower = zeros(length(static_power),length(freq));
bandpower = zeros(length(static_power),1);
for ind = 1:length(static_power)
    staticpower(ind,:) = static_power{ind};
    bandpower(ind,:) = nanmean(static_power{1,ind}(1,bandfq));
end

% directory to get timelists
if isequal(patient,"")
    dir_excel = sprintf("",patient);
end
% data excel file name
dataname = "%s_magnet_%s_%s";
% datetime file name
conditions = ["SFPtime","MFPtime"]; % filename
% get timelist
timelist = [];
cnt = 1;
for whatcondition = 1:length(conditions)
    condition = conditions(whatcondition);
    filename = sprintf(dataname,patient,condition,uptodate);
    dir_excelfile = fullfile(dir_excel, filename);
    % call spreadsheet
    list = readcell(dir_excelfile); % datetime var (cell array)
    for i = 1: size(list,1)
        timelist = [timelist, list{i,1}];
        cnt = cnt+1;
    end
end
timelist_search = datetime(timelist,'Format','dd-MMM-yyyy');
timelist_search = dateshift(timelist_search, 'start', 'day');
[sorted_timelist, sorted_idx] = sort(timelist_search);

% spectrogram
raw_spc = staticpower'; % Freq x Trial
sorted_spc = staticpower(sorted_idx,:)'; % Freq x Trial
sorted_bandpows = bandpower(sorted_idx,:); % Trial

% get SFPdates
filename = sprintf("%s_SFPeatingtime",patient);
dir_excelfile = fullfile(dir_excel, filename);
SFPdates_cell = readcell(dir_excelfile); % datetime var (cell array)
SFPdates = [];
for i = 1: size(SFPdates_cell,1)
    SFPdates = [SFPdates, SFPdates_cell{i,1}];
end
SFPdates = datetime(SFPdates, 'Format', 'dd-MMM-yyyy');
SFPdates = dateshift(SFPdates, 'start', 'day');

% full week range
fulltimewindow = datetime('', 'Format', 'dd-MMM-yyyy'):sorted_timelist(end);
fulltimewindow(weekday(fulltimewindow) == 1) = fulltimewindow(weekday(fulltimewindow) == 1) - days(1);
weekNumbers_full = week(fulltimewindow);
weekNumbers_full(week(fulltimewindow) == 53) = ; % adjust for year change 
weekYear_full = year(fulltimewindow);
weekYear_full(week(fulltimewindow) == 53) = ; % adjust for year change 
uniqueWeeks_full = unique([weekYear_full(:) weekNumbers_full(:)], 'rows');
numWeeks = size(uniqueWeeks_full, 1);

% get how many weeks
sorted_timelist(weekday(sorted_timelist) == 1) = sorted_timelist(weekday(sorted_timelist) == 1) - days(1);
weekNumbers = week(sorted_timelist);  
weekYear = year(sorted_timelist);
uniqueWeeks = unique([weekYear(:) weekNumbers(:)], 'rows');

% get what weeks for SFP
SFPdates(weekday(SFPdates) == 1) = SFPdates(weekday(SFPdates) == 1) - days(1);
SFPweekNumbers = week(SFPdates);
SFPweekYear = year(SFPdates);
SFPuniqueWeeks = unique([SFPweekYear(:) SFPweekNumbers(:)], 'rows');
SFPnumWeeks = size(SFPuniqueWeeks, 1);

% get data vector
range_behavnum = nan(numWeeks,1);
range_bandpowers = nan(numWeeks,1);
for weeknum = 1:numWeeks
    weeks2avg = (weekYear == uniqueWeeks_full(weeknum,1)) & (weekNumbers == uniqueWeeks_full(weeknum,2));
    if sum(weeks2avg) == 0 % no swipes within the week
        range_bandpowers(weeknum) = nan;
    else
        range_bandpowers(weeknum) = nanmean(sorted_bandpows(weeks2avg));
    end
    nSFPinweek = sum((SFPweekYear == uniqueWeeks_full(weeknum,1)) & (SFPweekNumbers == uniqueWeeks_full(weeknum,2)));
    range_behavnum(weeknum) = nSFPinweek;
end

% get idx for dose change
dosechange = datetime('', 'Format', 'dd-MMM-yyyy');
dosechangeidx = find((uniqueWeeks_full(:,1) == year(dosechange)) & (uniqueWeeks_full(:,2) == week(dosechange)))
biomarkerpresent = datetime('', 'Format', 'dd-MMM-yyyy');
biomarkerpresentidx = find((uniqueWeeks_full(:,1) == year(biomarkerpresent)) & (uniqueWeeks_full(:,2) == week(biomarkerpresent)))

% all (aggregate doses)
%%%% Change here %%%%
set(groot,'defaultAxesFontSize',14)
X_fontsize = 14;
Y_fontsize = 16;
YLb_fontsize = 25;
fig_size = [0 0 1.25 0.75];
%%%%%%%%%%%%%%%%%%%%%

if showplot
    fig = figure('units','normalized','outerposition',fig_size);
    plot([1:length(range_behavnum)],range_bandpowers,'-k','LineWidth',2)
    ylabel('Delta-Theta Power (a.u.)','FontSize',YLb_fontsize) 
    xlabel('Week Since Surgery','FontSize',YLb_fontsize)
    ylim([0 4])
    yticks([0:4])
    xlim([1 length(range_behavnum)])
    xticks([5:5:length(range_behavnum)])
    hAx=gca;
    hAx.XAxis.FontSize= X_fontsize;
    hAx.YAxis.FontSize= Y_fontsize;
    hold on
    yyaxis right
    plot([1:length(range_behavnum)],range_behavnum,'Color',[255 22 93]/255,'LineWidth',2)
    % 2nd y-axis
    ylim([0 4])
    yticks([0:4])
    y2 = ylabel("Number of SFP Eating per Week", 'Color',[255 22 93]/255);
    set(y2,'rotation',-90,'VerticalAlignment','bottom')
    ax = gca;
    ax.YAxis(2).Color = [255 22 93]/255;  
    ax.YAxis(2).FontSize = YLb_fontsize;

    if titleon
        title_str = sprintf("%s ch%d",patient,ch);
        title(title_str,'FontSize', YSFP_fontsize)
    end
    if saveplot
        varname_fig = ;
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(gcf,savedir_figure);

        varname_fig = ;
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(gcf,savedir_figure);
    end
end

% cross correlation
[c,lags] = xcorr(range_behavnum(7:end),range_bandpowers(7:end),10,'normalized');
range = (lags >= 5) & (lags <= 10);
c_range = c(range);
lags_range = lags(range);

figure(133)
stem(lags_range,c_range)
lags(c>=0.4)
