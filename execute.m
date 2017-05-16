tic
load('matFile\input_MDP_cost_matrix.mat');
load('matFile\input_MDP_prob_matrix.mat');


for iInt = 1:nInt
    iInt

    [policy,iters] = mdp_value_iteration(mergeTransitProb(:,:,:,iInt),- merge_Cost_Matrix_State(:,:,:,iInt),0.99);

    fileID = fopen(strcat('Policy_data\policy_data_',num2str(iInt),'.txt'),'w');
    fprintf(fileID,'%d\n',policy);
    fclose(fileID);
end

policy = zeros(nInt,nState);
for iInt = 1:nInt
    fileID = fopen(strcat('Policy_data\policy_data_',num2str(iInt),'.txt'),'r');
    policy(iInt,:) = fscanf(fileID, '%d');
end
save('matFile\policy_data.mat','policy');
toc
