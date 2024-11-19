function [varargout] = wf_chunks(raw_static_FFT, static_freq, raw_chunks, indexes, ndose, maxlen, subtrllen, foi, nfreq, srate)
% input
% raw_static_FFT: output structure from static analysis
% static_freq: frequency vector
% indexs: index vetor of interested condition
% ndose: number of doses
% maxlen: maximum length of data ex. 179 sec per swipes
% subtrllen: length of chunked data (# sec)
% foi: row vector [#, #] of interested frequency range to create shortened spectrum
% nfreq: length of frequency spectrum
% srate: sampling rate

% output
% eachdata: chunked raw traces
% eachspec: chunked spectrums
% eachspecfoi: chunked spectrum with only frequency of interest (ex. 1~6 Hz)
% subtrlidx_d: within eachdata or eachspec, which indexes corresponds to the same magnet swipe

        % initialize
        eachdata = cell(ndose,1);
        eachspec = cell(ndose,1);
        eachspecfoi = cell(ndose,1);
        subtrlidx = cell(ndose,1);
        for dose = 1:ndose
            % initialize
            nsubtrls_max = length(indexes{dose,1})*floor(maxlen/subtrllen); % max possible snippets
            eachspec_d = ones(nsubtrls_max,nfreq)*1000;
            eachdata_d = ones(nsubtrls_max,srate*subtrllen)*1000;

            % put data in
            temstruct = [];
            cnt1 = 1;
            cnt2 = 1;
            nsubtrls_1 = zeros(length(indexes{dose,1}),1);
            if ~isempty(indexes{dose,1})
                for i = 1:length(indexes{dose,1})
                    tem = indexes{dose,1};
                    index = tem(i);
                    % data chunks
                    temstruct_raw = raw_chunks{1,index}; % 1 x subtrls cell
                    for subnum = 1:length(temstruct_raw)
                        eachdata_d(cnt1,:) = temstruct_raw{1,subnum};
                        cnt1 = cnt1+1;
                    end   
                    % spectrum chunks
                    temstruct = raw_static_FFT{1,index}; % trls x chan x freq
                    if ~isempty(temstruct)
                        nsubtrl = size(temstruct.powspctrm,1);
                    else
                        nsubtrl = 0;
                    end
                    nsubtrls_1(i,1) = nsubtrl; % column vector of nsubtrials 
                    if ~isempty(temstruct)
                        eachspec_d(cnt2:cnt2+nsubtrl-1,:) = squeeze(temstruct.powspctrm); % trls x freq
                    end
                    cnt2 = cnt2+nsubtrl;
                end
    
                endidx = cumsum(nsubtrls_1);
                stidx = cumsum([1;nsubtrls_1(1:(end-1),1)]);
                subtrlidx_d = [stidx,endidx]; % start, end
                % remove index that is empty
                subtrlidx_d(find(subtrlidx_d(:,2)-subtrlidx_d(:,1) < 0),:) = 0;
    
                % remove empty parts (denoted as 1000)
                eachspec_d = reshape(eachspec_d(eachspec_d~=1000),[],nfreq);
                eachdata_d = reshape(eachdata_d(eachdata_d~=1000),[],srate*subtrllen);
    
                % get only up to certain fq
                cutfreq = foi; %Hz
                freq_temp = static_freq{1,1};
                idxes = dsearchn(freq_temp',cutfreq');
                eachspec_dfoi = eachspec_d(:,idxes(1):idxes(2));
    
                % put into structure
                eachdata{dose,1} = eachdata_d;
                eachspec{dose,1} = eachspec_d;
                eachspecfoi{dose,1} = eachspec_dfoi;
                subtrlidx{dose,1} = subtrlidx_d;        
            else
                % put into structure
                eachdata{dose,1} = [];
                eachspec{dose,1} = [];
                eachspecfoi{dose,1} = [];
                subtrlidx{dose,1} = [];  
            end
        end

    switch ndose
        case 1
            varargout{1} = eachdata{1,1};
            varargout{2} = eachspec{1,1};
            varargout{3} = eachspecfoi{1,1};
            varargout{4} = subtrlidx{1,1};
        case 2
            varargout{1} = eachdata{1,1};
            varargout{2} = eachspec{1,1};
            varargout{3} = eachspecfoi{1,1};
            varargout{4} = subtrlidx{1,1};
            varargout{5} = eachdata{2,1};
            varargout{6} = eachspec{2,1};
            varargout{7} = eachspecfoi{2,1};
            varargout{8} = subtrlidx{2,1};
        case 3
            varargout{1} = eachdata{1,1};
            varargout{2} = eachspec{1,1};
            varargout{3} = eachspecfoi{1,1};
            varargout{4} = subtrlidx{1,1};
            varargout{5} = eachdata{2,1};
            varargout{6} = eachspec{2,1};
            varargout{7} = eachspecfoi{2,1};
            varargout{8} = subtrlidx{2,1};
            varargout{9} = eachdata{3,1};
            varargout{10} = eachspec{3,1};
            varargout{11} = eachspecfoi{3,1};
            varargout{12} = subtrlidx{3,1};
        case 4
            varargout{1} = eachdata{1,1};
            varargout{2} = eachspec{1,1};
            varargout{3} = eachspecfoi{1,1};
            varargout{4} = subtrlidx{1,1};
            varargout{5} = eachdata{2,1};
            varargout{6} = eachspec{2,1};
            varargout{7} = eachspecfoi{2,1};
            varargout{8} = subtrlidx{2,1};
            varargout{9} = eachdata{3,1};
            varargout{10} = eachspec{3,1};
            varargout{11} = eachspecfoi{3,1};
            varargout{12} = subtrlidx{3,1};
            varargout{13} = eachdata{4,1};
            varargout{14} = eachspec{4,1};
            varargout{15} = eachspecfoi{4,1};
            varargout{16} = subtrlidx{4,1};
        case 6
            varargout{1} = eachdata{1,1};
            varargout{2} = eachspec{1,1};
            varargout{3} = eachspecfoi{1,1};
            varargout{4} = subtrlidx{1,1};
            varargout{5} = eachdata{2,1};
            varargout{6} = eachspec{2,1};
            varargout{7} = eachspecfoi{2,1};
            varargout{8} = subtrlidx{2,1};
            varargout{9} = eachdata{3,1};
            varargout{10} = eachspec{3,1};
            varargout{11} = eachspecfoi{3,1};
            varargout{12} = subtrlidx{3,1};
            varargout{13} = eachdata{4,1};
            varargout{14} = eachspec{4,1};
            varargout{15} = eachspecfoi{4,1};
            varargout{16} = subtrlidx{4,1};
            varargout{17} = eachdata{5,1};
            varargout{18} = eachspec{5,1};
            varargout{19} = eachspecfoi{5,1};
            varargout{20} = subtrlidx{5,1};
            varargout{21} = eachdata{6,1};
            varargout{22} = eachspec{6,1};
            varargout{23} = eachspecfoi{6,1};
            varargout{24} = subtrlidx{6,1};
    end
end