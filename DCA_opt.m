function S_S = DCA_opt(S)
d = 50;
Ns = length(S);              
option.maxiter =20;
option.reset_prob = 0.5;     
for i=1:Ns
    A = S{i};
    tA = run_diffusion(A, option);
    if i==1
        QA = tA;
    else
        QA = [QA,tA];
    end    
end

alpha = 1/size(QA,1);
QA = log(QA+alpha)-log(alpha);
QA = QA*QA';

QA = sparse(double(QA));
[U,S] = svds(QA,d);
LA = U;
S_F = LA*sqrt(sqrt(S));
S_S = abs(cos_opt(S_F));
end

function W = cos_opt(X) 
W = X*X';
DX = sqrt(diag(W))*sqrt(diag(W))';
W = W./DX;

end

function [Q] = run_diffusion(A, option)
    n = size(A, 1); 
    renorm = @(M) bsxfun(@rdivide, M, sum(M));  

    A = A + diag(sum(A) == 0); 
    P = renorm(A);
    reset = eye(n);  
    Q = reset;
    for i = 1:option.maxiter 
        Q_new = option.reset_prob * reset + (1 - option.reset_prob) * P * Q;
        delta = norm(Q - Q_new, 'fro');
        Q = Q_new;
        if delta < 1e-6
            break
        end
    end    
    Q = bsxfun(@rdivide, Q, sum(Q));  
end


