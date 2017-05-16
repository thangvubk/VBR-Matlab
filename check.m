% dem =0;
% for iInt = 1:nInt
%     stateCount = 0;
%     for iBuf = 1:nBuf 
%         for iBW = 1:nBW
%             for iVer = 1:nVer
%                 stateCount = stateCount+1;
%                 for iDec = 1:nDec
%                     if(Cost_Matrix(iInt,iBuf,iBW,iVer,iDec) == 0)
%                         dem = dem + 1;
%                     end
%                 end
%                 
%             end
%         end
%     end
%     
% end
% dem

% 
% dem = 0
% for i = 1:10
%     for j = 1:450
%         for k = 1:450
%             if(state_transit_prob(i,j,k) ~= transitProbMatrix(j,k,i))
%                 dem = dem + 1;
%             end
%         end
%     end
% end
% dem
% 
% dem = 0
% for i = 1:10
%     for j = 1:450
%         if(sessionProbMatrix(i,j) - (state_prob(j,i)) >0.00001)
%                 dem = dem + 1;
%         end
%     end
% end
% dem
