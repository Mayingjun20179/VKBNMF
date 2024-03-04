%%%%存储疾病和miRNA的相似矩阵和连接矩阵
function H_V_P = chuli_opt(data_num)
load exper_data.mat;

%%%处理疾病
human_pro_name = exper_data.human_pro_ID;
human_pro_sim =  exper_data.human_paac_sim;
% human_pro_sim =  KSNS_opt(exper_data.human_ctd_fea);
%%%处理miRNA
virus_pro_name = exper_data.virus_pro_ID;
virus_pro_sim =  exper_data.virus_paac_sim;
% virus_pro_sim =  KSNS_opt(exper_data.virus_ctd_fea);

%%%处理关联
interaction = exper_data.inter_tensor_exp(:,:,data_num);
indy = find(sum(interaction,1)==0);
indx = find(sum(interaction,2)==0);
interaction(:,indy) = [];
interaction(indx,:) = [];
human_pro_name(indx) = [];
virus_pro_name(indy) = [];
H_V_P.interaction = interaction;


human_pro_sim(indx,:) = [];
human_pro_sim(:,indx) = [];
H_V_P.human_pro_sim = human_pro_sim;
virus_pro_sim(indy,:) = [];
virus_pro_sim(:,indy) = [];
H_V_P.virus_pro_sim = virus_pro_sim;
H_V_P.human_pro_name = human_pro_name;
H_V_P.virus_pro_name = virus_pro_name;


end



