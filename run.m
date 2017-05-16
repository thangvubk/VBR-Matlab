clear;
isGlobalUpdate = 0; %1 is use global BW, 0 is offline run
bOpt = 4;
nBW  = 10;
nVer = 9;
nBuf = 5;
nInt = 2;
nDec = nVer;
nState = nBW*nBuf*nVer;
nSegment = 300;
alpha = 20;gamma = 4; beta = 0.002; lamda = 60;
save('matFile\params.mat','bOpt','nBW','nVer','nBuf','nInt','nDec','nState','nSegment');


tic
getBitrateDataFromFile
genFullBitrateData
disp('analyze bandwidth');
analyzeBandwidth
disp('genMergeCostMatrix');
genMergeCostMatrix1
disp('genMergeProbMatrix');
genMergeProbMatrix1
% disp('execute');
% execute
% disp('genPsession');
% genPsession1
% disp('genPerformance');
% genPerformance1

toc