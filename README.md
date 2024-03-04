##VKBNMF

Matlab code of Kernel Bayesian nonlinear matrix factorization based on variational inference for human-virus protein-protein interaction prediction. If the reference the code, please refer to the corresponding literature.

(Written by Yingjun Ma 2024)



To run the code:
1. Change Matlab work directory to "/VKBNMF/".
2. Run  "loadpah" code to add the current folder and subfolders into Matlab path searching list.
3. Open and run the  mianZ.m. 


mianZ.m：All experiments in three scenarios with four data sets

The “Cv_experiment” folder contains related experiments on four datasets
CV_VKBNMF_ARD.m： 


The “Algorithms” folder contains the relevant calculation code for VKBNMF:
KBLMF_opt_ARD_sig：Kernel Bayesian nonlinear matrix factorization based on variational inference.

The Dataset folder contains all experimental data in this paper:
(1) human_paac_sim.txt: The similarity of all human proteins calculated from PseAAC characteristics.
(2) human_pro_ID.xlsx: The ID of the human protein

(3)virus_paac_sim.txt: The similarity of all virus proteins calculated from PseAAC characteristics.
(4) virus protein ID.xlsx : The ID of the virus protein.

(5)human_virus_interaction.xlsx:  human-virus PPIs for four disease types.


In this package, we used the tensor tensor_toolbox-v3.1, which is downloaded from (https://gitlab.com/tensors/tensor_toolbox/-/releases/v3.1)












