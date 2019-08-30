function plot_indi_plots( type, groupsize, use_trans, thresh, no_axis_limits, masktype, nboot )
% PLOT_INDI_PLOTS( type, groupsize, trans_level, thresh, no_axis_limits, nboot )
% makes individual and transparent plots.
%--------------------------------------------------------------------------
% ARGUMENTS
% type      Either: 'mean', 'tstat' or 'smoothtstat'.
% nsubj     The number of subjects. Default is 20.
% trans_level  Default is 1 which means no transparency. Otherwise the
%           transparency of the individual plots is set to the specified amount.
%--------------------------------------------------------------------------
% OUTPUT
% Generates plots using export_fig.
%--------------------------------------------------------------------------
% EXAMPLES
% plotXbars( 'mean' )
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 1
    type = 'mean';
end
if nargin < 2
    groupsize = 20;
end
if nargin < 3
    use_trans = 1;
end
if nargin < 4
    thresh = 1;
end
if nargin < 5
    no_axis_limits = 1;
end

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

saveloc = [SIbootstrap_loc, 'ResultsFigures/Figures_10_12_14_S4/'];

out = prep_Xbar_plots( type, groupsize, thresh, no_axis_limits );
type = out.type;
circ_size = out.circ_size;
if use_trans
    trans_level = out.trans_level;
else
    trans_level = 1;
end

groupsize_str = num2str(groupsize);

filestart = [saveloc, type, '_nsubj', groupsize_str];

%% ests versus truth: indi plots
axis_font_size = 25;

clf
transplot(out.truenaiveboot, out.naive, circ_size, trans_level, def_col('red'))

xlabel(['True',' ', out.label_for_x])
ylabel(['Estimate of ',out.label_for_y])
xlim(out.xlims)
ylim(out.ylims)
set(0,'defaultAxesFontSize', axis_font_size);
abline(0,1,'color',[1,1,1]/2,'linestyle', '-', 'linewidth', 2)
title(['N = ', groupsize_str,': Circular'])
set(gcf, 'position', [500,500,out.height, out.width])
out.xtick
set(gca, 'XTick',out.xtick)
export_fig([filestart,'_circular.tif'], '-transparent')

clf
transplot(out.truenaiveboot, out.boot, circ_size, trans_level, def_col('yellow'))
xlabel(['True',' ', out.label_for_x])
ylabel(['Estimate of ',out.label_for_y])
abline(0,1,'color',[1,1,1]/2,'linestyle', '-')
xlim(out.xlims)
ylim(out.ylims)
set(0,'defaultAxesFontSize', axis_font_size);
abline(0,1,'color',[1,1,1]/2,'linestyle', '-', 'linewidth', 2)
title(['N = ', groupsize_str,': Bootstrap'])
set(gcf, 'position', [500,500,out.height, out.width])
set(gca, 'XTick',out.xtick)
export_fig([filestart,'_bootstrap.tif'], '-transparent')

clf
if groupsize == 20 && (strcmp(type, 't4lm') || strcmp(type, 'tstat'))
    trans_level = 0.6;
end

transplot(out.trueatlocis,out.is, circ_size, trans_level, def_col('blue'))
xlim(out.xlims)
ylim(out.ylims)
set(0,'defaultAxesFontSize', axis_font_size);
xlabel(['True',' ', out.label_for_x])
ylabel(['Estimate of ',out.label_for_y])
abline(0,1,'color',[1,1,1]/2,'linestyle', '-', 'linewidth', 2)
title(['N = ', groupsize_str,': Data-Splitting'])
set(gcf, 'position', [500,500,out.height,out.width])
set(gca, 'XTick',out.xtick)
export_fig([filestart,'_datasplitting.tif'], '-transparent')

end

