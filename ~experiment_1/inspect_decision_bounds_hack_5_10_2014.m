close all
clear all
clc

use_resp = 1; %use_resp = 1 means use the actual subject responses, 0 means use true categories
num_trials = 800;
block_size = 100;
num_blocks = 8;

sub_nums_parse_congruent = [1:4 9 31:2:37 41:2:47 51 53 101:2:107];
sub_nums_parse_rotated = [5 7 8 10 32:2:38 42:2:48 55 58 102:2:108];
sub_nums_control_congruent = [1 2 10:17 20:27 106:108];
sub_nums_control_rotated = [1:8 21 22 41:44 101:105]; 
sub_nums_control_rotated_new = [1:8 10:13 15:19];

num_subs_parse_congruent = length(sub_nums_parse_congruent);
num_subs_parse_rotated = length(sub_nums_parse_rotated);
num_subs_control_congruent = length(sub_nums_control_congruent);
num_subs_control_rotated = length(sub_nums_control_rotated);
num_subs_control_rotated_new = length(sub_nums_control_rotated_new);

%% toggle which data to use
% sub_nums = sub_nums_parse_congruent;
% num_subs = num_subs_parse_congruent;
% data_path = [pwd '/~parse_conditions/model_fitting_2_15_2014'];
% 
% sub_nums = sub_nums_parse_rotated;
% num_subs = num_subs_parse_rotated;
% data_path = [pwd '/~parse_conditions/model_fitting_2_15_2014'];
% 
% sub_nums = sub_nums_control_congruent;
% num_subs = num_subs_control_congruent;
% data_path = [pwd '/~control_congruent/model_fitting_2_15_2014'];
% 
% sub_nums = sub_nums_control_rotated;
% num_subs = num_subs_control_rotated;
% data_path = [pwd '/~control_rotated/model_fitting_2_15_2014'];
% 
sub_nums = sub_nums_control_rotated_new;
num_subs = num_subs_control_rotated_new;
data_path = [pwd '/~control_rotated_new/model_fitting_2_15_2014'];

%%
unix_param_record_a1 = NaN(num_blocks,num_subs);
unix_param_record_a2 = NaN(num_blocks,num_subs);
unix_param_record_b = NaN(num_blocks,num_subs);

uniy_param_record_a1 = NaN(num_blocks,num_subs);
uniy_param_record_a2 = NaN(num_blocks,num_subs);
uniy_param_record_b = NaN(num_blocks,num_subs);

glc_param_record_a1 = NaN(num_blocks,num_subs);
glc_param_record_a2 = NaN(num_blocks,num_subs);
glc_param_record_b = NaN(num_blocks,num_subs);

unix_pra_record = NaN(num_blocks,num_subs);
uniy_pra_record = NaN(num_blocks,num_subs);
glc_pra_record = NaN(num_blocks,num_subs);

fit_count = zeros(num_blocks,4); % unix uniy glc guess

sub_x_record = zeros(num_trials,num_subs);
sub_y_record = zeros(num_trials,num_subs);

for i = 1:num_subs
    
    data = dlmread([data_path '/~data/subject' num2str(sub_nums(i)) '.dat']);
    accuracy = dlmread([data_path '/~output/raw_accuracy_sub' num2str(sub_nums(i)) '.dat']);
    bic = dlmread([data_path '/~output/raw_BIC_sub' num2str(sub_nums(i)) '.dat']);
    unix_params = dlmread([data_path '/~output/unix_params_sub' num2str(sub_nums(i)) '.dat']);
    uniy_params = dlmread([data_path '/~output/uniy_params_sub' num2str(sub_nums(i)) '.dat']);
    glc_params = dlmread([data_path '/~output/GLC_params_sub' num2str(sub_nums(i)) '.dat']);
    pra = dlmread([data_path '/~output/percent_responses_accounted' num2str(sub_nums(i)) '.dat']);
    
    switch_ind = find(pra<0.5);
    pra(switch_ind) = 1 -  pra(switch_ind);
    
    sub_x_record(:,i) = data(:,2);
    sub_y_record(:,i) = data(:,3);
    
    for j = 1:num_blocks % iterate through blocks

        % guessing biased_guessing unix uniy
        guessing = bic(j,1);
        biased_guessing = bic(j,2);
        unix_bic = bic(j,3);
        uniy_bic = bic(j,4);
        glc_bic = bic(j,5);

        switch min([unix_bic uniy_bic glc_bic guessing biased_guessing])

            case unix_bic

                a1 = unix_params(j,1);
                a2 = unix_params(j,2);
                b = unix_params(j,3);

                unix_param_record_a1(j,i) = a1;
                unix_param_record_a2(j,i) = a2;
                unix_param_record_b(j,i) = b;
%                 unix_pra_record(j,i) = pra(j,1);

                fit_count(j,1) = fit_count(j,1)+1;

            case uniy_bic

                a1 = uniy_params(j,1);
                a2 = uniy_params(j,2);
                b = uniy_params(j,3);

                uniy_param_record_a1(j,i) = a1;
                uniy_param_record_a2(j,i) = a2;
                uniy_param_record_b(j,i) = b;
%                 uniy_pra_record(j,i) = pra(j,2);

                fit_count(j,2) = fit_count(j,2)+1;

            case glc_bic

                a1 = glc_params(j,1);
                a2 = glc_params(j,2);
                b = glc_params(j,3);
                
                glc_param_record_a1(j,i) = a1;
                glc_param_record_a2(j,i) = a2;
                glc_param_record_b(j,i) = b;
                glc_pra_record(j,i) = pra(j,3);
                
                unix_pra_record(j,i) = pra(j,1);
                uniy_pra_record(j,i) = pra(j,2);
                
                if j == 11
                    a1/a2
                    display(['unix ' num2str(pra(j,1))]);
                    display(['uniy ' num2str(pra(j,2))]);
                    display(['glc ' num2str(pra(j,3))]);
                    display([' ']);
                end

                fit_count(j,3) = fit_count(j,3)+1;

            case guessing
                fit_count(j,4) = fit_count(j,4) +1;

            case biased_guessing
                fit_count(j,4) = fit_count(j,4) +1;
                    
        end

    end   

end

%% 
mean_pra_unix = nanmean(unix_pra_record,2);
mean_pra_uniy = nanmean(uniy_pra_record,2);
mean_pra_glc = nanmean(glc_pra_record,2);

stderr_pra_unix = nanstd(unix_pra_record)/sqrt(size(unix_pra_record,1));
stderr_pra_uniy = nanstd(uniy_pra_record)/sqrt(size(uniy_pra_record,1));
stderr_pra_glc = nanstd(glc_pra_record)/sqrt(size(glc_pra_record,1));

stderr_pra_unix = stderr_pra_unix';
stderr_pra_uniy = stderr_pra_uniy';
stderr_pra_glc = stderr_pra_glc';

fit_count = [fit_count(:,3) fit_count(:,1)+fit_count(:,2) fit_count(:,4)];
f_pra = [mean_pra_glc nanmean([mean_pra_unix mean_pra_uniy],2)];

%%
color = lines(num_subs);

figure
for block = 1:num_blocks
    subplot(3,5,block), hold
    for sub = 1:num_subs
        plot2dlinbnd([unix_param_record_a1(block,sub) unix_param_record_a2(block,sub) unix_param_record_b(block,sub)],'-',[0 100 0 100], color(1,:))
        plot2dlinbnd([uniy_param_record_a1(block,sub) uniy_param_record_a2(block,sub) uniy_param_record_b(block,sub)],'-',[0 100 0 100], color(2,:))
        plot2dlinbnd([glc_param_record_a1(block,sub) glc_param_record_a2(block,sub) glc_param_record_b(block,sub)],'-',[0 100 0 100], color(3,:))
    end
    title(num2str(block), 'fontsize', 12, 'fontweight', 'b')
    axis square
    set(gca,'linewidth',2)
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    box on
end

figure, hold
plot(mean_pra_unix,'linewidth',2,'color',color(1,:))
plot(mean_pra_uniy,'linewidth',2,'color',color(2,:))
plot(mean_pra_glc,'linewidth',2,'color',color(3,:))
% ciplot(mean_pra_unix-stderr_pra_unix, mean_pra_unix+stderr_pra_unix, 1:num_blocks, color(1,:))
% ciplot(mean_pra_uniy-stderr_pra_uniy, mean_pra_uniy+stderr_pra_uniy, 1:num_blocks, color(2,:))
% ciplot(mean_pra_glc-stderr_pra_glc, mean_pra_glc+stderr_pra_glc, 1:num_blocks, color(3,:))
% camlight; lighting none; 
% alpha(0.1)
axis([0 num_blocks+1 0.5 1])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Percent Responses Accounted', 'fontsize', 18, 'fontweight', 'b')
legend({'UNIX','UNIY','GLC'}, 'fontsize', 18, 'Location', 'south');
legend boxoff

figure, hold
% plot(fit_count(:,1),'linewidth',2,'color',color(1,:))
% plot(fit_count(:,2),'linewidth',2,'color',color(2,:))
% plot(fit_count(:,3),'linewidth',2,'color',color(3,:))
% plot(fit_count(:,4),'linewidth',2,'color',color(4,:))
bar(fit_count,'stacked'), colormap(lines(4))
axis([0 num_blocks+1 0 num_subs])
axis square
set(gca,'XTick',2:2:num_blocks, 'fontsize', 12, 'fontweight', 'b')
xlabel('Block', 'fontsize', 18, 'fontweight', 'b')
ylabel('Number of Participants', 'fontsize', 18, 'fontweight', 'b')
legend({'UNIX','UNIY','GLC', 'GUESS'}, 'fontsize', 18, 'Location', 'eastoutside');
legend boxoff
