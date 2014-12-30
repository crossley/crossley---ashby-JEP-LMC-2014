% Script to load data, reformat it, allow user to input starting guesses
% for the bounds and run model fit.

clear all
close all
clc
cd(fileparts(mfilename('fullpath')))

global data subjects use_resp fit_hybrid num_trials blocks block_len
global fit_guessing fit_biased_guessing fit_unix fit_uniy fit_unequal_GCC
global fit_equal_GCC fit_GLC fit_GQC fit_GCC_guessing fit_GCC_eq2 
global by_session session_block_len


% User specified variables
subjects = [1 2 10:17 20:27 106:108];
use_resp = 1; %use_resp = 1 means use the actual subject responses, 0 means use true categories
num_trials = 800;
block_len = 100;
blocks = num_trials / block_len;

by_session = 0;
session_block_len = 0;

fit_guessing = 1;
fit_biased_guessing = 1;
fit_unix = 1;
fit_uniy = 1;
fit_unequal_GCC = 0;
fit_equal_GCC = 0;
fit_GCC_guessing = 0;
fit_GCC_eq2 = 0;
fit_GLC = 1;
fit_GQC = 0;

% We run the script that runs the actual model fits
addpath(genpath(pwd));
run_model_fits;
rmpath(genpath(pwd));