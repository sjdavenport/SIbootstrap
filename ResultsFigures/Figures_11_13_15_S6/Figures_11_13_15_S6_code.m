%% Code to generate Figures 11, 13, 15 and S6.
% export_fig is required in order to save the images. 

thresh = 1;
no_axis_limits = 0;
for type = {'tstat', 't4lm', 'mean'}
    for groupsize = [20,50,100]
        type{1}
        plot_indi_plots( type{1}, groupsize, 1, thresh, no_axis_limits );
    end
end

%%
thresh = 1;
no_axis_limits = 0;
for type = {'vbmagesex'}
    for groupsize = [50,100,150]
        type{1}
        plot_indi_plots( type{1}, groupsize, 1, thresh, no_axis_limits );
    end
end
