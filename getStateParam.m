function [ buffer_lvl, bw, q ] = getStateParam( state, num_of_buffer_lvl, num_of_bw, num_of_q )
    if (rem(state, num_of_q) == 0)
        q = num_of_q;
        temp_state = fix(state / num_of_q);
    elseif (rem(state, num_of_q) > 0)
        q = rem(state, num_of_q);
        temp_state = fix(state / num_of_q) + 1;
    end
    
    if (rem(temp_state, num_of_bw) == 0)
        bw = num_of_bw;
        temp_state = fix(temp_state / num_of_bw);
    elseif (rem(temp_state, num_of_bw) > 0)
        bw = rem(temp_state, num_of_bw);
        temp_state = fix(temp_state / num_of_bw) + 1;
    end    
    
    if (rem(temp_state, num_of_buffer_lvl) == 0)
        buffer_lvl = num_of_buffer_lvl;
    elseif (rem(temp_state, num_of_bw) > 0)
        buffer_lvl = rem(temp_state, num_of_buffer_lvl);
    end    
end

