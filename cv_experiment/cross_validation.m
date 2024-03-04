function cv_data = cross_validation(intMat,cv_flag,cv,prop,seed)
cv_data = cell(cv,3);  
[num_A,num_B] = size(intMat);
[pos_indx,pos_indy] = find(intMat==1);
num_pos = length(pos_indx);
if exist('seed','var') == 1
    rand('state',seed)
end
if cv_flag == 1    %interaction cross
    index = randperm(num_pos)';
elseif cv_flag == 2  %row cross
    index = randperm(num_A)';
elseif cv_flag == 3  %col cross
    index = randperm(num_B)';
end
num_step = floor(length(index)/cv);
for j = 1:cv   %
    if j < cv
        ii = index((j-1)*num_step+1:j*num_step);
    else
        ii = index((j-1)*num_step+1:end);
    end
    if cv_flag == 1    %interaction cross
        pos_test_index = [pos_indx(ii),pos_indy(ii)];   %Positive example of test set index
        [neg_indx,neg_indy] = find(intMat==0); %
        num_neg = length(neg_indx);
        %The number of negative samples is prop times of positive samples
        num_test_pos = size(pos_test_index,1);  %The number of positive test samples
        num_test_neg = prop*num_test_pos; %The number of negative test samples

        index00 = randperm(num_neg);
        test_index = [pos_test_index;[neg_indx(index00(1:num_test_neg)),neg_indy(index00(1:num_test_neg))]];
        Test_matrix = full(sparse(test_index(:,1),test_index(:,2),...
            ones(length(test_index(:,1)),1),num_A,num_B));
        test_index = find(Test_matrix==1);    %test single index
        test_label = intMat(test_index);  %test label
        W = ones(num_A,num_B);
        W(test_index) = 0;  %W: train mask matrix
        cv_data(j,:) = {W, test_index, test_label};
    elseif cv_flag == 2   %for all row
        test_index=[];
        for k=1:length(ii)
            test_index = [test_index;[ii(k)*ones(num_B,1),[1:num_B]']];
        end
        %%only one choice
        Test_matrix = full(sparse(test_index(:,1),test_index(:,2),...
            ones(length(test_index(:,1)),1),num_A,num_B));
        test_index = find(Test_matrix==1);
        test_label = intMat(test_index);
        W = ones(num_A,num_B);
        W(test_index) = 0;
        gca = pcolor([W(find(sum(W,2)==0),:);W(find(sum(W,2)==num_B),:)]);
        set(gca, 'LineStyle','none');
        colorbar;
        cv_data(j,:) = {W, test_index, test_label};
        
    elseif cv_flag==3     %对所有列交叉
        test_index=[];
        for k = 1:length(ii)
            test_index = [test_index;[[1:num_A]',ii(k)*ones(num_A,1)]];
        end
        %%only one choice
        Test_matrix = full(sparse(test_index(:,1),test_index(:,2),ones(length(test_index(:,1)),1),num_A,num_B));
        test_index = find(Test_matrix==1);
        test_label = intMat(test_index);
        W = ones(num_A,num_B);
        W(test_index) = 0;
        gca = pcolor([W(:,find(sum(W)==0)),W(:,find(sum(W)==num_A))]);
        set(gca, 'LineStyle','none');
        colorbar;
        cv_data(j,:) = {W, test_index, test_label};
    end
end
end