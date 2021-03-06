
% Framework for fitting general conjunctive rule to 2 dimensional stimuli

close all
clear all

global z_limit data

z_limit = 3;

% Load the data 

load_b_stim
data = data4;

x = data(:,2); 
y = data(:,3);

% We plot the data so we can make our original guesses for the X and Y
% bounds.

xyaxes=[min(x) max(x) min(y) max(y)];

figure;
plot2dstim(data,xyaxes,0);
hold on;

title(['Subject Responses'])
xlabel('Orientation');
ylabel('Spatial Frequency');
legend('A','B');

% We read in our initial guesses for xc, yc and the noise standard
% deviation.  We also give the user the chance to switch the category
% labels.

% cat_org = 0;
% xc = 80;
% yc = 55;
% noise = 5;

cat_org = input('Switch Categories (1 if yes, 0 if no):');
xc = input('Starting X Bound:');
yc = input('Starting Y Bound:');
noise = input('Starting Noise:');

close all

[nobs col] = size(data);

global A_indices B_indices

% We switch the responses if necessary

if cat_org == 0 
    
    A_indices = find(data(:,1) == 1);
    B_indices = find(data(:,1) ~= 1);

else

    A_indices = find(data(:,1) ~= 1);
    B_indices = find(data(:,1) == 1);

end

% We plot this starting bound as well as the subject's responses

figure; 
xyaxes=[min(x) max(x) min(y) max(y)];
plot2dstim(data,xyaxes,0);
hold on;

title(['Subject scores Start Bound'])
xlabel('Orientation');
ylabel('Spatial Frequency');

% X bound (plots x = xc)
x_bnd=[1 0 -xc];
plot2dlinbnd(x_bnd,'k-'); 

% Y bound (plots y = yc)
y_bnd=[0 1 -yc];
plot2dlinbnd(y_bnd,'k-'); 

legend('A','B','x','y')

in_params = [xc yc noise];

% Set contraints on parameters

vlb = [0 0 0.001];
vub = [100 100 10];

% Set search options
options = optimset(...
     'Display', 'off',...  % Spit out progress info
    'TolFun', .001');      % Termination tolerance on f    

% Run model fitting program
fprintf('\n\nFitting Equal GCC\n\n')

[out_params,negloglike_gcc_eq] = fmincon('nll_gcc_eq_vJ',in_params,[],[],[],[],vlb,vub,[],options);

% Compute BIC score

fp=3;
BIC_gcc_eq=2*negloglike_gcc_eq+(log(nobs)*fp);

% Report results

fprintf('X Bound: %10.5f\n', out_params(1));
fprintf('Y Bound: %10.5f\n', out_params(2));
fprintf('Noise: %10.5f\n', out_params(3));
fprintf('Negative Log Likelihood: %10.5f\n', negloglike_gcc_eq);
fprintf('BIC for GCC (Equal Variance Case): %10.5f\n\n', BIC_gcc_eq);

% Plot results

figure; 
xyaxes=[min(x) max(x) min(y) max(y)];
plot2dstim(data,xyaxes,0);
hold on;

title(['Subjects scores Calculated Bound'])
xlabel('Orientation');
ylabel('Spatial Frequency');

% X bound 
x_bnd=[1 0 -out_params(1)];
plot2dlinbnd(x_bnd,'r-'); 

% Y bound (plots y = yc)
y_bnd=[0 1 -out_params(2)];
plot2dlinbnd(y_bnd,'r-'); 

legend('A','B','x','y')
