function wf_preprocess(dir_data,patient,totrl,conditions,uptodate,doses,dose_ind_cond, totlength1, timest1, timeend1, totlength2, timest2,timeend2)

    cnt = 1;
    
    % put into fieldtrip, data/time structure
    % initialization
    data = cell(1,totrl);
    time = cell(1,totrl);
    trialinfo = cell(1,length(conditions));
    
    for whatcondition = 1:length(conditions) 
        condition = conditions(whatcondition);
        varname = sprintf("Magnet%s_%s",condition,uptodate);
        dir_datavar = fullfile(dir_data, varname);
        load(dir_datavar);    
        for trls = 1:length(trials_ieeg)
            tpts_num = size(trials_ieeg{1,trls},2);
            if tpts_num < 25000 % 90 sec magnet swipe 
                % data
                temp = trials_ieeg{1,trls};
                data{1,cnt} = temp(:,1:totlength1*250);
                % time
                time{1,cnt} = [timest1+1/250:1/250:timeend1];
            elseif tpts_num < 35000
                % data
                temp = trials_ieeg{1,trls};
                data{1,cnt} = temp(:,1:totlength1*250);
                % time
                time{1,cnt} = [timest1+1/250:1/250:timeend1];
            else % 180 sec magnet swipe
                % data
                temp = trials_ieeg{1,trls};
                data{1,cnt} = temp(:,1:totlength2*250);
                % time
                time{1,cnt} = [timest2+1/250:1/250:timeend2];
            end        
            cnt = cnt+1;
        end
        info = sprintf("Number of trials - %s: %d",condition,length(trials_ieeg));
        trialinfo{1,whatcondition} = info; 
    end
    
    % put into fieldtrip structure
    if isequal(patient,"XX")
        ftdata_XX.trial = data;
        ftdata_XX.time = time;
        ftdata_XX.trialinfo = trialinfo;
        ftdata_XX.label = {'chan 1 - left NAc','chan 2','chan 3 - right NAc','chan 4'};
    elseif isequal(patient,"XX")
        ftdata_XX.trial = data;
        ftdata_XX.time = time;
        ftdata_XX.trialinfo = trialinfo;
        ftdata_XX.label = {'chan 1 - left NAc','chan 2','chan 3 - right NAc','chan 4'};
    elseif isequal(patient,"XX")
        ftdata_XX.trial = data;
        ftdata_XX.time = time;
        ftdata_XX.trialinfo = trialinfo;
        ftdata_XX.label = {'chan 1 - left NAc','chan 2','chan 3 - right NAc','chan 4'};
    end
    
    % save cropped data
    dir_datavar = fullfile(dir_data, sprintf("%s_magnet_raw_%s",patient,uptodate));
    save(dir_datavar, sprintf("ftdata_%s",patient));
    
    % pre-process  
    cfg               = [];
    cfg.bpfilter       = 'yes';
    cfg.bpfreq        = [1,124];
    
    if isequal(patient,"XX")
        proc_XX = ft_preprocessing(cfg,ftdata_XX);
    elseif isequal(patient,"XX")
        proc_XX = ft_preprocessing(cfg,ftdata_XX);
    elseif isequal(patient,"XX")
        proc_XX = ft_preprocessing(cfg,ftdata_XX);
    end
    
    dir_datavar = fullfile(dir_data, sprintf("%s_magnet_proc_%s",patient,uptodate));
    save(dir_datavar,sprintf("proc_%s",patient));
    
    % dissociate struct for convenience   
    [trialinfo, trial_nums] = wf_gettrialinfo(dir_data, conditions,uptodate,totrl,doses,dose_ind_cond);

    if isequal(patient,"XX")
        % dissociate and put into each var
        fsample = proc_XX.fsample;
        sampleinfo = proc_XX.sampleinfo;
        trial = proc_XX.trial;
        time = proc_XX.time;
        label = proc_XX.label;
        cfg = proc_XX.cfg;
    elseif isequal(patient,"XX")
        % dissociate and put into each var
        fsample = proc_XX.fsample;
        sampleinfo = proc_XX.sampleinfo;
        trial = proc_XX.trial;
        time = proc_XX.time;
        label = proc_XX.label;
        cfg = proc_XX.cfg;
    elseif isequal(patient,"XX")
        % dissociate and put into each var
        fsample = proc_XX.fsample;
        sampleinfo = proc_XX.sampleinfo;
        trial = proc_XX.trial;
        time = proc_XX.time;
        label = proc_XX.label;
        cfg = proc_XX.cfg;
    end
    
    % save
    dir_datavar = fullfile(dir_data, sprintf("%s_magnet_fieldtrip_%s",patient,uptodate));
    save(dir_datavar,'fsample','sampleinfo','trial','time','label','cfg','trialinfo','trial_nums');
end