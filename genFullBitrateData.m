load('matFile\bitrate_data.mat');
num_of_q = nVer;
num_of_u = nVer;
num_of_br_interval = nInt;

ExpandedBitrateData = zeros(num_of_q, num_of_br_interval);
EstBitrateData = zeros(num_of_q, num_of_u, num_of_br_interval);
Bitrate_Int_Prob = zeros(num_of_q, num_of_br_interval);

for q = 1:num_of_q
    for br_int = 1:num_of_br_interval
        ExpandedBitrateData(q, br_int) = Bitrate_Dataset(q, 2) + (2 * br_int - 1) * (Bitrate_Dataset(q, 3) - Bitrate_Dataset(q, 2)) / (2 * num_of_br_interval);
        for u = 1:num_of_u
%             EstBitrateData(q, u, br_int) = getEstBitrate(q, u, ExpandedBitrateData(q, br_int));
        end
    end
end

for q = 1:num_of_q
    seg_count = 0;
    delta_bitrate = (ExpandedBitrateData(q, 2) - ExpandedBitrateData(q, 1)) / 2;
    for seg_index = 1:size(Bitrate_Segment, 2)
        is_accounted = 0;
        min_distance = abs(Bitrate_Segment(q, seg_index) - ExpandedBitrateData(q, 1));
        selected_br_int = 1;
        for br_int = 2:num_of_br_interval
            if (min_distance > abs(Bitrate_Segment(q, seg_index) - ExpandedBitrateData(q, br_int)))
                min_distance = abs(Bitrate_Segment(q, seg_index) - ExpandedBitrateData(q, br_int));
                selected_br_int = br_int;
            end
        end
        Bitrate_Int_Prob(q, selected_br_int) = Bitrate_Int_Prob(q, selected_br_int) + 1;
    end
end
Bitrate_Int_Prob = Bitrate_Int_Prob / size(Bitrate_Segment, 2);

for q = 1:num_of_q
    file_name = ['textFile\exp_br_data_' num2str(q) '.txt'];
    myfile = fopen(file_name,'w');
    for i = 1:num_of_br_interval
        fprintf(myfile,'%d\n',ExpandedBitrateData(q, i));
    end
    fclose(myfile);
end

save('matFile\full_bitrate_data.mat','EstBitrateData','ExpandedBitrateData','num_of_br_interval');
save('matFile\Bitrate_Int_Prob.mat', 'Bitrate_Int_Prob');