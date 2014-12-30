function [predicted_accuracy negloglike] = nll_glc_mjc(in_params)

global A_indices B_indices data_info z_limit

%  negloglike = nll_glc_vJ(params)
%  returns the negative loglikelihood of the 2d data for the
%  General Linear Classifier.

%  Parameters:
%    params format:  [a1 b noise] where a1*x+a2*y+b=0 is linear bound
%                    We assume without loss of generality that
%                    a2=sqrt(1-a1^2) and a2 >= 0
%    data_info row format:  [response x y 1]
%    z_limit is the z-score value beyond which one should truncate

% We assume that the B category is above the linear bound.  Note that since
% we use slope intercept format, "above" makes sense.

% We start by computing z-scores for each data point.  In principle we compute the
% distance between the point (data(:,2),data(:,3)) and the linear bound,
% then rescale by the noise to get a z-score.  In practice we use a little
% trick to save some computing time.

z_coefs = [in_params(1) sqrt(1-in_params(1)^2) in_params(2)]' ./ in_params(3);
zscores = data_info(:,2:4) * z_coefs;
zscores = min(zscores,z_limit);
zscores = max(zscores,-z_limit);

prB = normalcdf(zscores);

prA = 1-prB;

log_A_probs = log(prA(A_indices));
log_B_probs = log(prB(B_indices));
   
% Sum them up and return the negative
negloglike = -(sum(log_A_probs)+sum(log_B_probs));

% Get the predicted accuracy for this window. Add up the probabilites of
% responding A on A trials and B on B trials and average them.
% Added by MJC: 10-23-07
predicted_accuracy = (sum(prA(A_indices)) + sum(prB(B_indices)))/(length(data_info))