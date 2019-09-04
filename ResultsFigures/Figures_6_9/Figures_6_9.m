%% Code to Generate Figure 6 and XXX: which calculates the number of voxels above the threshold.
clf
global SIbootstrap_loc

nvoxstore_loc = [SIbootstrap_loc,'Simulations/Power/nvoxstore/'];

nsubj_vec_boot = 20:10:100;

vec_of_avgs_boot = zeros(1, length(nsubj_vec_boot));
vec_of_avgs_ds = zeros(1,  length(nsubj_vec_boot));

for I = 1:length(nsubj_vec_boot)
    load( [nvoxstore_loc, num2str(nsubj_vec_boot(I)), '.mat'])
    vec_of_avgs_boot(I) = avnvox;
    load( [nvoxstore_loc, num2str(nsubj_vec_boot(I)/2),'.mat'])
    vec_of_avgs_ds(I) = avnvox;
end

%%
plot(nsubj_vec_boot, vec_of_avgs_boot, 'LineWidth', 4, 'color', def_col('yellow'))
hold on
plot(nsubj_vec_boot, vec_of_avgs_ds, 'LineWidth', 4, 'color', def_col('blue'))

pos_vector = [0,550,1000,800];
set(gcf, 'position', pos_vector)
title('Comparing Power')
xlabel('Sample Size')
ylabel('Average number of voxels above the threshold')
legend('Bootstrap/Circular', 'Data-Splitting', 'Location', 'NorthWest')

set(gca,'fontsize', 30)

%% Plot saving:
export_fig([SIbootstrap_loc, 'ResultsFigures/Figures_6_9/Figure_6.pdf'], '-transparent')

%%
clf
nvoxstore_loc = [SIbootstrap_loc,'Results/PowerResults/'];

nsubj_vec_boot = 10:10:100;

vec_of_avgs_boot = zeros(1, length(nsubj_vec_boot));
vec_of_avgs_ds = zeros(1,  length(nsubj_vec_boot));

for I = 1:length(nsubj_vec_boot)
    load( [nvoxstore_loc, num2str(nsubj_vec_boot(I)), '.mat'])
    vec_of_avgs_boot(I) = avnvox;
    load( [nvoxstore_loc, num2str(nsubj_vec_boot(I)/2),'.mat'])
    vec_of_avgs_ds(I) = avnvox;
end

%%
% axis_font_size = 40;
% set(0,'defaultAxesFontSize', axis_font_size);
plot(nsubj_vec_boot, vec_of_avgs_boot, 'LineWidth', 4, 'color', def_col('yellow'))
hold on
plot(nsubj_vec_boot, vec_of_avgs_ds, 'LineWidth', 4, 'color', def_col('blue'))

pos_vector = [0,550,1000,800];
set(gcf, 'position', pos_vector)
title('Comparing Power')
xlabel('Sample Size')
ylabel('Average number of voxels above the threshold')
legend('Bootstrap/Circular', 'Data-Splitting', 'Location', 'NorthWest')

set(gca,'fontsize', 30)

%% Plot saving:
export_fig([SIbootstrap_loc, 'ResultsFigures/Figures_6_9/Figure_9.pdf'], '-transparent')