function [ est_br ] = getEstBitrate( q, u, curr_br )
    theta = 1.05;
    est_br = theta * curr_br * 2 ^ ((Q2QP(q) - Q2QP(u)) / 6);
end

