%generate transition probability matrix after having policy
load('matFile\input_MDP_prob_matrix.mat'); 
load('matFile\policy_data.mat');

initBuf = 5;
initVer = 5;
initProb = [];

sessionProbVector = [];
nSegment = 200;

sessionProbMatrix = zeros(nInt,nState);
transitProbMatrix = zeros(nState,nState,nInt);
transitProbMatrix2D = zeros(nState,nState);
tempTransit = zeros(nState,nState,nInt);

%assign policy for transitProbMatrix
for iInt = 1:nInt
    disp(iInt);
    for iSource = 1:nState
        for iDest = 1:nState
            for iDec = 1:nDec
                if(policy(iInt,iSource) == iDec)
                    transitProbMatrix(iSource,iDest,iInt) = mergeTransitProb(iSource,iDest,iDec,iInt);
                    
                end
            end
        end
    end
end

%aggregation prob Matrix
% for iInt = 1:nInt
%     disp(iInt);
%     for iSource = 1:nState
%         for iDest = 1:nState
%             transitProbMatrix2D(iSource,iDest) = transitProbMatrix2D(iSource,iDest) + transitProbMatrix(iInt,iSource,iDest);
%         end
%     end
% end
% transitProbMatrix2D = transitProbMatrix2D / 10;




%init probability
count = 0;
for iBuf = 1:nBuf
    for iBW = 1:nBW
        for iVer = 1:nVer
            count = count +1;
            initProb(count) = 0;
            if (iBuf == initBuf && iVer == initVer)
                 initProb(count) = 1 / nBW;
            end
        end
    end
end

% for iSegment = 1:nSegment
%     tempTransit2D = tempTransit2D + transitProbMatrix2D^iSegment;
% end
for iInt = 1:nInt
    iInt
    for iSegment = 1:nSegment
        tempTransit(:,:,iInt) = tempTransit(:,:,iInt) + transitProbMatrix(:,:,iInt)^iSegment;
    end
    sessionProbMatrix(iInt,:) = initProb*tempTransit(:,:,iInt)/nSegment;
end

%aggregation prob Matrix
sessionProbVector = sessionProbMatrix(1,:);
for iInt = 2:nInt
    disp(iInt);
    sessionProbVector = sessionProbVector + sessionProbMatrix(iInt,:);
end
sessionProbVector = sessionProbVector / 10;

%sessionProbVector = initProb*tempTransit2D/nSegment;
save('matFile\perfCouter.mat','sessionProbVector');
