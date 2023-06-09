clc
clear 
%%%%
human_paac_sim = importdata('human_paac_sim.txt');
virus_paac_sim = importdata('virus_paac_sim.txt');
human_pro_ID = readcell('human_pro_ID.xlsx');
virus_pro_ID = readcell('virus_pro_ID.xlsx');
Nh = size(human_paac_sim,1);
Nv = size(virus_paac_sim,1);
inter_tensor_exp = zeros(Nh,Nv,4);
dis_name = {'Cardiovascular Infections','Dilated Cardiomyopathy','Endocarditis','Viral Myocarditis'};
for i=1:4
    inter_data = readcell('human_virus_interaction.xlsx','Sheet',dis_name{i});
    inter_data = cell2mat(inter_data);
    Ni = size(inter_data,1);
    inter_tensor_exp(:,:,i) = full(sparse(inter_data(:,1),inter_data(:,2),ones(Ni,1),Nh,Nv));
end
exper_data.human_pro_ID = human_pro_ID;
exper_data.human_paac_sim = human_paac_sim;
exper_data.virus_pro_ID = virus_pro_ID;
exper_data.virus_paac_sim = virus_paac_sim;
exper_data.inter_tensor_exp = inter_tensor_exp;
save exper_data exper_data;







%%%%% KBLMF
%CVa
disp('Start KBLMF:')
% result = {'','AUPR','AUC','sen','spec','precision','accuracy','f1'};
result = {'','AUPR','AUC','f1',...
    'pre_top2','pre_top4', 'pre_top6','pre_top8',...
    'pre_top10'};
for data_num = 1:4
    jieguo = mian_KBLMF_ARD(1,data_num);
    result = [result;[['Data',num2str(data_num)],num2cell(jieguo)]];
end


%CVr
disp('Start KBLMF:')
% result = {'','AUPR','AUC','sen','spec','precision','accuracy','f1'};
result = {'','AUPR','AUC','f1',...
    'pre_top2','pre_top4', 'pre_top6','pre_top8',...
    'pre_top10'};
for data_num = 1:4
    jieguo = mian_KBLMF_ARD(2,data_num);
    result = [result;[['Data',num2str(data_num)],num2cell(jieguo)]];
end


%CVl
disp('Start KBLMF:')
% result = {'','AUPR','AUC','sen','spec','precision','accuracy','f1'};
result = {'','AUPR','AUC','f1',...
    'pre_top2','pre_top4', 'pre_top6','pre_top8',...
    'pre_top10'};
for data_num = 1:4
    jieguo = mian_KBLMF_ARD(3,data_num);
    result = [result;[['Data',num2str(data_num)],num2cell(jieguo)]];
end