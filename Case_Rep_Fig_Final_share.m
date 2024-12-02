%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Case Report Figure Generating Codes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Figure.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot for ambulatory data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc; close all;
set(0,'DefaultFigureVisible','on');
set(groot,'defaultAxesXTickLabelRotationMode','manual'); %set(groot,'defaultAxesXTickLabelRotationMode','remove')
addpath('C:\Users\XX\XX\XX_XX\scripts\XX\functions');

%%%%%%%%%%%%%%%%%%%%%%%%
patient = "XX";
ch = 1;
stim = 1;
showplot = 1;
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%
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
        uptodate = "stimnewmoncrav_cr";
    end
elseif isequal(patient,"XX")
    uptodate = "cr";
end

% load data - only trial nums
dir_data = sprintf("C:\\Users\\XX\\XX\\XX_XX\\data\\%s\\alldata\\",patient);
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
if isequal(patient,"XX")
    ptname = "Participant 3";
elseif isequal(patient,"XX")
    ptname = "Participant 1";
elseif isequal(patient,"XX")
    ptname = "Participant 2";
end

expcond = "Ambulatory Data";
locations = ["lNAc","lNAc","rNAc","rNAc"];

if isequal(patient,"XX")
    apply_specific_ind = 1;
    specific_ind = [1,0,2]; % [severe,mild,control]
    dose_ind_cond = [5,57,26]; 
    doses = ["Mon.2 - Mon.4","Mon.5 - Mon.7"];
    cond_string_lgnd = [compose("Mild Food\nPreoccupation"),compose("Severe Food\nPreoccupation"),"Control"];
    cond_string = {"Mild Food\newlinePreoccupation","Severe Food\newlinePreoccupation","Control"};
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
    cond_string_lgnd = [compose("Mild Food\nPreoccupation"),compose("Severe Food\nPreoccupation"),"Control"];
    cond_string = {"Mild Food\newlinePreoccupation","Severe Food\newlinePreoccupation","Control"};
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

if isequal(patient,"XX") 
    if ylogon
        if ch == 3
            ylim_bandpower = [[1e-1, 1e1];];
        elseif ch == 1
            ylim_bandpower = [[1e-1, 1e1];];
        end
    else
        ylim_bandpower = [[0, 2];];
    end
elseif isequal(patient,"XX") 
    if ylogon
        ylim_bandpower = [[0.3, 38];];
    else
        ylim_bandpower = [[0, 6];];
    end
elseif isequal(patient,"XX") 
    if ylogon
        ylim_bandpower = [[1e-1, 30];];
    else
        ylim_bandpower = [[0, 20];];
    end
end

if isequal(patient,"XX")
    if ylogon
        y_lim = [5e-3 5e0];
    else
        y_lim = [0 3.5];
    end
elseif isequal(patient,"XX")
    if ylogon
        y_lim = [5e-3 1e1];
    else
        y_lim = [0 11];
    end
elseif isequal(patient,"XX")
    if ylogon
        y_lim = [5e-3 1e1];
    else
        y_lim = [0 10];
    end
end

x_lim = [1 100];%freq

if isequal(patient,"XX")
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
fig_folder = "XX";
fig_dir = "C:\Users\XX\XX\XX_XX\scripts\XX\figures"; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end
% load analysis result
target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
dir_data = sprintf("C:\\Users\\XX\\XX\\XX_XX\\data\\%s\\alldata\\",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);
varname_result = sprintf("%s_ch%d_snip_cr",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);

freq = static_freq{1};

% plot examplary waveform
close all;
xt = [0:1/250:10];

if ~stim
    if isequal(patient,"XX")
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
        % mild
        time2plot = [-56,-46];
        trl = 52;
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-150,'Color',[255 154 0]/255)
        % severe
        time2plot = [-38,-28];
        trl = 5;%4;
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
        % mild
        time2plot = [-84,-74];
        trl = 128;
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-150,'Color',[255 154 0]/255)
        % severe
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
    elseif isequal(patient,"XX")
        fig = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
        axis off
        hold on
        % control
        time2plot = [-24,-14];
        trl = 161;
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2)),'Color',[62 193 211]/255)
        % mild
        time2plot = [-27,-17];
        trl = 32;
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-150,'Color',[255 154 0]/255)
        % severe
        time2plot = [-16,-6];
        trl = 21;
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-300,'Color',[255 22 93]/255)
        % measure
        plot([9+1/250:1/250:10],-340*ones(length([9+1/250:1/250:10]),1),'Color','k','LineWidth',2) % 1 sec
        plot(ones(length(-25:25),1)*0,[-25:25],'Color','k','LineWidth',2) % 50 uV
        ylim([-400,50])
    
        if sgtitleon
            sgtitle_str = sprintf("%s",ptname);
            sgtitle(sgtitle_str,'Fontsize',sgtisz,'FontWeight','bold')
        end    
    elseif isequal(patient,"XX")
        fig = figure('units','normalized','outerposition',[0 0 0.5 0.5]);
        axis off
        hold on
        % control
        if enablemon
            trl = 22;
            time2plot = [-100,-90];
        else
            trl = 125;
            time2plot = [-34,-24];
        end
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2)),'Color',[62 193 211]/255)
        % mild
        if enablemon
            trl = 21;
            time2plot = [-53,-43];
        else
            trl = 96;
            time2plot = [-96,-86];
        end
        tidxs = dsearchn(time{1,trl}',time2plot');
        plot(xt,trial{1,trl}(ch,tidxs(1):tidxs(2))-150,'Color',[255 154 0]/255)
        % severe
        if enablemon
            trl = 6;
            time2plot = [-76,-66];
        else
            trl = 51;
            time2plot = [-116,-106];
        end
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
        varname_fig = sprintf("%s_examplary_spectra_ch%d.png",patient,ch);
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(gcf,savedir_figure);
    
        varname_fig = sprintf("%s_examplary_spectra_ch%d.svg",patient,ch);
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(gcf,savedir_figure);
    end
end

cluster_corr = {};
cnt = 1;
% Spectrum and box whisker plots 
if isequal(patient,"XX")
    fig1 = figure('units','normalized','outerposition',[0 0 0.5 2]);
    t1 = tiledlayout(2,1,'TileSpacing','Compact');
    for dose = 1:length(doses)
        if dose == 1 
            con1 = eachspec_t1_s; % Trial x Freq
            con2 = eachspec_t1_m; % Trial x Freq
            control = eachspec_t1_c; % Trial x Freq
        else
            con1 = eachspec_t2_s; % Trial x Freq
            con2 = eachspec_t2_m; % Trial x Freq
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
            % Condition2
            db_changes_1 = con2;
            STE=squeeze(nanstd(db_changes_1,[],1)/sqrt((size(db_changes_1,1))));
            ck_shadedErrorBar(freq,nanmean(db_changes_1,1),STE,[255 154 0]/255,1);
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
            cluster_pval = 0.15;
            npermutes = 1000;
            rng(102)
            [zmap, zmapthresh, zmapthresh_correc] = cluster_permutation_1d_XX(condition1,condition2,numcond1,numcond2,pval,tail,cluster_pval,npermutes);
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
            lgnd = legend(cond_string_lgnd(1,3)+" (n="+num2str(size(control,1))+")",'',cond_string_lgnd(1,1)+" (n="+num2str(size(con2,1))+")",'',cond_string_lgnd(1,2)+" (n="+num2str(size(con1,1))+")","location","northeast");
            if ~titleon
                dim = lgnd.Position + [0.07 -0.08 0 0]; % [x y w h]
                pstr = {sprintf("%s", dose_amount)};
                annotation('textbox',dim,'String',pstr,'FitXXToText','on','EdgeColor','none','FontSize',16);
            end
            grid on
        end
    end
    %box-whisker
    for i = 1:size(interested_bandpowers,1)
        fig2 = figure('units','normalized','outerposition',[0 0 0.5 2]);
        t2 = tiledlayout(2,1,'TileSpacing','Compact');
        y_lim = ylim_bandpower(i,:);
        [~,mind] = max(abs(y_lim));
        fqoi = interested_bandpowers(i,:);
        bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind % want to do ttest up to fq: 20
        bandfq = bandfq_idx(1):bandfq_idx(2);

        for dose = 1:length(doses)
            if dose == 1 
                con1 = eachspec_t1_s; % Trial x Freq
                con2 = eachspec_t1_m; % Trial x Freq
                control = eachspec_t1_c; % Trial x Freq
            else
                con1 = eachspec_t2_s; % Trial x Freq
                con2 = eachspec_t2_m; % Trial x Freq
                control = eachspec_t2_c; % Trial x Freq
            end
            dose_amount = doses(1,dose); 
            control_band = nanmean(control(:,bandfq),2);
            cond1_band = nanmean(con1(:,bandfq),2);
            cond2_band = nanmean(con2(:,bandfq),2);
            if i == 1 % delta
                delta_band_power{1,(dose-1)*3+1} = control_band;
                delta_band_power{1,(dose-1)*3+2} = cond1_band;
                delta_band_power{1,(dose-1)*3+3} = cond2_band;
            end    
            length_bandfq = length(bandfq); 
            
            if showplot
                nexttile
                x_cont = ones(1,length(control_band))';
                x_cond1 = 3 * ones(1,length(cond1_band))';
                x_cond2 = 2 * ones(1,length(cond2_band))';
                y_cont = control_band;
                y_cond1 = cond1_band;
                y_cond2 = cond2_band;
                
                tot_x = [x_cont;x_cond2;x_cond1];
                tot_y = [y_cont;y_cond2;y_cond1];
                boxplot(tot_y,tot_x,'Colors',[[62 193 211]/255;[255 154 0]/255;[255 22 93]/255],...
                'Labels',[cond_string{1,3},cond_string{1,1},cond_string{1,2}]);
                hold on
                ax = gca;
                ax.TickLabelInterpreter = 'tex';
                outlier = findobj(gcf,'tag','Outliers');
                for oo = 1:numel(outlier)
                    if oo == 3 || oo == 6
                        outlier(oo).MarkerEdgeColor = [62 193 211]/255;
                    elseif oo == 2 || oo == 5
                        outlier(oo).MarkerEdgeColor = [255 154 0]/255;
                    elseif oo == 1 || oo == 4
                        outlier(oo).MarkerEdgeColor = [255 22 93]/255;
                    end
                end                
                h1_d2 = 0;
                h2_d2 = 0;
                h3_d2 = 0;
                % permutation testing
                rng(102)
                perm_ctcd2 = perm_mdiff(control_band,cond2_band,10000) % vec2-vec1
                if perm_ctcd2 <= 0.05
                    h1_d2 = 1;
                end
                rng(102)
                perm_ctcd1 = perm_mdiff(control_band,cond1_band,10000) 
                if perm_ctcd1 <= 0.05
                    h2_d2 = 1;
                end
                rng(102)
                perm_cd2cd1 = perm_mdiff(cond2_band,cond1_band,10000)
                if perm_cd2cd1 <= 0.05
                    h3_d2 = 1;
                end
                if i == 1 % delta
                    perm_result(dose,1) = perm_ctcd2; % control vs. mild
                    perm_result(dose,2) = perm_ctcd1; % control vs. severe
                    perm_result(dose,3) = perm_cd2cd1; % mild vs. severe
                end

                % draw * if significant
                if h2_d2 == 1
                    if ylogon
                       yv =  [0.73; 0.83];
                    else
                       yv  = [0.78; 0.8];
                    end
                    plot([0.8,3.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                    plot(2, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                end
                if h1_d2 == 1
                    if ylogon
                       yv =  [0.59; 0.66];
                    else
                       yv  = [0.78; 0.8];
                    end
                    plot([0.8,2.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                    plot(1.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                end
                if h3_d2 == 1
                if ylogon
                       yv =  [0.52; 0.59];
                    else
                       yv  = [0.78; 0.8];
                    end
                    plot([1.8,3.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                    plot(2.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
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
                if annoton
                    if dose == 1
                        dim = [0.415 0.56 0.35 0.35];
                    else
                        dim = [0.415 0.16 0.35 0.35];   
                    end
                    pstr = {sprintf("p-value (Control vs. severe): %.3f",perm_ctcd1),sprintf("p-value (Control vs. mild): %.3f",perm_ctcd2),sprintf("p-value (severe vs. mild): %.3f",perm_cd2cd1)};
                    annotation('textbox',dim,'String',pstr,'FitXXToText','on');
                end   
            end

            if saveplot
                varname_fig = sprintf("%s_bandpower_ch%d_%s%s.png",patient,ch,interested_bandpowers_str_filesave(i),annotopt);
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(fig2,savedir_figure);
        
                varname_fig = sprintf("%s_bandpower_ch%d_%s%s.svg",patient,ch,interested_bandpowers_str_filesave(i),annotopt);
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(fig2,savedir_figure);
            end
        end
    end      

    if saveplot
        varname_fig = sprintf("%s_linepower_all_ch%d.png",patient,ch);
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(fig1,savedir_figure);

        varname_fig = sprintf("%s_linepower_all_ch%d.svg",patient,ch);
        savedir_figure = fullfile(dir_target,varname_fig);
        saveas(fig1,savedir_figure);
    end
else
    for dose = 1:length(doses)
        con1 = eachspec_t1_s; % Trial x Freq
        if ~(isequal(patient,"XX") && stim)
                con2 = eachspec_t1_m; % Trial x Freq
        end
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
            % Condition2
            if ~(isequal(patient,"XX") && stim)
                db_changes_1 = con2;
                STE=squeeze(nanstd(db_changes_1,[],1)/sqrt((size(db_changes_1,1))));
                ck_shadedErrorBar(freq,nanmean(db_changes_1,1),STE,[255 154 0]/255,1);
            end
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
            pval = 0.05;
            tail = 2; % two tails
            cluster_pval = 0.15;
            npermutes = 1000;
            rng(102)
            [zmap, zmapthresh, zmapthresh_correc] = cluster_permutation_1d_XX(condition1,condition2,numcond1,numcond2,pval,tail,cluster_pval,npermutes);
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
            if ~(isequal(patient,"XX") && stim)
                lgnd = legend(cond_string_lgnd(1,3)+" (n="+num2str(size(control,1))+")",'',cond_string_lgnd(1,1)+" (n="+num2str(size(con2,1))+")",'',cond_string_lgnd(1,2)+" (n="+num2str(size(con1,1))+")","location","northeast");
            else
                lgnd = legend(cond_string_lgnd(1,3)+" (n="+num2str(size(control,1))+")",'',cond_string_lgnd(1,2)+" (n="+num2str(size(con1,1))+")",'','',cond_string_lgnd(1,1)+" (n="+num2str(0)+")",'',"location","northeast");
            end
            grid on
        end
        if saveplot
            varname_fig = sprintf("%s_linepower_all_ch%d_%s.png",patient,ch,dose_amount);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = sprintf("%s_linepower_all_ch%d_%s.svg",patient,ch,dose_amount);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
        
        % box whisker
        for i = 1:size(interested_bandpowers,1)
            y_lim = ylim_bandpower(i,:);
            [~,mind] = max(abs(y_lim));
            fqoi = interested_bandpowers(i,:);
            bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind % want to do ttest up to fq: 20
            bandfq = bandfq_idx(1):bandfq_idx(2);
    
            control_band = nanmean(control(:,bandfq),2);
            cond1_band = nanmean(con1(:,bandfq),2);
            if ~(isequal(patient,"XX") && stim)
            cond2_band = nanmean(con2(:,bandfq),2);
            end
            if i == 1
                delta_band_power{1,(dose-1)*3+1} = control_band;
                delta_band_power{1,(dose-1)*3+2} = cond1_band;
                if ~(isequal(patient,"XX") && stim)
                delta_band_power{1,(dose-1)*3+3} = cond2_band;
                end
            end    
            length_bandfq = length(bandfq); 
            
            if showplot
                fig = figure('units','normalized','outerposition',[0 0 0.75 1]);
                x_cont = ones(1,length(control_band))';
                if ~(isequal(patient,"XX") && stim)
                    x_cond1 = 3 * ones(1,length(cond1_band))';
                    x_cond2 = 2 * ones(1,length(cond2_band))';
                    y_cond2 = cond2_band;
                else 
                    x_cond1 = 2 * ones(1,length(cond1_band))';
                end
                y_cont = control_band;
                y_cond1 = cond1_band;
                            
                if ~(isequal(patient,"XX") && stim)
                    tot_x = [x_cont;x_cond2;x_cond1];
                    tot_y = [y_cont;y_cond2;y_cond1];
                else
                    tot_x = [x_cont;x_cond1];
                    tot_y = [y_cont;y_cond1];
                end
                if ~(isequal(patient,"XX") && stim)
                    boxplot(tot_y,tot_x,'Colors',[[62 193 211]/255;[255 154 0]/255;[255 22 93]/255],...
                        'Labels',[cond_string{1,3},cond_string{1,1},cond_string{1,2}]);
                else
                    boxplot(tot_y,tot_x,'Colors',[[62 193 211]/255;[255 22 93]/255],...
                    'Labels',[cond_string{1,3},cond_string{1,2}]);
                end
                hold on
                ax = gca;
                ax.TickLabelInterpreter = 'tex';
                outlier = findobj(gcf,'tag','Outliers');
                if ~(isequal(patient,"XX") && stim)
                    for oo = 1:numel(outlier)
                        if oo == 3 || oo == 6
                            outlier(oo).MarkerEdgeColor = [62 193 211]/255;
                        elseif oo == 2 || oo == 5
                            outlier(oo).MarkerEdgeColor = [255 154 0]/255;
                        elseif oo == 1 || oo == 4
                            outlier(oo).MarkerEdgeColor = [255 22 93]/255;
                        end
                    end 
                else
                    for oo = 1:numel(outlier)
                        if oo == 2 || oo == 6
                            outlier(oo).MarkerEdgeColor = [62 193 211]/255;
                        elseif oo == 1 || oo == 4
                            outlier(oo).MarkerEdgeColor = [255 22 93]/255;
                        end
                    end 
                end
                h1_d2 = 0;
                h2_d2 = 0;
                h3_d2 = 0;
                % permutation testing
                if ~(isequal(patient,"XX") && stim)
                    rng(102)
                    perm_ctcd2 = perm_mdiff(control_band,cond2_band,10000) % vec2-vec1
                    if perm_ctcd2 <= 0.05
                        h1_d2 = 1;
                    end
                    rng(102)
                    perm_ctcd1 = perm_mdiff(control_band,cond1_band,10000) 
                    if perm_ctcd1 <= 0.05
                        h2_d2 = 1;
                    end
                    rng(102)
                    perm_cd2cd1 = perm_mdiff(cond2_band,cond1_band,10000)
                    if perm_cd2cd1 <= 0.05
                        h3_d2 = 1;
                    end
                else
                    rng(102)
                    perm_ctcd1 = perm_mdiff(control_band,cond1_band,10000) 
                    if perm_ctcd1 <= 0.05
                        h2_d2 = 1;
                    end
                end
                % draw * if significant
                if ~(isequal(patient,"XX") && stim)
                    if h2_d2 == 1
                       if ylogon
                           yv =  [0.73; 0.83];
                       else
                           yv  = [0.78; 0.8];
                       end
                       plot([0.8,3.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                       plot(2, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                    end
                else
                    if h2_d2 == 1
                       if ylogon
                           yv =  [0.59; 0.66];
                       else
                           yv  = [0.78; 0.8];
                       end
                       plot([0.8,2.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                       plot(1.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                    end
                end
                if h1_d2 == 1
                   if ylogon
                       yv =  [0.59; 0.66];
                   else
                       yv  = [0.78; 0.8];
                   end
                   plot([0.8,2.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                   plot(1.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
                end
                if h3_d2 == 1
                   if ylogon
                       yv =  [0.52; 0.59];
                   else
                       yv  = [0.78; 0.8];
                   end
                   plot([1.8,3.2], [1,1]*(y_lim(mind)*yv(1)), '-k', 'LineWidth',1)
                   plot(2.5, y_lim(mind)*yv(2), '*k', 'LineWidth',0.8)
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

                if annoton 
                    dim = [0.415 0.56 0.35 0.35]; % [x y w h]
                    pstr = {sprintf("p-value (Control vs. severe): %.4f",perm_ctcd1),sprintf("p-value (Control vs. mild): %.4f",perm_ctcd2),sprintf("p-value (severe vs. mild): %.4f",perm_cd2cd1)};
                    annotation('textbox',dim,'String',pstr,'FitXXToText','on');
                end
                if titleon
                    title_str = sprintf("%s",ptname);
                    title(title_str,'FontSize',tisz);
                end
            end        
            if saveplot
                varname_fig = sprintf("%s_bandpower_ch%d_%s_%s%s.png",patient,ch,interested_bandpowers_str_filesave(i),dose_amount,annotopt);
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(gcf,savedir_figure);

                varname_fig = sprintf("%s_bandpower_ch%d_%s_%s%s.svg",patient,ch,interested_bandpowers_str_filesave(i),dose_amount,annotopt);
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(gcf,savedir_figure);
            end
        end
    end
end

%% Figure 1
clear;clc;close all

%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
patient = "XX";
ch = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uptodate
if isequal(patient,"XX") 
    if ~stim
        if isequal(mon,"newmon")
            uptodate = "stimnewmoncrav";
        else
            uptodate = "prestimoldmoncrav";
        end
    else
        uptodate = "stimrealnewmoncrav_cr";
    end
elseif isequal(patient,"XX")
    if ~stim
        uptodate = "prestimnewmoncrav";
    else
        uptodate = "stimnewmoncrav_cr";
    end
elseif isequal(patient,"XX")
    uptodate = "cr";
end

% timeline bandpower plot
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

%%%%%%%%%%%%% Change here %%%%%%%%%%%%%%%%%%%%%
ver = 'cr';
stimannot = '';

uptodate = "cr";
detect_uptodate = uptodate;
% detection
if ch == 3
    detect_uptodate = "cr_ch3";
end

% data excel file name
dataname = "XX_magnet_%s_%s";
% detection file name
detectionname = "XX_magnet_%s_%s";
locations = ["left NAc","left NAc","right NAc","right NAc"];

apply_specific_ind = 1;
specific_ind = [1,0,2];
conditions = ["Severetime","Mildtime","Normaltime"];
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
fig_folder = "Case_report_v10";
fig_dir = "C:\Users\XX\XX\XX_XX\scripts\XX\figures"; % figures saved in the folder named "(target)"
dir_target = fullfile(fig_dir,fig_folder);
if ~exist(dir_target, 'dir')
  mkdir(dir_target)
end
% load analysis resultarget
target = sprintf("New%s_magnet_v%s%s",patient,ver,stimannot);
dir_data = sprintf("C:\\Users\\XX\\XX\\XX_XX\\data\\%s\\alldata\\",patient);
varname_result = sprintf("%s_static_ch%d",target,ch);
dir_result = fullfile(dir_data, varname_result);
load(dir_result);
% directory to get timelists/detections
dir_excel = sprintf("C:\\Users\\XX\\XX\\XX_X\\data\\XX\\XX_XX_XX EXTERNAL #PHI\\%s_magnet_cr",patient);

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
idx_severe_dose = cell(length(doses),1);
idx_mild_dose = cell(length(doses),1);
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
       idx_severe_dose{dose_idx,1} = [idx_severe_dose{dose_idx,1}, i];
    elseif i <= sum(trial_nums(1:2)) 
       if i <= (dose_ind_cond(2) + trial_nums(1))
          dose_idx = 1;
       else
          dose_idx = 2;
       end
       idx_mild_dose{dose_idx,1} = [idx_mild_dose{dose_idx,1}, i];
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
    idx_severe_dose{1,1} = idx_severe_dose{1,1}(1,2:end);
    idx_normal_dose{1,1} = idx_normal_dose{1,1}(1,3:end);    
end

idx_severe_dose_all = [];
idx_mild_dose_all = [];
idx_normal_dose_all = [];
idx_etc_dose_all = [];
for dose = 1:2
    idx_severe_dose_all = [idx_severe_dose_all, idx_severe_dose{dose,1}];
    idx_mild_dose_all = [idx_mild_dose_all, idx_mild_dose{dose,1}];
    idx_normal_dose_all = [idx_normal_dose_all, idx_normal_dose{dose,1}];
    idx_etc_dose_all = [idx_etc_dose_all, idx_etc_dose{dose,1}];
end

% all (aggregate doses)
close all;

%%%% Change here %%%%
colorlim = [0 5];
set(groot,'defaultAxesFontSize',14)
Xsevere_fontsize = 14;
Xm_fontsize = 14;
Xctrl_fontsize = 14;
Ysevere_fontsize = 16;
Ym_fontsize = 16;
Yctrl_fontsize = 16;
YLsevere_fontsize = 25;
YLm_fontsize = 25;
YLctrl_fontsize = 25;
severe_fig_size = [0 0 0.5 0.75];
m_fig_size = [0 0 1.25 0.75];
ctrl_fig_size = [0 0 0.5 0.75];

anonymity = 1; % change to months relative to surgery for patient's privacy
Sur_start_month = [6]; % how many months should subtract to get month relative to surgery before year changes
% ex. July: month1, then 6./ex. April: month1, then 3.
Jan_relative_month = [6];% what number should add to make Jan to relative month (e.x. if Jan -> Month 7, +6)
%%%%%%%%%%%%%%%%%%%%%

severe = staticpower(idx_severe_dose_all,:)'; % Freq x Trial
mild = staticpower(idx_mild_dose_all,:)'; % Freq x Trial
control = staticpower(idx_normal_dose_all,:)'; % Freq x Trial

% get delta-bandpower
fqoi = [1,4];
bandfq_idx = dsearchn(freq',[fqoi(1);fqoi(2)])'; % gives start & stop ind % want to do ttest up to fq: 20
bandfq = bandfq_idx(1):bandfq_idx(2);
severe_delta = nanmean(severe(bandfq,:),1); % 1 x Trial
rm_delta = nanmean(mild(bandfq,:),1); % 1 x Trial
ctrl_delta = nanmean(control(bandfq,:),1); % 1 x Trial

dose_amount = doses(1,dose);

severe_xtick = timelist(1,idx_severe_dose_all); % datetime 1 x # array
rm_xtick = timelist(1,idx_mild_dose_all);
ctrl_xtick = timelist(1,idx_normal_dose_all);

severe_detect_xtick = swipedates(1,idx_severe_dose_all);
severe_detect_nums = swipedates_detect(1,idx_severe_dose_all);
rm_detect_xtick = swipedates(1,idx_mild_dose_all);
rm_detect_nums = swipedates_detect(1,idx_mild_dose_all);
ctrl_detect_xtick = swipedates(1,idx_normal_dose_all);
ctrl_detect_nums = swipedates_detect(1,idx_normal_dose_all);

% Detection
if showplot
    % severe - detection numbers
    if showdetectionplot
        fig = figure('units','normalized','outerposition',severe_fig_size);
        imagesc([1:length(severe_xtick)],freq,severe)
        ylabel('Frequency (Hz)','FontSize',YLsevere_fontsize)
        ylim([1 10])
        xticks([1:length(severe_xtick)])
        hAx=gca;
        hAx.XAxis.TickLabelRotation=90;
        hAx.XAxis.FontSize= Xsevere_fontsize;
        hAx.YAxis.FontSize= Ysevere_fontsize;
        colorbar;
        axis xy;
        set(gca,'CLim', colorlim);
        hold on
        yyaxis right
        plot([1:length(severe_detect_xtick)],severe_detect_nums,'-r','LineWidth',2)
        xticks([1:length(severe_detect_xtick)])
        if anonymity
            mm_raw = month(severe_detect_xtick);
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
            dd = day(severe_detect_xtick);
            anon_xticklabel = strings([length(mm),1]);
            for i = 1:length(mm)
                anon_xticklabel(i) = ["M"+num2str(mm(i))+"-D"+num2str(dd(i))];
            end
            xticklabels(anon_xticklabel)
        else
            xticklabels(string(datetime(severe_detect_xtick,'Format','MMM-dd')))  
        end             
        y2 = ylabel('Number of detections / Day');
        set(y2,'rotation',-90,'VerticalAlignment','bottom')
        ax = gca;
        ax.YAxis(2).Color = 'r';  
        ax.YAxis(2).FontSize = Ysevere_fontsize;
        ylim([0,1600]);
        if titleon
            title_str = sprintf("Frequency power along time - %s (%s)",cond_string(2),locations(ch));
            title(title_str,'FontSize', Ysevere_fontsize)
        end
        if saveplot
            varname_fig = sprintf("Alldoses_power_timeline_detection_%s_ch%d.png",cond_string(2),ch);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = sprintf("Alldoses_power_timeline_detection_%s_ch%d.svg",cond_string(2),ch);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
    end
    % Mild - detection plot
    if showdetectionplot
        fig = figure('units','normalized','outerposition',m_fig_size);
        %outerposition: wrt monitor and fig window, [left mon-win, bottom mon-win, width of fig win, height of fig win]
        imagesc([1:length(rm_xtick)],freq,mild)
        axis xy;
        ylabel('Frequency (Hz)','FontSize',YLm_fontsize)
        ylim([1 10])
        xticks([1:length(rm_xtick)])
        hAx=gca;
        hAx.XAxis.TickLabelRotation=90;
        hAx.XAxis.FontSize= Xm_fontsize;
        hAx.YAxis.FontSize= Ym_fontsize;
        colorbar;
        set(gca,'CLim', colorlim);
        hold on
        yyaxis right
        plot([1:length(rm_detect_xtick)],rm_detect_nums,'-r','LineWidth',2)
        xticks([1:length(rm_detect_xtick)])
        if anonymity
            mm_raw = month(rm_detect_xtick);
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
            dd = day(rm_detect_xtick);
            anon_xticklabel = strings([length(mm),1]);
            for i = 1:length(mm)
                anon_xticklabel(i) = ["M"+num2str(mm(i))+"-D"+num2str(dd(i))];
            end
            xticklabels(anon_xticklabel)
        else
             xticklabels(string(datetime(rm_detect_xtick,'Format','MMM-dd'))) 
        end  
        y2 = ylabel('Number of detections / Day');
        set(y2,'rotation',-90,'VerticalAlignment','bottom')
        ax = gca;
        ax.YAxis(2).Color = 'r';
        ax.YAxis(2).FontSize= Ym_fontsize;
        ylim([0,1600]);
        if titleon
            title_str = sprintf("Frequency power along time - %s (%s)",cond_string(1),locations(ch));
            title(title_str,'FontSize', Ym_fontsize)
        end
        if saveplot
            varname_fig = sprintf("Alldoses_power_timeline_detection_%s_ch%d.png",cond_string(1),ch);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = sprintf("Alldoses_power_timeline_detection_%s_ch%d.svg",cond_string(1),ch);
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
        yyaxis right
        plot([1:length(ctrl_detect_xtick)],ctrl_detect_nums,'-r','LineWidth',2)
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
        y2 = ylabel('Number of detections / Day');
        set(y2,'rotation',-90,'VerticalAlignment','bottom')
        ax = gca;
        ax.YAxis(2).Color = 'r';
        ax.YAxis(2).FontSize=Yctrl_fontsize;
        ylim([0,1600]);
        if titleon
            title_str = sprintf("Frequency power along time - %s (%s)",cond_string(3),locations(ch));
            title(title_str,'FontSize', Yctrl_fontsize)
        end
        if saveplot
            varname_fig = sprintf("Alldoses_power_timeline_detection_%s_ch%d.png",cond_string(3),ch);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);

            varname_fig = sprintf("Alldoses_power_timeline_detection_%s_ch%d.svg",cond_string(3),ch);
            savedir_figure = fullfile(dir_target,varname_fig);
            saveas(gcf,savedir_figure);
        end
    end 
end

%% Behavioral plots

%%%%%%%%%%%%%%%%%%%%%%%%
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%

LOC_episodes = [19,2,1,3,0,1,3,7];
LOC_epilabels = ["Pre-surgery","Month 1","Month 2","Month 3","Month 4","Month 5","Month 6","Month 7"];
LOC_severity = [6.89,0.22,0.89,1.17,4.17];
LOC_sevlabels = ["Pre-surgery","Month 2","Month 3","Month 6","Month 8"];

fig = figure('units','normalized','outerposition',[0 0 1.25 1]);
bar(1:length(LOC_episodes),LOC_episodes,'FaceColor',[255 22 93]/255,'EdgeColor',[255 22 93]/255)
xticklabels(LOC_epilabels)
ylabel("Number of LOC Episodes")
title("Participant-reported Number of Loss of Control Eating Episodes")
grid on
if saveplot
    varname_fig = sprintf("LOC_frequency_bar.png");
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = sprintf("LOC_frequency_bar.svg");
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end

fig = figure('units','normalized','outerposition',[0 0 0.75 1]);
bar(1:length(LOC_severity),LOC_severity,'FaceColor',[255 22 93]/255,'EdgeColor',[255 22 93]/255)
xticks(1:length(LOC_severity))
xticklabels(LOC_sevlabels)
ylabel("Severity Score")
title("LOC Eating Severity (ELOCS)")
grid on
if saveplot
    varname_fig = sprintf("LOC_severity_bar.png");
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = sprintf("LOC_severity_bar.svg");
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end
%% Behavioral plots 2

%%%%%%%%%%%%%%%%%%%%%%%%
patient = "XX";
saveplot = 1;
%%%%%%%%%%%%%%%%%%%%%%%%

if isequal(patient,"XX")
    nfp = [9,12,7,3;15,3,2,2];
    fp_epilabels = ["Earlystim-Month 1","Postmax-Month 1","Postmax-Month 2","Postmax-Month 3"];
elseif isequal(patient,"XX")
    nfp = [8,4,17,8,2,0,3,0;45,42,51,42,9,17,15,15];
    fp_epilabels = ["Prestim-Month 3","Prestim-Month 4","Prestim-Month 5","Prestim-Month 6","Postmax-Month 1","Postmax-Month 2","Postmax-Month 3","Postmax-Month 4"];
end

fig = figure('units','normalized','outerposition',[0 0 1.5 1]);
bh = bar(1:length(fp_epilabels),nfp,'stacked');
set(bh,'FaceColor','Flat')
set(bh,'EdgeColor','Flat')
bh(1).FaceColor = [255 0 93]/255;
bh(1).EdgeColor = [255 0 93]/255;
bh(2).FaceColor = [255 154 0]/255;
bh(2).EdgeColor = [255 154 0]/255;

xticklabels(fp_epilabels)
ylabel("Number of Food Preoccupation Swipes")
title("Number of Food Preoccupation Swipes")
grid on

if saveplot
    varname_fig = sprintf("%s_FP_frequency_bar.png",patient);
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
    
    varname_fig = sprintf("%s_FP_frequency_bar.svg",patient);
    savedir_figure = fullfile(dir_target,varname_fig);
    saveas(gcf,savedir_figure);
end
