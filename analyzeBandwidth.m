bandwidth_data = xlsread('bandwidth.xlsx', 'Bandwidth', 'B2:B1606');
%bandwidth_data = xlsread('bandwidth.xlsx', 'GlobalHistory','A1:A601');
%load('matFile\bandwidth_data.mat');
bw_resolution = nBW;
ExpandedBandwidthData = zeros(1, bw_resolution);
%bandwidth_range = 200:801;
if(isGlobalUpdate == 1)
    bandwidth_range = 1:600;
else
    bandwidth_range = 200:800;
end
bandwidth_size = size(bandwidth_range);
bw = bandwidth_data(bandwidth_range);
bw_quantize = zeros(1, bandwidth_size(2));
bw_outcome = zeros(1, bandwidth_size(2));
bw_number_each_step = zeros(1, bw_resolution);
bw_transit = zeros(bw_resolution, bw_resolution);
bw_transit_prob = zeros(bw_resolution, bw_resolution);

for step_index = 1:bw_resolution
    ExpandedBandwidthData(step_index) = min(bw) + (2 * step_index - 1) * (max(bw) - min(bw)) / (2 * bw_resolution);
end

bw_step = (max(bw) - min(bw)) / bw_resolution;

for bw_index = 1:bandwidth_size(2)
    bw_quantize(bw_index) = fix((bw(bw_index) - min(bw)) / bw_step) + 1;
    if (bw_quantize(bw_index) == bw_resolution + 1)
        bw_quantize(bw_index) = bw_resolution;
    end
    bw_outcome(bw_index) = ExpandedBandwidthData(bw_quantize(bw_index));
end

for bw_index = 1:bandwidth_size(2)
    bw_number_each_step(bw_quantize(bw_index)) = bw_number_each_step(bw_quantize(bw_index)) + 1;
end

for bw_index = 1:bandwidth_size(2) - 1
    bw_transit(bw_quantize(bw_index), bw_quantize(bw_index + 1)) = bw_transit(bw_quantize(bw_index), bw_quantize(bw_index + 1)) + 1;
end
% Compensate for the last bandwith state
bw_transit(bw_quantize(bandwidth_size(2)), bw_quantize(bandwidth_size(2))) = bw_transit(bw_quantize(bandwidth_size(2)), bw_quantize(bandwidth_size(2))) + 1;

for step_index = 1:bw_resolution
    bw_transit_prob(step_index, :) = bw_transit(step_index, :) / bw_number_each_step(step_index);
end

save('matFile\bw_transit_data.mat','bw_transit_prob','bw_outcome','bw_resolution','ExpandedBandwidthData');

myfile = fopen('textFile\bw_data.txt','w');
for i = 1:bandwidth_size(2)
    fprintf(myfile,'%d\t',i);
    fprintf(myfile,'%d\n',bw(i));
end
fclose(myfile);

myfile = fopen('textFile\bw_data_quantize.txt','w');
for i = 1:bandwidth_size(2)
    fprintf(myfile,'%d\t',i);
    fprintf(myfile,'%d\n',bw_outcome(i));
end
fclose(myfile);

myfile = fopen('textFile\exp_bw_data.txt','w');
for i = 1:bw_resolution
    fprintf(myfile,'%d\n',ExpandedBandwidthData(i));
end
fclose(myfile);

plot(bw_outcome);
hold on;
plot(bw);