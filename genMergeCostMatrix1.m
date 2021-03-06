tic
load('matFile\bw_transit_data.mat');
load('matFile\bitrate_data.mat');
load('matFile\full_bitrate_data.mat');

Cost_Matrix = zeros(nBW,nVer,nBuf,nDec,nInt);
merge_Cost_Matrix = zeros(nState,nDec,nInt);
merge_Cost_Matrix_State = zeros( nState,nState, nDec,nInt);

mergeCostBR = zeros(nState,nDec,nInt);
mergeCostBuf = zeros(nState,nDec,nInt);
mergeCostQ = zeros(nState,nDec,nInt);
% gen cost matrix


for iInt = 1:nInt
    stateCount = 0;
    for iBuf = 1:nBuf 
        for iBW = 1:nBW
            for iVer = 1:nVer
                %b_var = (iBuf - bOpt)^2;
                b_var = (iBuf/bOpt - 1)^2;
            
                stateCount = stateCount+1;
                for iDec = 1:nDec
                    br_var = ExpandedBandwidthData(iBW)*(1+iBuf/bOpt)/2 - ExpandedBitrateData(iDec,iInt);
                    if(br_var >= 0)
                        merge_Cost_Matrix(stateCount,iDec,iInt) = beta*br_var + gamma*b_var + 0.75*lamda*abs(iDec - iVer)^2;
                        %mergeCostBR(stateCount,iDec,iInt) = beta*br_var;
                        mergeCostBuf(stateCount,iDec,iInt) = gamma*b_var;
                        mergeCostQ(stateCount,iDec,iInt) = 1.5*lamda*abs(iDec - iVer)^2;
                    else 
                        %merge_Cost_Matrix(stateCount,iDec,iInt) = alpha*(1 - exp(0.7*beta*br_var)) + gamma*b_var + 1.5*lamda*abs(iDec - iVer)^2;
                        merge_Cost_Matrix(stateCount,iDec,iInt) = -6*beta*br_var + gamma*b_var + 0.75*lamda*abs(iDec - iVer)^2;
                        mergeCostBR(stateCount,iDec,iInt) = alpha*(1 - exp(-abs(0.7*beta*br_var)));
                        mergeCostBR1(stateCount,iDec,iInt) = -10*beta*br_var;
                        mergeCostBuf(stateCount,iDec,iInt) = gamma*b_var;
                        mergeCostQ(stateCount,iDec,iInt) = 1.5*lamda*abs(iDec - iVer)^2;
                    end
                
                    %br_var = ExpandedBandwidthData(iBW) - ExpandedBitrateData(iDec,iInt);
                    %(bw_values(bw) * (1 + buffer_values(buffer_lvl) / buffer_value_opt) / 2) - u_values(br_int, u);
                    
                    %tempCost(iInt,iBuf,iBW,iVer,iDec) = beta*br_var;
%                   Cost_Matrix(iInt,iBuf,iBW,iVer,iDec) = beta*br_var + gamma*b_var + lamda*abs(iDec - iVer)^2;
                    %merge_Cost_Matrix(stateCount,iDec) = alpha*(1 - exp(-abs(0.7*beta*br_var))) + gamma*b_var + lamda*abs(iDec - iVer)^2 - sigma*iDec;
                    
                    
                    
                end
            end
        end
    end
end
%------------------------------------


% for iInt = 1:nInt
%     stateCount = 0;
%     for iBuf = 1:nBuf 
%         for iBW = 1:nBW
%             for iVer = 1:nVer
%                 stateCount = stateCount+1;
%                 for iDec = 1:nDec
%                     merge_Cost_Matrix(stateCount,iDec,iInt) = Cost_Matrix(iBuf,iBW,iVer,iDec,iInt);
%                 end
%                 
%             end
%         end
%     end
%     
% end


%transform 3D -> 4D matrix with state transition
for iInt = 1:nInt
    disp(iInt);
    for iSource = 1:nState
        for iDest = 1:nState
            for iDec = 1:nDec
                %[~,~,destVer] = getStateParam(iDest,nBuf,nBW,nVer);
                
                destVer = mod(iDest, nVer);
                if(destVer == 0) 
                    destVer = nVer; 
                end
                
                if(destVer == iDec)
                    merge_Cost_Matrix_State(iSource,iDest,iDec,iInt) = merge_Cost_Matrix(iSource,iDec,iInt);
                    
                end
            end
        end
    end
    
end

% dem = 0;
% for iInt = 1:1
%     disp(iInt);
%     for iSource = 1:nState
%         for iDest = 1:nState
%             for iDec = 1:nDec
%                 
%                 if(merge_Cost_Matrix_State(iInt,iSource,iDest,iDec) ~= 0) 
%                     dem = dem+1;
%                 end
%                  
%             end
%         end
%     end
%     
% end
% dem


disp('Done!');
save('matFile\input_MDP_cost_matrix.mat','merge_Cost_Matrix_State');

fileID = fopen(strcat('textFile\Cost.txt'),'w');
for i=1:nState
    for j=1:nState
        for k = 1:nDec
            fprintf(fileID,'%d\n',merge_Cost_Matrix_State(i,j,k,1));
        end
    end
end
fclose(fileID);
toc