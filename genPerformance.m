iBuf = 1;
for iState = 1:nState
    temp = floor(iState*nBuf/nState);
     
    vectorBuf(iState) = temp + 1;
    if(mod(iState,nState/nBuf) == 0)
        vectorBuf(iState) = vectorBuf(iState)-1;
    end
end

a = 2* vectorBuf.*sessionProbVector;
sum(a)
num_of_state = nState;
num_of_buffer_lvl = nBuf;
num_of_q = nVer;
num_of_bw = nBW;
average_q_total = 0;
average_switch_total = 0;
average_buffer_total = 0;
for br_int = 1:num_of_br_interval
    average_q = 0;
    sum_prob_not_stall = 0;
    average_switch = 0;
    average_buffer = 0;
    for state = 1:num_of_state
        %if (U_k_p_1(br_int, state) > 1)
            %sum_prob_not_stall = sum_prob_not_stall + sessionProbMatrix(br_int, state);
            [buffer, bw, q] = getStateParam(state, num_of_buffer_lvl, num_of_bw, num_of_q);
            % average_q = average_q + sessionProbMatrix(br_int, state) * q * Bitrate_Int_Prob(q, br_int); % Working on this and line below
            average_q = average_q + sessionProbMatrix(br_int, state) * q / nInt; % Working on this and line below
            % average_switch = average_switch + sessionProbMatrix(br_int, state) * abs (U_k_p_1(br_int, state) - 1 - q) * Bitrate_Int_Prob(q, br_int);            
            average_switch = average_switch + sessionProbMatrix(br_int, state) * abs (policy(br_int, state) - q) /nInt;            
            average_buffer = average_buffer + sessionProbMatrix(br_int, state) * (buffer) * 2 / nInt;
            %buffer
%             if (buffer == 1 && sessionProbMatrix(br_int, state) == 0)
%                 disp('Buffer zero!!!!');
%             end
        %end
        % average_buffer = average_buffer + sessionProbMatrix(br_int, state) * (buffer - 1) * 2 * 0.1;
    end
    % display(sum_prob_not_stall);
    average_switch_total = average_switch_total + average_switch; % / sum_prob_not_stall;
    average_q_total = average_q_total + average_q; % / sum_prob_not_stall; % Eliminate stalling state probability
    % average_buffer_total = average_buffer_total + average_buffer / sum_prob_not_stall;
    average_buffer_total = average_buffer_total + average_buffer; % / sum_prob_not_stall;
end
%average_q_total = average_q_total / num_of_br_interval;
%average_switch_total = average_switch_total / num_of_br_interval;
display(average_switch_total);
display(average_q_total);
display(average_buffer_total);