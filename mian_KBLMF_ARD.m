function result = mian_KBLMF_ARD(cv_flag,data_num)
[H_V_P] = chuli_opt(data_num);
seeds = 1;
nF = 5;  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KBLMFMDA
cv_data = cross_validation(H_V_P.interaction,cv_flag,nF,1,seeds);
result = five_cross(H_V_P,cv_data);

end

function [result,AUCxy] = five_cross(H_V_P,cv_data)
interaction = H_V_P.interaction;
virus_pro_sim = H_V_P.virus_pro_sim;
human_pro_sim =  H_V_P.human_pro_sim;
nF = length(cv_data);
result = 0;
AUCxy = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:nF
    train_set = interaction.*cv_data{k,1};   % 输入训练矩阵
    %%%%%%%%%%%%%%%%%%%%%%%%%   KBLMFMDA
    Y = xiuzheng_Y(train_set,human_pro_sim,virus_pro_sim);
    KSNS_SL = KSNS_opt(Y);
    human_pro_sim = DCA_opt({KSNS_SL,human_pro_sim});
    KSNS_Sd = KSNS_opt(Y');
    virus_pro_sim = DCA_opt({KSNS_Sd,virus_pro_sim});
    scores_KBLMF = KBLMF_paramater_ARD_sig(human_pro_sim, virus_pro_sim, train_set, 50); 
    predict_score1 = scores_KBLMF(cv_data{k,2});    
    jieguo = evaluate_opt(predict_score1,cv_data{k,3});
    jieguo
    result = result+ jieguo;
end
result = result/nF;
end








