function  [lam_kx,sig_kx] = jisuan_lamb(kx)

sig_kx = 1./(1+exp(-kx));

lam_kx = 1./(2*kx).*(sig_kx-1/2);

end