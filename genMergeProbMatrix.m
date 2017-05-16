tic
load('matFile\bw_transit_data.mat');
load('matFile\bitrate_data.mat');
load('matFile\full_bitrate_data');

buffer_value_max = nBuf;

buffer_values = zeros(1, nBuf);
bw_values = zeros(1, nBW);




TransitProb = zeros(nBuf,nBW,nVer,nBuf,nBW,nVer,nDec,nInt);
mergeTransitProb = zeros(nBuf*nBW*nVer,nBuf*nBW*nVer,nDec,nInt);


% Import buffer values
for buffer_lvl = 1:nBuf
    buffer_values(buffer_lvl) = buffer_lvl;
end

% Import bandwith values
for i = 1:nBW
    bw_values(i) = ExpandedBandwidthData(i);
end


    % Build Transition Probability Matrix
display('===== Building TransitProb Matrix =====');
for iInt = 1:nInt
    for iBuf = 1:nBuf
        % display(iBuf);
        for iBW = 1:nBW
            % display(iBW);
            for iVer = 1:nVer
                for dest_iBuf = 1:nBuf
                    if (dest_iBuf <= iBuf + 1)
                        for dest_iBW = 1:nBW
                            if (bw_transit_prob(iBW, dest_iBW) > 0)
                                for dest_iVer = 1:nVer
                                    for iDec = 1:nDec
                                        %est_dest_br = EstBitrateData(iVer, iDec, iInt);
                                        est_dest_br = ExpandedBitrateData(iDec,iInt);
                                        if (iDec == dest_iVer)
                                            P_buffer = 0;                                    
                                            % Calculate P_buffer
                                                if (iBuf == buffer_value_max && dest_iBuf == iBuf)
                                                    if (round(est_dest_br / bw_values(iBW)) <= 1)
                                                        P_buffer = 1;
                                                    end
                                                elseif (dest_iBuf == max(iBuf + 1 - round(est_dest_br / bw_values(iBW)),1))
                                                    P_buffer = 1;                                                              
                                                end  
                                            P_bw = bw_transit_prob(iBW, dest_iBW);
                                            TransitProb( iBuf, iBW, iVer,  dest_iBuf, dest_iBW, dest_iVer,iDec,iInt) = P_buffer * P_bw;
                                        end                                                
                                    end
                                end
                            end
                        end
                    end                
                end % for iDec = 1:nDec
            end
        end
    end
end

for iInt = 1:nInt
    iInt
    stateCount = 0;
    for iBuf = 1:nBuf 
        for iBW = 1:nBW
            for iVer = 1:nVer
            
                stateCount = stateCount + 1;
                destStateCount = 0;
                for dest_iBuf = 1:nBuf
                    for dest_iBW = 1:nBW
                        for dest_iVer = 1:nVer
                         
                            destStateCount = destStateCount + 1;
                            for iDec = 1:nDec
                                mergeTransitProb(stateCount,destStateCount,iDec,iInt) = TransitProb( iBuf, iBW, iVer, dest_iBuf, dest_iBW, dest_iVer,iDec,iInt);
     
                            end
                        end
                    end
                end
            end
        end
    end
end

save('matFile\input_MDP_prob_matrix.mat','mergeTransitProb');

toc               

