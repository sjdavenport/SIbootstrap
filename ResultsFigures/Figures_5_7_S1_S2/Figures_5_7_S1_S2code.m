%% Code to generate Figures 5, 7, S1 and S2
% export_fig is required in order to save the images. 

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

subject_list = 20:10:100;
nentries = length(subject_list);
K = 0;
pos_vector = [0,550,800,533];

corresponding_figure = {'S1', '5', '7', 'S2'};

for type = {'mean','tstat', 't4lm', 'R2'}
    K = K+1;
    for FWHM = 3
        isbias = zeros(1, nentries);
        isrmse = zeros(1, nentries);
        bootbias = zeros(1, nentries);
        bootrmse = zeros(1, nentries);
        naivebias = zeros(1, nentries);
        naivermse = zeros(1, nentries);
        
        for I = 1:nentries
            try
                out = dispres_sims_thresh(type{1}, subject_list(I), FWHM );
%                 out = dispres_sims_thresh(type{1}, subject_list(I), s, FWHM, version, 0 , 0);
                I
                isbias(I) = mean(out.biasis);
%                 ismse(I) = mean(out.mseis);
                isrmse(I) = sqrt(mean(out.mseis));
                naivebias(I) = mean(out.biasnaive);
%                 naivemse(I) = mean(out.msenaive);
                naivermse(I) = sqrt(mean(out.msenaive));
                bootbias(I) = mean(out.biasboot);
                bootrmse(I) = sqrt(mean(out.mseboot));
%                 bootmse(I) = mean(out.mseboot);
            catch 
                isbias(I) = 0;
                isrmse(I) =  0;
                naivebias(I) = 0;
                naivermse(I) = 0;
                bootbias(I) = 0;
                bootrmse(I) = 0;
            end
        end
        
        bootsd = (bootrmse.^2 - bootbias.^2);
        naivesd = (naivermse.^2 - naivebias.^2);
        issd = (isrmse.^2 - isbias.^2);
        
        clf
        plot( subject_list, naivebias, 'linewidth', 2, 'Color', def_col('red'))
        hold on
        plot( subject_list, isbias, 'linewidth', 2,'Color', def_col('blue'))
        plot( subject_list, bootbias, 'linewidth', 2,'Color', def_col('yellow'))
        xlabel('Sample Size: N')
        ylabel('Bias')
        xlim([subject_list(1),subject_list(end)])
        title('Bias vs Sample Size')
        %             if groupsize == 20
        legend('Circular', 'Data-Splitting', 'Bootstrap' )
        %             end
        set(gca,'fontsize', 20)
        set(gcf, 'position', pos_vector)
        export_fig([SIbootstrap_loc,'ResultsFigures/Figures_5_7_S1_S2/Figure_', corresponding_figure{K},'_bias'], '-transparent')
        
        
        clf
        plot( subject_list, naivermse, 'linewidth', 2, 'Color', def_col('red'))
        hold on
        plot( subject_list, isrmse, 'linewidth', 2,'Color', def_col('blue'))
        plot( subject_list, bootrmse, 'linewidth', 2,'Color', def_col('yellow'))
        xlabel('Sample Size: N')
        ylabel('RMSE')
        xlim([subject_list(1), subject_list(end)])
        title(['RMSE vs Sample Size'])
%         legend('Circular', 'Data-Splitting', 'Bootstrap' )
        set(gca,'fontsize', 20)
        set(gcf, 'position', pos_vector)
        export_fig([SIbootstrap_loc,'ResultsFigures/Figures_5_7_S1_S2/Figure_', corresponding_figure{K},'_rmse'], '-transparent')
        
        
        clf
        plot( subject_list, naivesd, 'linewidth', 2, 'Color', def_col('red'))
        hold on
        plot( subject_list, issd, 'linewidth', 2, 'Color', def_col('blue'))
        plot( subject_list, bootsd, 'linewidth', 2,'Color', def_col('yellow'))
        xlabel('Sample Size: N')
        ylabel('Standard Deviation')
        xlim([subject_list(1),subject_list(end)])
        title('Standard Deviation vs Sample Size')
%         legend('Circular', 'Data-Splitting', 'Bootstrap' )
        set(gca,'fontsize', 20)
        set(gcf, 'position', pos_vector)
        export_fig([SIbootstrap_loc,'ResultsFigures/Figures_5_7_S1_S2/Figure_', corresponding_figure{K},'_std'], '-transparent')
    end
end