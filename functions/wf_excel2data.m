function wf_excel2data(dir_excel,dir_data,patient,conditions,uptodate)
    
    % input
    % dir_excel: directory to excel
    % dir_data: directory where to save data
    % patient, conditions, uptodate should match the name of spreadsheet
    % patient: patient initial, e.g. AB, CD
    % conditions: conditions for swipes
    % uptodate: version of the spreadsheet
    
    % output
    % Magnet(condition).dat file with trials ieeg var
    % trials_ieeg: cell 1 x trials, each cell has 4 chs x tpts 
    % Also, save excel spreadsheet as list_Magnet(condition) with list var
    
    for whatcondition = 1:length(conditions)
        condition = conditions(whatcondition);
        sprintf("%s",condition)
        %% save list variables at alldata
        % create directory to call the spreadsheet
        name = "%s_magnet_%s_%s";
        filename = sprintf(name,patient,condition,uptodate);
        dir_excelfile = fullfile(dir_excel, filename);
        % call spreadsheet
        list = readcell(dir_excelfile);
    
        % create variable name in the designated directory
        varname = sprintf("list_Magnet%s_%s",condition,uptodate);
        dir_listvar = fullfile(dir_data, varname);
        save(dir_listvar,"list")
    
        %% Get data    
        trls_num = length(list);
        trials_ieeg = cell(1,trls_num);
    
        for ii = 1:trls_num
            sprintf("processing... %d / %d",ii,trls_num)
            % call data from the designated directory
            dir_ieegdata = fullfile(dir_data, list{ii});
            load(dir_ieegdata); % will call ECoG_data (1x4 cell) and ECoG_hdr (struct)
            for ch = 1:4
                tem(ch,:) = ECoG_data{1,ch};
            end
            trials_ieeg{1,ii} = tem;
            tem = [];
        end
    
        % save data
        varname = sprintf("Magnet%s_%s",condition,uptodate);
        dir_datavar = fullfile(dir_data, varname);
        save(dir_datavar,"trials_ieeg");
    end
end