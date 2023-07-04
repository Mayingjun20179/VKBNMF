# KBLMF-ARD
Kernel Bayesian Logistic Matrix Factorization with Automatic Relevance Determination for human-Viral Protein-protein prediction

This is the data and code for the paper "Kernel Bayesian nonlinear matrix factorization based on variational inference for human-virus protein-protein interaction prediction". Please cite if you use this code.

Data description:
"human_virus_interaction.xlsx" stores human-virus PPIs for four disease types.
"human_paac_sim.zip" stores the similarity of human proteins and needs to be decompressed.
virus_paac_sim.zip stores the similarity of virus proteins and needs to be decompressed.
"human protein ID.xlsx" stores the ID of the human protein.
"virus protein ID.xlsx" stores the ID of the virus protein.

Code description: 
"KBLMF_opt_ARD_sig.m" code for the VKBNMF method of this study；
 "Mian_ARD_sig" is the main function, and running this function can get the results of “Pairwise interaction” scenario , “Human Protein” Scenario,“Viral Protein” Scenario.
