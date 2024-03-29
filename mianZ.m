clc
clear 
% %%%%
% get_data()


%%%%% VKBNMF
%CVa
disp('Start VKBNMF:')
% result = {'','AUPR','AUC','sen','spec','precision','accuracy','f1'};
result = {'','AUPR','AUC','f1',...
    'pre_top2','pre_top4', 'pre_top6','pre_top8',...
    'pre_top10'};
for data_num = 1:4
    jieguo = CV_VKBNMF_ARD(1,data_num);
    result = [result;[['Data',num2str(data_num)],num2cell(jieguo)]];
end
writecell(result,'VKBNMF_result.xlsx','Sheet','Pairwise_interaction')

%CVr
disp('Start VKBNMF:')
% result = {'','AUPR','AUC','sen','spec','precision','accuracy','f1'};
result = {'','AUPR','AUC','f1',...
    'pre_top2','pre_top4', 'pre_top6','pre_top8',...
    'pre_top10'};
for data_num = 1:4
    jieguo = CV_VKBNMF_ARD(2,data_num);
    result = [result;[['Data',num2str(data_num)],num2cell(jieguo)]];
end
writecell(result,'VKBNMF_result.xlsx','Sheet','Human_Protein')

%CVl
disp('Start VKBNMF:')
% result = {'','AUPR','AUC','sen','spec','precision','accuracy','f1'};
result = {'','AUPR','AUC','f1',...
    'pre_top2','pre_top4', 'pre_top6','pre_top8',...
    'pre_top10'};
for data_num = 1:4
    jieguo = CV_VKBNMF_ARD(3,data_num);
    result = [result;[['Data',num2str(data_num)],num2cell(jieguo)]];
end

writecell(result,'VKBNMF_result.xlsx','Sheet','Viral_Protein')