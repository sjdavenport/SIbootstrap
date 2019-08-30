%% Code to generate the barplots for Figures 10, 12, 14 and S5
% export_fig is required in order to save the images. 

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

save_loc = [SIbootstrap_loc, 'ResultsFigures/Figures_10_12_14_S5/'];

%%
type = 'mean';
corresponding_figure = 'S5';
pos_vector = [0,550,1500,600];
mse_plots = zeros(3,3);
var_plots = zeros(3,3);
bias_plots = zeros(3,3);
nsubj = [20, 50, 100];

for I = 1:3
    out = dispres_thresh(type, nsubj(I));
    mse_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive)));
    mse_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis)));
    mse_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot)));
    %Convert to RMSE
    mse_plots(I, 1) = sqrt(mse_plots(I, 1));
    mse_plots(I, 2) = sqrt(mse_plots(I, 2));
    mse_plots(I, 3) = sqrt(mse_plots(I, 3));
   
    var_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive))) - mean(out.biasnaive(~isnan(out.biasnaive)))^2;
    var_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis))) - mean(out.biasis(~isnan(out.biasis)))^2;
    var_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot))) - mean(out.biasboot(~isnan(out.biasboot)))^2;
    %Convert to sd.
    var_plots(I, 1) = sqrt(var_plots(I, 1));
    var_plots(I, 2) = sqrt(var_plots(I, 2));
    var_plots(I, 3) = sqrt(var_plots(I, 3));
    
    bias_plots(I,1) = mean(out.biasnaive(~isnan(out.biasnaive)));
    bias_plots(I,2) = mean(out.biasis(~isnan(out.biasis)));
    bias_plots(I,3) = mean(out.biasboot(~isnan(out.biasboot)));
end

%%
set(0,'defaultAxesFontSize', 20);
bar_mse_plot = bar(mse_plots, 'FaceColor', def_col('blue'));
bar_mse_plot(1).FaceColor = def_col('red');
bar_mse_plot(3).FaceColor = def_col('yellow');
% xlim([0.35,3.65])
ylim([0,0.5])

legend('Circular', 'Data-Splitting', 'Bootstrap')
% set(gca, 'XTicks',[1, 2, 3])
ylabel('RMSE in %BOLD', 'FontSize', 20)
title('Comparing the RMSE across significant peaks','FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 20', 'N = 50', 'N = 100'})
set(gcf, 'position', pos_vector)
% abline('v',1.5, 'LineStyle', '-', 'color', 'black') 
% abline('v',2.5, 'LineStyle', '-', 'color', 'black') 
export_fig([save_loc, 'Figure_', corresponding_figure, '_rmse.pdf'], '-transparent')

%%
bar_var_plot = bar(var_plots, 'FaceColor', def_col('blue'));
bar_var_plot(1).FaceColor = def_col('red');
bar_var_plot(3).FaceColor = def_col('yellow');

legend('Circular', 'Data-Splitting', 'Bootstrap')
% xlim([0.35,3.65])
ylabel('Standard Deviation in %BOLD', 'FontSize', 20)
title('Comparing the standard deviation across significant peaks','FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 20', 'N = 50', 'N = 100'})
set(gcf, 'position', pos_vector)
export_fig([save_loc, 'Figure_', corresponding_figure, '_std.pdf'], '-transparent')

%%
type = 'tstat';
corresponding_figure = '10';

pos_vector = [0,550,1500,600];
mse_plots = zeros(3,3);
var_plots = zeros(3,3);
bias_plots = zeros(3,3);
nsubj = [20, 50, 100];

for I = 1:3
    out = dispres_thresh(type, nsubj(I));
    mse_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive)));
    mse_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis)));
    mse_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot)));
    mse_plots(I, 1) = sqrt(mse_plots(I, 1));
    mse_plots(I, 2) = sqrt(mse_plots(I, 2));
    mse_plots(I, 3) = sqrt(mse_plots(I, 3));
    
    var_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive))) - mean(out.biasnaive(~isnan(out.biasnaive)))^2;
    var_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis))) - mean(out.biasis(~isnan(out.biasis)))^2;
    var_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot))) - mean(out.biasboot(~isnan(out.biasboot)))^2;
    var_plots(I, 1) = sqrt(var_plots(I, 1));
    var_plots(I, 2) = sqrt(var_plots(I, 2));
    var_plots(I, 3) = sqrt(var_plots(I, 3));
    
    bias_plots(I,1) = mean(out.biasnaive(~isnan(out.biasnaive)));
    bias_plots(I,2) = mean(out.biasis(~isnan(out.biasis)));
    bias_plots(I,3) = mean(out.biasboot(~isnan(out.biasboot)));
%     mse_plots(I, 1) = mean(out.MSEnaive);
%     mse_plots(I, 2) = mean(out.MSEis);
%     mse_plots(I, 3) = mean(out.MSEboot);
%     
%     var_plots(I, 1) = mean(out.MSEnaive) - mean(out.biasnaive)^2;
%     var_plots(I, 2) = mean(out.MSEis) - mean(out.biasis)^2;
%     var_plots(I, 3) = mean(out.MSEboot) - mean(out.biasboot)^2;
%     
%     bias_plots(I,1) = mean(out.biasnaive);
%     bias_plots(I,2) = mean(out.biasis);
%     bias_plots(I,3) = mean(out.biasboot);
end

%%
set(0,'defaultAxesFontSize', 20);
bar_mse_plot = bar(mse_plots, 'FaceColor', def_col('blue'));
bar_mse_plot(1).FaceColor = def_col('red');
bar_mse_plot(3).FaceColor = def_col('yellow');
% xlim([0.35,3.65])
ylim([0,0.55])

legend('Circular', 'Data-Splitting', 'Bootstrap')
% set(gca, 'XTicks',[1, 2, 3])
ylabel('RMSE of Cohen''s d', 'FontSize', 20)
title('Comparing the RMSE across significant peaks','FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 20', 'N = 50', 'N = 100'})
set(gcf, 'position', pos_vector)
% abline('v',1.5, 'LineStyle', '-', 'color', 'black') 
% abline('v',2.5, 'LineStyle', '-', 'color', 'black') 
export_fig([save_loc, 'Figure_', corresponding_figure, '_rmse.pdf'], '-transparent')
%%
set(0,'defaultAxesFontSize', 20);
bar_var_plot = bar(var_plots, 'FaceColor', def_col('blue'));
bar_var_plot(1).FaceColor = def_col('red');
bar_var_plot(3).FaceColor = def_col('yellow');

legend('Circular', 'Data-Splitting', 'Bootstrap')
% xlim([0.35,3.65])
ylabel('Standard Deviation of Cohen''s d', 'FontSize', 20)
title('Comparing the standard deviation across significant peaks','FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 20', 'N = 50', 'N = 100'})
set(gcf, 'position', pos_vector)
export_fig([save_loc, 'Figure_', corresponding_figure, '_std.pdf'], '-transparent')


%%
type = 't4lm';
corresponding_figure = '12';

mse_plots = zeros(3,3);
var_plots = zeros(3,3);
bias_plots = zeros(3,3);
nsubj = [20, 50, 100];

for I = 1:3
    out = dispres_thresh(type, nsubj(I));
    mse_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive)));
    mse_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis)));
    mse_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot)));
    mse_plots(I, 1) = sqrt(mse_plots(I, 1));
    mse_plots(I, 2) = sqrt(mse_plots(I, 2));
    mse_plots(I, 3) = sqrt(mse_plots(I, 3));
    
    var_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive))) - mean(out.biasnaive(~isnan(out.biasnaive)))^2;
    var_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis))) - mean(out.biasis(~isnan(out.biasis)))^2;
    var_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot))) - mean(out.biasboot(~isnan(out.biasboot)))^2;
    var_plots(I, 1) = sqrt(var_plots(I, 1));
    var_plots(I, 2) = sqrt(var_plots(I, 2));
    var_plots(I, 3) = sqrt(var_plots(I, 3));
    
    bias_plots(I,1) = mean(out.biasnaive(~isnan(out.biasnaive)));
    bias_plots(I,2) = mean(out.biasis(~isnan(out.biasis)));
    bias_plots(I,3) = mean(out.biasboot(~isnan(out.biasboot)));
end

%%
% set(0,'defaultAxesFontSize', 16);
set(0,'defaultAxesFontSize', 20);
bar_mse_plot = bar(mse_plots, 'FaceColor', def_col('blue'));
bar_mse_plot(1).FaceColor = def_col('red');
bar_mse_plot(3).FaceColor = def_col('yellow');
% xlim([0.35,3.65])
ylim(sqrt([0,350]/10000))

legend('Circular', 'Data-Splitting', 'Bootstrap')
% set(gca, 'XTicks',[1, 2, 3])
ylabel('RMSE in %BOLD', 'FontSize', 20)
title('Comparing the RMSE across significant peaks', 'FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 20', 'N = 50', 'N = 100'})
set(gcf, 'position', pos_vector)
export_fig([save_loc, 'Figure_', corresponding_figure, '_rmse.pdf'], '-transparent')
%%
set(0,'defaultAxesFontSize', 20);
bar_var_plot = bar(var_plots, 'FaceColor', def_col('blue'));
bar_var_plot(1).FaceColor = def_col('red');
bar_var_plot(3).FaceColor = def_col('yellow');

legend('Circular', 'Data-Splitting', 'Bootstrap')
% xlim([0.35,3.65])
ylabel('Standard Deviation in %BOLD', 'FontSize', 20)
title('Comparing the standard deviation across significant peaks','FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 20', 'N = 50', 'N = 100'})
set(gcf, 'position', pos_vector)
export_fig([save_loc, 'Figure_', corresponding_figure, '_std.pdf'], '-transparent')


%%
type = 'vbmagesex';
corresponding_figure = '14';
pos_vector = [0,550,1500,600];

mse_plots = zeros(3,3);
var_plots = zeros(3,3);
bias_plots = zeros(3,3);
nsubj = [50, 100, 150];

for I = 1:length(nsubj)
    out = dispres_thresh(type, nsubj(I));
    mse_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive)));
    mse_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis)));
    mse_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot)));
    mse_plots(I, 1) = sqrt(mse_plots(I, 1));
    mse_plots(I, 2) = sqrt(mse_plots(I, 2));
    mse_plots(I, 3) = sqrt(mse_plots(I, 3));
    
    var_plots(I, 1) = mean(out.MSEnaive(~isnan(out.MSEnaive))) - mean(out.biasnaive(~isnan(out.biasnaive)))^2;
    var_plots(I, 2) = mean(out.MSEis(~isnan(out.MSEis))) - mean(out.biasis(~isnan(out.biasis)))^2;
    var_plots(I, 3) = mean(out.MSEboot(~isnan(out.MSEboot))) - mean(out.biasboot(~isnan(out.biasboot)))^2;
    var_plots(I, 1) = sqrt(var_plots(I, 1));
    var_plots(I, 2) = sqrt(var_plots(I, 2));
    var_plots(I, 3) = sqrt(var_plots(I, 3));
    
    bias_plots(I,1) = mean(out.biasnaive(~isnan(out.biasnaive)));
    bias_plots(I,2) = mean(out.biasis(~isnan(out.biasis)));
    bias_plots(I,3) = mean(out.biasboot(~isnan(out.biasboot)));
end

%%
% set(0,'defaultAxesFontSize', 16);
set(0,'defaultAxesFontSize', 20);
bar_mse_plot = bar(mse_plots, 'FaceColor', def_col('blue'));
bar_mse_plot(1).FaceColor = def_col('red');
bar_mse_plot(3).FaceColor = def_col('yellow');
ylim(sqrt([0,0.04]))

legend('Circular', 'Data-Splitting', 'Bootstrap')
% set(gca, 'XTicks',[1, 2, 3])
ylabel('RMSE of R^2', 'FontSize', 20)
title('Comparing the RMSE across significant peaks', 'FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 50', 'N = 100', 'N = 150'})
set(gcf, 'position', pos_vector)
export_fig([save_loc, 'Figure_', corresponding_figure, '_rmse.pdf'], '-transparent')

%%
set(0,'defaultAxesFontSize', 20);
bar_var_plot = bar(var_plots, 'FaceColor', def_col('blue'));
bar_var_plot(1).FaceColor = def_col('red');
bar_var_plot(3).FaceColor = def_col('yellow');


legend('Circular', 'Data-Splitting', 'Bootstrap')
% xlim([0.35,3.65])
ylabel('Standard Deviation of R^2', 'FontSize', 20)
title('Comparing the standard deviation across significant peaks','FontSize', 25, 'FontWeight', 'normal')
set(gca, 'XTickLabel', {'N = 50', 'N = 100', 'N = 150'})
set(gcf, 'position', pos_vector)
export_fig([save_loc, 'Figure_', corresponding_figure, '_std.pdf'], '-transparent')
