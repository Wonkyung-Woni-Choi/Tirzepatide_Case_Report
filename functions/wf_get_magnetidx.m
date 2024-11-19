function [varargout] = wf_get_magnetidx(trial_nums,ncondition,ndose,dose_ind_cond)
% input
% ncondition - how many conditions
% ndose - how many doses

% output
% with order of cond1, cond2, control, cond3, ..., returns ind_dose vars :
% doses x indexes array

    if nargout ~= ncondition
        warning ("number of conditions ~= number of idx output variables")
    end
    
    % calculate indexes for each condition
    % initialization
    switch  ncondition
        case 3
        idx_cond1_dose = cell(ndose,1); % LOC or high craving
        idx_cond2_dose = cell(ndose,1); % meal or low craving
        idx_control_dose = cell(ndose,1); % control
        case 4
        idx_cond1_dose = cell(ndose,1); % LOC or high craving
        idx_cond2_dose = cell(ndose,1); % meal or low craving
        idx_control_dose = cell(ndose,1); % control
        idx_cond3_dose = cell(ndose,1); % Other
        case 5
        idx_cond1_dose = cell(ndose,1); % LOC or high craving
        idx_cond2_dose = cell(ndose,1); % meal or low craving
        idx_control_dose = cell(ndose,1); % control
        idx_cond3_dose = cell(ndose,1); % missed LOC
        idx_cond4_dose = cell(ndose,1); % Other
    end
    
    % get index
    switch ncondition
        case 3
            switch ndose
                case 1
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1)
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(2) + trial_nums(1))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        end
                    end
                case 2
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1)
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(2) + trial_nums(1))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        end
                    end
                case 3
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1,1)
                              dose_idx = 1;
                           elseif i <= dose_ind_cond(2,1)
                              dose_idx = 2;
                           else
                              dose_idx = 3;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(1,2) + trial_nums(1))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,2) + trial_nums(1))
                              dose_idx = 2;
                           else
                              dose_idx = 3;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(1,3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,3) + sum(trial_nums(1:2)))
                              dose_idx = 2;
                           else
                              dose_idx = 3;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        end
                    end
                case 4
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1,1)
                              dose_idx = 1;
                           elseif i <= dose_ind_cond(2,1)
                              dose_idx = 2;
                           elseif i <= dose_ind_cond(3,1)
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(1,2) + trial_nums(1))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,2) + trial_nums(1))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,2) + trial_nums(1))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(1,3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,3) + sum(trial_nums(1:2)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,3) + sum(trial_nums(1:2)))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        end
                    end
            end
        case 4
            switch ndose
                case 1
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1)
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(2) + trial_nums(1))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:4)) 
                           if i <= (dose_ind_cond(4) + sum(trial_nums(1:3)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond3_dose{dose_idx,1} = [idx_cond3_dose{dose_idx,1}, i];
                        end
                    end
                case 4
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1,1)
                              dose_idx = 1;
                           elseif i <= dose_ind_cond(2,1)
                              dose_idx = 2;
                           elseif i <= dose_ind_cond(3,1)
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(1,2) + trial_nums(1))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,2) + trial_nums(1))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,2) + trial_nums(1))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(1,3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,3) + sum(trial_nums(1:2)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,3) + sum(trial_nums(1:2)))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:4)) 
                           if i <= (dose_ind_cond(1,4) + sum(trial_nums(1:3)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,4) + sum(trial_nums(1:3)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,4) + sum(trial_nums(1:3)))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond3_dose{dose_idx,1} = [idx_cond3_dose{dose_idx,1}, i];
                        end
                    end
                case 6
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1,1)
                              dose_idx = 1;
                           elseif i <= dose_ind_cond(2,1)
                              dose_idx = 2;
                           elseif i <= dose_ind_cond(3,1)
                              dose_idx = 3;
                           elseif i <= dose_ind_cond(4,1)
                              dose_idx = 4;
                           elseif i <= dose_ind_cond(5,1)
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(1,2) + trial_nums(1))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,2) + trial_nums(1))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,2) + trial_nums(1))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,2) + trial_nums(1))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,2) + trial_nums(1))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(1,3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,3) + sum(trial_nums(1:2)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,3) + sum(trial_nums(1:2)))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,3) + sum(trial_nums(1:2)))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,3) + sum(trial_nums(1:2)))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:4)) 
                           if i <= (dose_ind_cond(1,4) + sum(trial_nums(1:3)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,4) + sum(trial_nums(1:3)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,4) + sum(trial_nums(1:3)))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,4) + sum(trial_nums(1:3)))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,4) + sum(trial_nums(1:3)))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond3_dose{dose_idx,1} = [idx_cond3_dose{dose_idx,1}, i];
                        end
                    end
            end
         case 5
            switch ndose
                case 1
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1)
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(2) + trial_nums(1))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:4)) 
                           if i <= (dose_ind_cond(4) + sum(trial_nums(1:3)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond3_dose{dose_idx,1} = [idx_cond3_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:5)) 
                           if i <= (dose_ind_cond(5) + sum(trial_nums(1:4)))
                              dose_idx = 1;
                           else
                              dose_idx = 2;
                           end
                           idx_cond4_dose{dose_idx,1} = [idx_cond4_dose{dose_idx,1}, i];
                        end
                    end
                case 4
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1,1)
                              dose_idx = 1;
                           elseif i <= dose_ind_cond(2,1)
                              dose_idx = 2;
                           elseif i <= dose_ind_cond(3,1)
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(1,2) + trial_nums(1))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,2) + trial_nums(1))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,2) + trial_nums(1))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(1,3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,3) + sum(trial_nums(1:2)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,3) + sum(trial_nums(1:2)))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:4)) 
                           if i <= (dose_ind_cond(1,4) + sum(trial_nums(1:3)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,4) + sum(trial_nums(1:3)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,4) + sum(trial_nums(1:3)))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond3_dose{dose_idx,1} = [idx_cond3_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:5)) 
                           if i <= (dose_ind_cond(1,5) + sum(trial_nums(1:4)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,5) + sum(trial_nums(1:4)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,5) + sum(trial_nums(1:4)))
                              dose_idx = 3;
                           else
                              dose_idx = 4;
                           end
                           idx_cond4_dose{dose_idx,1} = [idx_cond4_dose{dose_idx,1}, i];
                        end
                    end
                case 6
                    for i = 1:sum(trial_nums)
                        if i <= trial_nums(1)
                           if i <= dose_ind_cond(1,1)
                              dose_idx = 1;
                           elseif i <= dose_ind_cond(2,1)
                              dose_idx = 2;
                           elseif i <= dose_ind_cond(3,1)
                              dose_idx = 3;
                           elseif i <= dose_ind_cond(4,1)
                              dose_idx = 4;
                           elseif i <= dose_ind_cond(5,1)
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond1_dose{dose_idx,1} = [idx_cond1_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:2)) 
                           if i <= (dose_ind_cond(1,2) + trial_nums(1))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,2) + trial_nums(1))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,2) + trial_nums(1))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,2) + trial_nums(1))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,2) + trial_nums(1))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond2_dose{dose_idx,1} = [idx_cond2_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:3)) 
                           if i <= (dose_ind_cond(1,3) + sum(trial_nums(1:2)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,3) + sum(trial_nums(1:2)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,3) + sum(trial_nums(1:2)))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,3) + sum(trial_nums(1:2)))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,3) + sum(trial_nums(1:2)))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_control_dose{dose_idx,1} = [idx_control_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:4)) 
                           if i <= (dose_ind_cond(1,4) + sum(trial_nums(1:3)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,4) + sum(trial_nums(1:3)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,4) + sum(trial_nums(1:3)))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,4) + sum(trial_nums(1:3)))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,4) + sum(trial_nums(1:3)))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond3_dose{dose_idx,1} = [idx_cond3_dose{dose_idx,1}, i];
                        elseif i <= sum(trial_nums(1:5)) 
                           if i <= (dose_ind_cond(1,5) + sum(trial_nums(1:4)))
                              dose_idx = 1;
                           elseif i <= (dose_ind_cond(2,5) + sum(trial_nums(1:4)))
                              dose_idx = 2;
                           elseif i <= (dose_ind_cond(3,5) + sum(trial_nums(1:4)))
                              dose_idx = 3;
                           elseif i <= (dose_ind_cond(4,5) + sum(trial_nums(1:4)))
                              dose_idx = 4;
                           elseif i <= (dose_ind_cond(5,5) + sum(trial_nums(1:4)))
                              dose_idx = 5;
                           else
                              dose_idx = 6;
                           end
                           idx_cond4_dose{dose_idx,1} = [idx_cond4_dose{dose_idx,1}, i];
                        end
                    end
            end
    end
    
    % return
    switch ncondition
        case 3
            varargout{1} = idx_cond1_dose;
            varargout{2} = idx_cond2_dose;
            varargout{3} = idx_control_dose;
        case 4
            varargout{1} = idx_cond1_dose;
            varargout{2} = idx_cond2_dose;
            varargout{3} = idx_control_dose;
            varargout{4} = idx_cond3_dose;
        case 5
            varargout{1} = idx_cond1_dose;
            varargout{2} = idx_cond2_dose;
            varargout{3} = idx_control_dose;
            varargout{4} = idx_cond3_dose;
            varargout{5} = idx_cond4_dose;
    end

end