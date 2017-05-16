%generate transition probability matrix after having policy
load('matFile\input_MDP_prob_matrix.mat'); 
load('matFile\policy_data.mat');

initBuf = 5;
initVer = 3;
initBW = 10;
initProb = zeros(1,nState);
sessionProbVector = zeros(1,nState);
nSegment = 300;

sessionProbMatrix = zeros(nInt,nState);
transitProbMatrix = zeros(nState,nState,nInt);
transitProbMatrix2D = zeros(nState,nState);
tempTransit2D = zeros(nState,nState);

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
for iInt = 1:nInt
    disp(iInt);
    for iSource = 1:nState
        for iDest = 1:nState
            transitProbMatrix2D(iSource,iDest) = transitProbMatrix2D(iSource,iDest) + transitProbMatrix(iSource,iDest,iInt);
        end
    end
end
transitProbMatrix2D = transitProbMatrix2D / 10;




%init probability
count = 0;
for iBuf = 1:nBuf
    for iBW = 1:nBW
        for iVer = 1:nVer
            count = count +1;            
            if (iBuf == initBuf && iVer == initVer)
                 initProb(count) = 1/nBW ;
            end
        end
    end
end

% for iSegment = 1:nSegment
%     tempTransit2D = tempTransit2D + transitProbMatrix2D^iSegment;
% end

for iSegment = 1:nSegment
    tempTransit2D = tempTransit2D + transitProbMatrix2D^iSegment;
end
    
%aggregation prob Matrix

sessionProbVector = initProb*tempTransit2D/nSegment;

%sessionProbVector = initProb*tempTransit2D/nSegment;
save('matFile\perfCouter.mat','sessionProbVector');
