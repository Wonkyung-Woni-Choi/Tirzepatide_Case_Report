function wf_static_analysis(patient,target,dir_data,dir_target,dir_fullsesdatavar,ch,stim,magnet,artifact_preclean,showplot,saveplot,epoch_len)
% run static frequency analysis and save results
% also save plots showing what part of the data has been rejected
% saved variables:
% raw_static_FFT - whole fieldtrip output, each trials are chuncked into
% subtrials with subtrlle sec. Chunked trials having stimulation artifacts or artifacts are rejected 
% static_power - static power of the trial (average over subtrials)
% static_freq - frequency range with resolution with which the power values
% are calculated
% subtrlle - subtrial length (# sec)
% raw_chunks - 2 x trials cell: row1 - raw data trace, row2 - time, raw data trace chuncked into # sec length (after artifact rejection).  

    %%
    % load data
    load(dir_fullsesdatavar);

    % initialization
    raw_static_FFT = cell(1,length(trial));
    static_power = cell(1,length(trial));
    static_freq = cell(1,length(trial));
    raw_chunks = cell(2,length(trial)); 

    for ind = 1 : length(trial)   
        % let you know trial # in the command window
        fprintf('%d / %d\n',ind,length(trial));
        
        % data
        data = trial{1,ind}(ch,:);
        data_raw = data; % no artifact removed
    
        %% power analysis - static
        clear temperal* ftdatas ftdatas2
        if magnet
            if length(data_raw) < 25000 % 90 sec
                tmpdata = data_raw(1:89*250); % why raw? A: fieldtrip - cannot calculate power of data having nan
                time_tmp = [-60+1/250:1/250:29];
            else % 180 sec
                tmpdata = data_raw(1:179*250);
                time_tmp = [-120+1/250:1/250:59];
            end
        else
            tmpdata = data_raw;
            time_tmp = time{1,ind};
        end
    
        % Parameters to remove artifacts
        tmpdata_raw = tmpdata;
        tmean = mean(tmpdata);
        tstd = std(tmpdata);
        
        % epoched - removal of artifacts
        if ~stim
            if ~artifact_preclean
                temperal.trial{1} = tmpdata;
                temperal.time{1} = time_tmp;
                temperal.label{1} = 'LFP';

                cfg = [];
                cfg.length = epoch_len; %sec
                subtrllen = cfg.length;
                temperal = ft_redefinetrial(cfg,temperal); %epoch into cgf.length sec chuncks
                
                cnt = 1;
                for i = 1:length(temperal.trial)      
                    artifact_idx = [];
                    [artifacts,artifact_idx] = findpeaks(abs(temperal.trial{i}),[1:length(temperal.trial{i})],'MinPeakProminence',(6*tstd),'MinPeakDistance',1);
                    if isempty(artifact_idx)
                        ftdatas.trial{cnt} = temperal.trial{i};
                        ftdatas.time{cnt} = temperal.time{i};
                        cnt = cnt+1;
                    end
                end
                ftdatas.label{1} = 'LFP';
                ftdatas.fsample = fsample;
            else
                temperal.trial{1} = tmpdata;
                temperal.time{1} = time_tmp;
                temperal.label{1} = 'LFP';

                cfg = [];
                cfg.length = epoch_len; %sec
                subtrllen = cfg.length;
                ftdatas = ft_redefinetrial(cfg,temperal); %epoch into cgf.length sec chuncks
                ftdatas.label{1} = 'LFP';
                ftdatas.fsample = fsample;
            end
        else
            temp = tmpdata;
            % remove stim artifact by recognizing the flat plateau
            % 11 sec prior (where plateau (10 sec) is) and 5 sec post stimulation
            tem = [true,diff(tmpdata) >= 0.1,true]; % true if values change
            tem2 = diff(find(tem)); % number of repetitions
            tem3 = find(tem2 > 125); % find where points have the same value in a row for more than # pts 
            if ~isempty(tem3)
               for idx_stim = 1:length(tem3)
                   temflats = sum(tem2(1:tem3(idx_stim)-1))+1; %index of where this long repetition starts
                   if temflats <= 250
                       tmpdata(1:(temflats+3750)) = nan;
                   elseif (temflats+3750) >= length(temp)
                       tmpdata((temflats-250):end) = nan;
                   else
                       tmpdata((temflats-250):(temflats+3750)) = nan;
                   end
               end
            end
            
            % #1 remove residuals by detecting peaks (1 sec prior to
            % peak, and 8 secs post)
            tempeak = find(abs(tmpdata)>500); 
            if ~isempty(tempeak)
               tempeak2 = find(diff(tempeak)>250)+1; % should be separated at least by 1 sec
               peak_idx = [tempeak(1),tempeak(tempeak2)]; % idx for peaks 
               % remove stim parts as nan
               for idx_peaks = 1:length(peak_idx)
                  if peak_idx(idx_peaks) <= 250
                     tmpdata(1:(peak_idx(idx_peaks)+1250)) = nan;
                  elseif (peak_idx(idx_peaks)+1250) >= length(temp)
                     tmpdata((peak_idx(idx_peaks)-250):end) = nan;
                  else
                     tmpdata((peak_idx(idx_peaks)-250):(peak_idx(idx_peaks)+1250)) = nan;
                  end
               end
            end
            
            % #2 remove residuals by removing flat voltage (only including prior flat voltage)
            temtem = [true,diff(tmpdata) >= 0.1,true]; % true if values change
            temtem2 = diff(find(temtem)); % number of repetitions
            temtem3 = find(temtem2>25); % find where points have the same value in a row for more than # pts 
            if ~isempty(temtem3)
               for idx_flat = 1:length(temtem3)
                   temflats2 = sum(temtem2(1:temtem3(idx_flat)-1))+1; %index of where this long repetition starts
                   tmpdata(temflats2:(temflats2+temtem2(temtem3(idx_flat))-1)) = nan;
               end
            end
            
            % #3 remove residuals by detecting peaks (125 pts prior/post)
            %nanstd = std(tmpdata,"omitnan");
            tempeak = find(abs(tmpdata)> 6*tstd);
            if ~isempty(tempeak)
               tempeak2 = find(diff(tempeak)>250)+1; % should be separated at least by 1 sec
               peak_idx = [tempeak(1),tempeak(tempeak2)]; % idx for peaks 
               % remove stim parts as nan
               for idx_peaks = 1:length(peak_idx)
                  if peak_idx(idx_peaks) <= 125
                     tmpdata(1:(peak_idx(idx_peaks)+125)) = nan;
                  elseif (peak_idx(idx_peaks)+125) >= length(temp)
                     tmpdata((peak_idx(idx_peaks)-125):end) = nan;
                  else
                     tmpdata((peak_idx(idx_peaks)-125):(peak_idx(idx_peaks)+125)) = nan;
                  end
               end
            end

            tstd_af = std(tmpdata,"omitnan");

            % make sure tmpdata is the same length as the beginning
            if length(tmpdata) ~= length(tmpdata_raw)
                tmpdata = tmpdata(1:length(tmpdata_raw));
            end

            if length(tmpdata) < epoch_len*fsample+1 %shorther than epoch_len
                ftdatas.trial = tmpdata;
                ftdatas.time = time_tmp;
                ftdatas.label{1} = 'LFP';
                ftdatas.fsample = fsample;
            else
                temperal.trial{1} = tmpdata;
                temperal.time{1} = time_tmp;
                temperal.label{1} = 'LFP';
                cfg = [];
                cfg.length = epoch_len; %sec
                subtrllen = cfg.length;
                temperal = ft_redefinetrial(cfg,temperal); %epoch into cgf.length sec chuncks

                cnt = 1;
                for i = 1:length(temperal.trial)      
                    if ~anynan(temperal.trial{i})
                        temperal2.trial{cnt} = temperal.trial{i};
                        temperal2.time{cnt} = temperal.time{i};
                        cnt = cnt+1;
                    end
                end
                temperal2.label{1} = 'LFP';
                temperal2.fsample = fsample;

                if isfield(temperal2,'trial')
                    cnt = 1;
                    for i = 1:length(temperal2.trial)      
                        artifact_idx = [];
                        [artifacts,artifact_idx] = findpeaks(abs(temperal2.trial{i}),[1:length(temperal2.trial{i})],'MinPeakProminence',(6*tstd_af),'MinPeakDistance',1);
                        if isempty(artifact_idx)
                            ftdatas.trial{cnt} = temperal2.trial{i};
                            ftdatas.time{cnt} = temperal2.time{i};
                            cnt = cnt+1;
                        end
                    end
                end
                ftdatas.label{1} = 'LFP';
                ftdatas.fsample = fsample;
            end
        end
        
        if isfield(ftdatas,'trial')
            % save raw chuncks
            raw_chunks{1,ind} = ftdatas.trial;
            raw_chunks{2,ind} = ftdatas.time;
    
            % static analysis
            cfg = [];
            cfg.method = 'mtmfft';
            cfg.taper = 'dpss';
            switch epoch_len
                case 2
                    cfg.foi = [1:0.5:120]; % generally, 1/2 of tapsmofrq
                    cfg.tapsmofrq = 1; % smoothing parameters will be the freq resolution in the end
                    % For 10 sec, p = 5, p = W(freq win)*T(time win) = (~0.5) * 10, DoF: 2p-1, (DoF: 5*2 - 1 = 9)  
                    % Thus, freq resolution will be ~ 0.5    
                case 4
                    cfg.foi = [1:0.25:120]; % generally, 1/2 of tapsmofrq
                    cfg.tapsmofrq = 0.5; % smoothing parameters will be the freq resolution in the end
                    % For 10 sec, p = 5, p = W(freq win)*T(time win) = (~0.5) * 10, DoF: 2p-1, (DoF: 5*2 - 1 = 9)  
                    % Thus, freq resolution will be ~ 0.5    
                case 5
                    cfg.foi = [1:0.25:120]; % generally, 1/2 of tapsmofrq
                    cfg.tapsmofrq = 0.5; % smoothing parameters will be the freq resolution in the end
                    % For 10 sec, p = 5, p = W(freq win)*T(time win) = (~0.5) * 10, DoF: 2p-1, (DoF: 5*2 - 1 = 9)  
                    % Thus, freq resolution will be ~ 0.5        
            end
            cfg.output = 'pow';
            cfg.keeptrials  = 'yes';
            cfg.pad= 'nextpow2';
            
            TFRS = ft_freqanalysis(cfg, ftdatas);
           
            %%%%%%%%%%%%%%% What to save %%%%%%%%%%%%%%%%%%%%
            raw_static_FFT{ind} = TFRS;
            if ~isvector(squeeze(TFRS.powspctrm))
                static_power{ind} = nanmean(squeeze(TFRS.powspctrm),1); % trial x ch x freq
            else
                temtemtem = squeeze(TFRS.powspctrm);
                static_power{ind} = temtemtem(:)'; % force it to be row vec
            end
            static_freq{ind} = TFRS.freq;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for test
                temperal3.trial{1} = tmpdata_raw;
                temperal3.time{1} = time_tmp;
                temperal3.label{1} = 'LFP';
                cfg = [];
                cfg.length = epoch_len; %sec
                subtrllen = cfg.length;
                temperal3 = ft_redefinetrial(cfg,temperal3); %epoch into cgf.length sec chuncks
                
                cnt = 1;
                for i = 1:length(temperal3.trial)      
                    if ~anynan(temperal3.trial{i})
                        ftdatas2.trial{cnt} = temperal3.trial{i};
                        ftdatas2.time{cnt} = temperal3.time{i};
                        cnt = cnt+1;
                    end
                end
                ftdatas2.label{1} = 'LFP';
                ftdatas2.fsample = fsample;

                cfg = [];
                cfg.method = 'mtmfft';
                cfg.taper = 'dpss';
                switch epoch_len
                    case 2
                        cfg.foi = [1:0.5:120]; % generally, 1/2 of tapsmofrq
                        cfg.tapsmofrq = 1; % smoothing parameters will be the freq resolution in the end
                        % For 10 sec, p = 5, p = W(freq win)*T(time win) = (~0.5) * 10, DoF: 2p-1, (DoF: 5*2 - 1 = 9)  
                        % Thus, freq resolution will be ~ 0.5    
                    case 4
                        cfg.foi = [1:0.25:120]; % generally, 1/2 of tapsmofrq
                        cfg.tapsmofrq = 0.5; % smoothing parameters will be the freq resolution in the end
                        % For 10 sec, p = 5, p = W(freq win)*T(time win) = (~0.5) * 10, DoF: 2p-1, (DoF: 5*2 - 1 = 9)  
                        % Thus, freq resolution will be ~ 0.5    
                    case 5
                        cfg.foi = [1:0.25:120]; % generally, 1/2 of tapsmofrq
                        cfg.tapsmofrq = 0.5; % smoothing parameters will be the freq resolution in the end
                        % For 10 sec, p = 5, p = W(freq win)*T(time win) = (~0.5) * 10, DoF: 2p-1, (DoF: 5*2 - 1 = 9)  
                        % Thus, freq resolution will be ~ 0.5        
                end
                cfg.output = 'pow';
                cfg.keeptrials  = 'yes';
                cfg.pad= 'nextpow2';
                TFRS2 = ft_freqanalysis(cfg, ftdatas2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            %plot
            if showplot
                temtem = ["static power_"+trialinfo{ind}];
                sgtitle(temtem,'Interpreter','none');
        
                % raw data
                subplot(211)
                plot(time_tmp,tmpdata_raw,'Color',[0 0.4470 0.7410],'LineWidth',2); 
                ylim([-600 600])
                hold on
                if isfield(ftdatas,'trial')
                    if length(tmpdata) < epoch_len*fsample+1 %shorther than epoch_len
                        plot(ftdatas.time,ftdatas.trial,'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
                    else
                        for i = 1:length(ftdatas.trial)
                            plot(ftdatas.time{i},ftdatas.trial{i},'Color',[0.8500 0.3250 0.0980],'LineWidth',2)
                        end
                    end
                    legends = cell(1+length(ftdatas.trial),1);
                else
                    legends = cell(1,1);
                end
                for i = 1:length(legends)
                    if i == 1
                        legends{i} = 'Raw data';
                    elseif i == 3
                        legends{i} = 'stim artifacts removed';
                    else
                        legends{i} = '';
                    end
                end
                legend(legends);
                legend('Location','northwest'); xlabel('sec');
                
                subplot(212)
                if isfield(ftdatas,'trial')
                    if ~isvector(squeeze(TFRS2.powspctrm))
                        plot(TFRS2.freq,nanmean(squeeze(TFRS2.powspctrm),1))
                    else
                        plot(TFRS2.freq,squeeze(TFRS2.powspctrm))
                    end   
                end
                hold on
                if isfield(ftdatas,'trial')
                    if ~isvector(squeeze(TFRS.powspctrm))
                        plot(TFRS.freq,nanmean(squeeze(TFRS.powspctrm),1))
                    else
                        plot(TFRS.freq,squeeze(TFRS.powspctrm))
                    end   
                end
                ylim([0 10])
                xlabel("Freq (Hz)")
                legend("raw","rejected")
            end
        
            % save img
            if saveplot
                varname_fig = sprintf("static_ch%d_block%d_%s.png",ch,ind,trialinfo{1,ind});
                savedir_figure = fullfile(dir_target,varname_fig);
                saveas(gcf,savedir_figure);
                close all
            end 
    end
    varname_result = sprintf("%s_static_ch%d",target,ch);
    dir_result = fullfile(dir_data, varname_result);
    save(dir_result,"raw_static_FFT","static_power","static_freq","subtrllen","raw_chunks");
end