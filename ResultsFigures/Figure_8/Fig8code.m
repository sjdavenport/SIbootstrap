%% Code to generate Figure 8.
% export_fig is required in order to save the images. 

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

type_set = {'tstat'};

diff_ylims_valueset = {[0,2.5]};
av_ylims_valueset = {[0,4]};

diff_ylims = containers.Map( type_set, diff_ylims_valueset );
av_ylims = containers.Map( type_set, av_ylims_valueset );

set(0,'defaultAxesFontSize', 20);
% truth = imgload('fullmos'); %Load True Cohen's d
% truth_at_max = max(truth(:));

truth_at_max = 1.575556278228760; %Calculated using the above calculation.

width = 700;
for type = type_set
    %container is generated using biasvsSS.m
    container = load([SIbootstrap_loc, 'Results_Figures/Figure_8/', type{1}, 'MaxvsTruth.mat']);
    container = container.container;
    sample_list = cell2mat(keys(container));
    sample_list = sample_list(sample_list >= 10);
    
    n_sample_list = length(sample_list);
    
    diff_meansub_truth = zeros(1, n_sample_list);
    average_peak_height = zeros(1, n_sample_list);
    errorbar_list = zeros(1, n_sample_list);
    diff_meansub_truth_percent = zeros(1, n_sample_list);
    
    for I = 1:n_sample_list
        cont_at_sample = container(sample_list(I));
        combsub = cont_at_sample(:,1);
        truth = cont_at_sample(:,2);
        
        diff_meansub_truth(I) = mean(combsub) - truth_at_max;
        average_peak_height(I) = mean(combsub);
        LowerAndUpperQuantiles = quantile(combsub, [0.025, 0.975]);
        errorbar_list(I) = LowerAndUpperQuantiles(2) - LowerAndUpperQuantiles(1);
        diff_meansub_truth_percent(I) = mean((combsub  - truth_at_max)./truth_at_max);
    end
    
    %Plot with error bars
    cla
        line1 = plot(sample_list,average_peak_height, 'linewidth', 4);
        hold on
        errorbar(sample_list,average_peak_height, errorbar_list, 'linewidth', 2, 'color', def_col('blue'));
        hold on
        line2 = plot(sample_list, repmat(truth_at_max, 1, length(sample_list)), 'linewidth', 4);
        legend([line1,line2],'Average Max Peak Height', 'True Max Peak Height', 'Location','NorthEast')
        xlabel('Sample Size'); ylabel('Cohen''s d');
        title('Average Relative to Truth')
        xlim([sample_list(1),sample_list(end)])
    
    ylim(av_ylims(type{1}))
    set(gcf, 'position', [500,500,width,500])
    export_fig([SIbootstrap_loc, 'ResultsFigures/Figure_8/Fig8.pdf'], '-transparent')
end
