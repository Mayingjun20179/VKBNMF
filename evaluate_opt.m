function result = evaluate_opt(score,label)
%%%%TN,TP,FN,FP
sort_predict_score=unique(sort(score));
score_num = length(sort_predict_score);
Nstep = 2000;
threshold=sort_predict_score(ceil(score_num*(1:Nstep)/(Nstep+1)));

threshold=threshold';
threshold = threshold(end:-1:1);
threshold_num=length(threshold);
TN=zeros(threshold_num,1);
TP=zeros(threshold_num,1);
FN=zeros(threshold_num,1);
FP=zeros(threshold_num,1);

for i=1:threshold_num
    tp_index=logical(score>=threshold(i) & label==1);
    TP(i,1)=sum(tp_index);
    
    tn_index=logical(score<threshold(i) & label==0);
    TN(i,1)=sum(tn_index);
    
    fp_index=logical(score>=threshold(i) & label==0);
    FP(i,1)=sum(fp_index);
    
    fn_index=logical(score<threshold(i) & label==1);
    FN(i,1)=sum(fn_index);
end


%%%%%AUPR
SEN=TP./(TP+FN);
PRECISION=TP./(TP+FP);
recall=SEN;
x=recall;
y=PRECISION;
[x,index]=sort(x);
y=y(index,:);
x = [0;x];  y = [1;y];
x(end+1,1)=1;  y(end+1,1)=0;
AUPR=0.5*x(1)*(1+y(1));
for i=1:threshold_num
    AUPR=AUPR+(y(i)+y(i+1))*(x(i+1)-x(i))/2;
end
AUPR_xy = [x,y];

%%%%%AUC
AUC_x = FP./(TN+FP);      %FPR
AUC_y = TP./(TP+FN);      %tpR
[AUC_x,ind] = sort(AUC_x);
AUC_y = AUC_y(ind);
AUC_x = [0;AUC_x];
AUC_y = [0;AUC_y];
AUC_x = [AUC_x;1];
AUC_y = [AUC_y;1];

AUC = 0.5*AUC_x(1)*AUC_y(1)+sum((AUC_x(2:end)-AUC_x(1:end-1)).*(AUC_y(2:end)+AUC_y(1:end-1))/2);

AUCxy = [AUC_x(:),AUC_y(:)];

%%%%%计算其他指标
temp_accuracy=(TN+TP)/length(label);   %%准确率
temp_sen=TP./(TP+FN);    %%真实的有链接，预测正确的正确率
recall = temp_sen;
temp_spec=TN./(TN+FP);   %%真实无连接，预测正确率
temp_precision=TP./(TP+FP); %%预测有链接的正确率
temp_f1=2*recall.*temp_precision./(recall+temp_precision);
[~,index]=max(temp_f1);
%%
f1=temp_f1(index);
%%%
[~,ind] = sort(score,'descend');

prop = round(length(label)*[0.02,0.04,0.06,0.08,0.1]);
pre_top2 = sum(label(ind(1:prop(1))))/sum(label);
pre_top4 = sum(label(ind(1:prop(2))))/sum(label);
pre_top6 = sum(label(ind(1:prop(3))))/sum(label);
pre_top8 = sum(label(ind(1:prop(4))))/sum(label);
pre_top10 = sum(label(ind(1:prop(5))))/sum(label);


result=[AUPR,AUC,f1,...
    pre_top2,pre_top4, pre_top6,pre_top8,...
    pre_top10];
%     precision_top10,precision_top20, precision_top30,precision_top40,...

end