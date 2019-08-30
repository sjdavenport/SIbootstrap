function generate_boxplots( type )
% GERNATE)BOXPLOTS generates the boxplots for the paper.
%--------------------------------------------------------------------------
% ARGUMENTS
% TYPE  either 'mean', 'tstat', 't4lm' or 'R2'.
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.

global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc)
    error('SIbootstrap_loc must be defined by running startup.m')
end

if ~strcmp(type, 'tstat') && ~strcmp(type, 'mean') && ~strcmp(type, 't4lm') && ~strcmp(type, 'R2')
    error('This type is not available')
end

set(0,'defaultAxesFontSize', 16);
set(gcf, 'position', [0,550,1500,600])

version = 'bias';

if strcmp(type, 'R2')
    type = 'vbmagesex';
    out20 = dispres_thresh(type, 50, 0 );
    out50 = dispres_thresh(type, 100, 0 );
    out100 = dispres_thresh(type, 150, 0 );
    naive20 = out20.(strcat(version,'naive'))';
    naive50 = out50.(strcat(version,'naive'))';
    naive100 = out100.(strcat(version,'naive'))';
    is20 = out20.(strcat(version,'is'))';
    is50 = out50.(strcat(version,'is'))';
    is100 = out100.(strcat(version,'is'))';
    boot20 = out20.(strcat(version,'boot'))';
    boot50 = out50.(strcat(version,'boot'))';
    boot100 = out100.(strcat(version,'boot'))';
else
    out20 = dispres_thresh(type, 20, 0 );
    out50 = dispres_thresh(type, 50, 0 );
    out100 = dispres_thresh(type, 100, 0 );
    
    naive20 = out20.(strcat(version,'naive'))';
    naive50 = out50.(strcat(version,'naive'))';
    naive100 = out100.(strcat(version,'naive'))';
    is20 = out20.(strcat(version,'is'))';
    is50 = out50.(strcat(version,'is'))';
    is100 = out100.(strcat(version,'is'))';
    boot20 = out20.(strcat(version,'boot'))';
    boot50 = out50.(strcat(version,'boot'))';
    boot100 = out100.(strcat(version,'boot'))';
end

group_vector = repelem(1:9, [length(naive20), length(is20), length(boot20), length(naive50), length(is50), length(boot50), length(naive100), length(is100), length(boot100)]);

data = [naive20, is20, boot20, naive50, is50, boot50, naive100, is100, boot100 ];
boxplot_mod(data, group_vector, 'symbol', '');

set(gca,'xticklabel',{'Circular','Data-Splitting','Bootstrap','Circular','Data-Splitting','Bootstrap','Circular','Data-Splitting','Bootstrap'})

if strcmp(type, 'tstat')
    corresponding_figure = '10';
    vert_placement = -0.77;
elseif strcmp(type, 't4lm')
    corresponding_figure = '12';
    vert_placement = -19.5/100;
elseif strcmp(type, 'mean')
    corresponding_figure = 'S5';
    vert_placement = -50.5/100;
end

if strcmp(type, 'vbmagesex')
    corresponding_figure = '14';
    vert_placement = -0.16;
    text(1.67,vert_placement, 'N = 50', 'FontSize', 20)
    text(1.67+2.9,vert_placement, 'N = 100', 'FontSize', 20)
    text(1.67+5.9,vert_placement, 'N = 150', 'FontSize', 20)
else
    text(1.67,vert_placement, 'N = 20', 'FontSize', 20)
    text(1.67+3,vert_placement, 'N = 50', 'FontSize', 20)
    text(1.67+5.9,vert_placement, 'N = 100', 'FontSize', 20)
end
abline('v',3.5, 'LineStyle', '-', 'color', 'black') 
abline('v',6.5, 'LineStyle', '-', 'color', 'black') 
abline('h', 0)
title(['Comparing the ', version,' over the significant peaks'],'FontSize', 25, 'FontWeight', 'normal')

%Plot the average:
hold on
plot(1, mean(naive20(~isnan(naive20))), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )
plot(4, mean(naive50), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )
plot(7, mean(naive100), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )

plot(3, mean(boot20(~isnan(boot20))), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )
plot(6, mean(boot50), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )
plot(9, mean(boot100), 'o', 'MarkerFaceColor','black', 'MarkerEdgeColor', 'black' )

plot(2, mean(is20(~isnan(is20))), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )
plot(5, mean(is50), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )
plot(8, mean(is100), 'o', 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black' )

lower_quantile = 0.1;
upper_quantile = 0.9;

ymin = min([quantile(naive20, lower_quantile), quantile(is20, lower_quantile), quantile(boot20, lower_quantile),quantile(naive50, lower_quantile), quantile(is50, lower_quantile), quantile(boot50, lower_quantile), quantile(naive100, lower_quantile), quantile(is100, lower_quantile), quantile(boot100, lower_quantile)]);
ymax = max([quantile(naive20, upper_quantile), quantile(is20, upper_quantile), quantile(boot20, upper_quantile),quantile(naive50, upper_quantile), quantile(is50, upper_quantile), quantile(boot50, upper_quantile), quantile(naive100, upper_quantile), quantile(is100, upper_quantile), quantile(boot100, upper_quantile)]);

ylim([ymin, ymax])

label_for_y_axis = capstr(version);
if strcmp(type, 'tstat')
    label_for_y_axis = [label_for_y_axis, ' in Cohen''s d'];
elseif strcmp(type, 'vbmagesex')
    label_for_y_axis = [label_for_y_axis, ' in R^2'];
elseif strcmp(type, 't4lm') || strcmp(type, 'mean')
    label_for_y_axis = [label_for_y_axis, ' in %BOLD'];
end

ylabel(label_for_y_axis, 'FontSize', 20)
h = gca;
h.XRuler.TickLength = 0;

export_fig([SIbootstrap_loc, 'ResultsFigures/Figures_10_12_14_S5/Figure_', corresponding_figure,'_bias.pdf'], '-transparent')

end

