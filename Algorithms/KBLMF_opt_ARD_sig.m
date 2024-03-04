function score = KBLMF_opt_ARD_sig(Ku, Kv, Y,parameters)

[M,N] = size(Y);
R = parameters.R;
randn('state', parameters.seed);
G.mu = randn(M, R);  
G.sigma = repmat(eye(R, R), [1, 1, M]);     
G.mu1 = khatrirao_fast(G.mu',G.mu'); %
G.sigma1 = reshape(G.sigma,R*R,M);  

%%%初始化U
randn('state', parameters.seed);
U.mu = randn(M, R); 
U.sigma = repmat(eye(M, M), [1, 1, R]);     

randn('state', parameters.seed);
H.mu = randn(N, R);
H.sigma = repmat(eye(R, R), [1, 1, N]); 
H.mu1 = khatrirao_fast(H.mu',H.mu');
H.sigma1 = reshape(H.sigma,R*R,N);  
randn('state', parameters.seed);
V.mu = randn(N, R);  
V.sigma = repmat(eye(N, N), [1, 1, R]);    
Lambda.alpha = (parameters.alpha_lambda + (M+N)/2) * ones(1, R);
Lambda.beta = parameters.beta_lambda * ones(1, R);



kx = ones(M,N);  

lambdag_indices = repmat(logical(eye(R)), [1, 1, M]);  
lambdah_indices = repmat(logical(eye(R)), [1, 1, N]);



c = parameters.c;
Amn = (c*Y-1+Y)/2;
lam_kx = jisuan_lamb(kx);
Bmn = 2*(c*Y+1-Y).*lam_kx;
KuKu = Ku' * Ku;
KvKv = Kv' * Kv;

for iter = 1:parameters.iteration
    if mod(iter, 10) == 0
        fprintf(1, '.');
    end
    if mod(iter, 50) == 0
        fprintf(1, ' %5d\n', iter);
    end
    %%%%%%%%%%%%%%%%%
    %
    sigma_g_a = (M*R)/2;
    sigma_g_b = trace((G.mu-Ku*U.mu)*(G.mu-Ku*U.mu)')+...
        sum(G.sigma(lambdag_indices));
    for r = 1:R
        sigma_g_b = sigma_g_b+trace(Ku*U.sigma(:,:,r)*Ku');
    end
    sigma_g_b = sigma_g_b/2;    
    sigma_g = sigma_g_a/sigma_g_b;
    
    
    sigma_h_a = (N*R)/2;
    sigma_h_b = trace((H.mu-Kv*V.mu)*(H.mu-Kv*V.mu)')+...
        sum(H.sigma(lambdah_indices));
    for r = 1:R
        sigma_h_b = sigma_h_b+trace(Kv*V.sigma(:,:,r)*Kv');
    end
    sigma_h_b = sigma_h_b/2;
    sigma_h = sigma_h_a/sigma_h_b;
    %%%%%%%%%%%%%%%%%%%%%%
    for r = 1:R
        Lambda.beta(r) =  parameters.beta_lambda +...
            0.5 * (U.mu(:,r)'*U.mu(:,r) + sum(diag(U.sigma(:,:,r))) +...
            V.mu(:,r)'*V.mu(:,r) + sum(diag(V.sigma(:,:,r))));   
    end      
    
    
    %%%% update U
    for r = 1:R
        U.sigma(:, :, r) = (KuKu * sigma_g + Lambda.alpha(r)/Lambda.beta(r)*eye(M)) \ eye(M, M);
        U.mu(:, r) = U.sigma(:, :, r) * Ku' * G.mu(:,r) * sigma_g;
    end
    
    
    %%%% update G
    for m = 1:M
        Gs1 = (H.mu1+H.sigma1)*Bmn(m,:)';
        Gs1 = reshape(Gs1,R,R);
        G.sigma(:, :, m) = (2*Gs1 + eye(R) * sigma_g) \ eye(R, R);
        G.mu(m, :) = (G.sigma(:, :, m) * (H.mu'*Amn(m,:)'+ U.mu'*Ku(m,:)' * sigma_g))';
    end
    G.mu1 = khatrirao_fast(G.mu',G.mu'); %
    G.sigma1 = reshape(G.sigma,R*R,M);   %
    
    
    %%%% update H,V
    %%%% update V
    for r = 1:R
        V.sigma(:, :, r) = (KvKv * sigma_h + Lambda.alpha(r)/Lambda.beta(r)*eye(N)) \ eye(N, N);
        V.mu(:, r) = V.sigma(:, :, r) * Kv' * H.mu(:,r) * sigma_h;
    end
    
    %%%% update H
    for n = 1:N
        Hs1 = (G.mu1+G.sigma1)*Bmn(:,n);
        Hs1 = reshape(Hs1,R,R);
        H.sigma(:, :, n) = (2*Hs1 + eye(R)*sigma_h) \ eye(R, R);
        H.mu(n, :) = (H.sigma(:, :, n) * (G.mu'*Amn(:,n) + V.mu'*Kv(n,:)' * sigma_h))';
    end
    H.mu1 = khatrirao_fast(H.mu',H.mu'); %
    H.sigma1 = reshape(H.sigma,R*R,N);   
    
    %%
    kx2 = G.mu1'* H.mu1 + G.sigma1'* H.mu1+...
        G.mu1'* H.sigma1 +  G.sigma1'* H.sigma1;
    if length(find(kx2<0))>0
        disp(iter)
        error('error')
    end
    kx = sqrt(kx2);
    
    [lam_kx,sig_kx] = jisuan_lamb(kx);
    Bmn = 2*(c*Y+1-Y).*lam_kx;   
     

    
    
end
% plot(LB)

state.Lambda = Lambda;
state.G = G;
state.H = H;
state.parameters = parameters;

score = 1./(1+exp(-G.mu * H.mu'));

end



