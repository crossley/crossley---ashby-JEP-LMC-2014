function negloglike = nll_hybrid_optimal_vJ(in_params)

% negloglike = nll_hybrid_eq_vJ(in_params) computes the negative log
% likelihood for a pattern of responses given a hybrid decision rule in the
% form in_params = [a1 b x_criterion noise] where a1*x + a2*y + b = 0 
% is the equation of the linear bound, with a1^2 + a2^2 = 1 and a2 >=0.

% This version is modified so that the unidimensional x bound is fixed at
% 50 and the linear bound is fixed at y=x

in_params = [-sqrt(2)/2 0 50 in_params(1) in_params(1)];

fid=fopen('params.dat','w');
fprintf(fid, '%12.4f %12.4f %12.4f %12.4f %12.4f\n', in_params');
fclose(fid);

% We call nll_hybrid_function.exe, an executible file created using
% fortran.

% ! nll_hybrid_function
!./hybrid

% Load in the negative log-likelihood from the fortran file.  

load negloglike.dat
