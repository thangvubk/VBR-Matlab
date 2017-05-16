QP = [48 42 38 34 28 24 22 16 10];
minIQP = 1;
maxIQP = 9;
minBitrateSegment = 200; %offset off bitrate
maxBitrateSegment = 499; %offset off bitrate
Bitrate_Segment = zeros(maxIQP-minIQP+1, maxBitrateSegment-minBitrateSegment+1);
Bitrate_Dataset = zeros(maxIQP-minIQP+1,3); %min max and avr value
for iQP = 1:maxIQP-minIQP+1
    fileID = fopen(strcat('textFile\version\Q',num2str(QP(iQP+minIQP-1)),'.txt'),'r');
    %fscanf(fileID, '%f')
    for i = 1:maxBitrateSegment
        file =fgets(fileID);
        if i >= minBitrateSegment
            
            Bitrate_Segment(iQP,i-minBitrateSegment+1) = sscanf( file,'%f')/2;
        end
    end
    Bitrate_Dataset(iQP,1) = mean(Bitrate_Segment(iQP,:));
    Bitrate_Dataset(iQP,2) = min(Bitrate_Segment(iQP,:));
    Bitrate_Dataset(iQP,3) = max(Bitrate_Segment(iQP,:));
end
save('matFile/bitrate_data.mat','Bitrate_Dataset','Bitrate_Segment');
