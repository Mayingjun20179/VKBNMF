
function score = KBLMF_paramater_ARD_sig(Ku, Kv, Y, R)



parameters.alpha_lambda = 1;
parameters.beta_lambda = 1;

parameters.iteration = 50;
parameters.progress = 1;
parameters.R = R;
parameters.seed = 1;
parameters.c = 16;
score = KBLMF_opt_ARD_sig(Ku, Kv,Y,parameters);


end
