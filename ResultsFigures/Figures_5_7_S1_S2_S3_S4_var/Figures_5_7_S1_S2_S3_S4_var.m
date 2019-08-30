%% Code to generate the variance simulation parts of Figures: 5,7,S1,S2,S3 and S4
% export_fig is required in order to save the images. 

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

nsubj = 50;
K = 0;
pos_vector = [0,550,800,533];

% corresponding_figure = {'S1', '5', '7', 'S2'};
corresponding_figure = {'A'};


% {'mean','tstat', 't4lm', 'R2'};
% for type = {'meanSD','t4lm50', 't4lm100','R250', 'R2100', 'tstat'}
for type = {'meanSD', 't4lm100'}
    typo = type{1};
    if strcmp(typo(1:2), 'R2')
        nsubj = str2double(typo(3:end));
        typo = 'R2';
        ES_values = 0.05:0.05:0.3;
        x_ax_label = 'Peak partial R^2';
        stddevs = ones(length(ES_values));
    elseif strcmp(typo, 'tstat')
        nsubj = 50;
        ES_values = 0.1:0.1:0.7;
        x_ax_label = 'Peak Cohen''s d';
        stddevs = ones(length(ES_values));
    elseif strcmp(typo(1:4), 't4lm')
        nsubj = str2double(typo(5:end));
        typo = 't4lm';
        ES_values = 0.1:0.1:0.7;
        stddevs = round(0.5./ES_values*100);
        ES_values = 0.5*ones(1, length(ES_values)); %Need to change to 0.5 in the new simulations.
        x_ax_label = 'Peak Cohen''s d';
     elseif strcmp(typo, 'meanSD')
        nsubj = 50;
        ES_values = 0.1:0.1:0.7;
        stddevs = round(0.5./ES_values*100);
        stddevs_xaxis = 0.5./ES_values;
        ES_values = 1*ones(1, length(ES_values)); %Need to change to 0.5 in the new simulations.
        x_ax_label = 'Inverse Standard Deviation';
    else
        nsubj = 50;
    end
    nentries = length(ES_values);
    
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
                out = dispres_sims_thresh(typo, nsubj, FWHM, ES_values(I), stddevs(I));
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
        
        if strcmp(typo, 't4lm')
            ES_values = 0.1:0.1:0.7;
        elseif strcmp(typo, 'meanSD') 
            ES_values = 1./stddevs_xaxis;
        end
        
        bootsd = (bootrmse.^2 - bootbias.^2);
        naivesd = (naivermse.^2 - naivebias.^2);
        issd = (isrmse.^2 - isbias.^2);
        
        clf
        plot( ES_values, naivebias, 'linewidth', 2, 'Color', def_col('red'))
        hold on
        plot( ES_values, isbias, 'linewidth', 2,'Color', def_col('blue'))
        plot( ES_values, bootbias, 'linewidth', 2,'Color', def_col('yellow'))
        xlabel(x_ax_label)
        ylabel('Bias')
        xlim([ES_values(1),ES_values(end)])
        title('Bias vs peak effect size')
        if strcmp(typo, 't4lm')
            ylim([-0.1,1.5]);
        elseif strcmp(typo, 'meanSD')
            ylim([-0.1,2.2]);
            title('Bias vs 1/\sigma')
        end
        %             if groupsize == 20
        legend('Circular', 'Data-Splitting', 'Bootstrap' )
        %             end
        set(gca,'fontsize', 20)
        set(gcf, 'position', pos_vector)
        export_fig([SIbootstrap_loc,'ResultsFigures/VarSimsFigures/', typo,'_', num2str(nsubj), '_bias'], '-transparent')
        
        clf
        plot( ES_values, naivermse, 'linewidth', 2, 'Color', def_col('red'))
        hold on
        plot( ES_values, isrmse, 'linewidth', 2,'Color', def_col('blue'))
        plot( ES_values, bootrmse, 'linewidth', 2,'Color', def_col('yellow'))
        xlabel(x_ax_label)
        ylabel('RMSE')
        xlim([ES_values(1), ES_values(end)])
        ylim([0, max([naivermse, isrmse, bootrmse])])
        title(['RMSE vs peak effect size'])
        if strcmp(typo, 't4lm')
            ylim([0,2]);
        elseif strcmp(typo, 'meanSD')
            ylim([0,1]);
            title('RMSE vs 1/\sigma')
        end
%         legend('Circular', 'Data-Splitting', 'Bootstrap' )
        set(gca,'fontsize', 20)
        set(gcf, 'position', pos_vector)
        export_fig([SIbootstrap_loc,'ResultsFigures/VarSimsFigures/',typo,'_', num2str(nsubj),'_rmse'], '-transparent')
        
        clf
        plot( ES_values, naivesd, 'linewidth', 2, 'Color', def_col('red'))
        hold on
        plot( ES_values, issd, 'linewidth', 2, 'Color', def_col('blue'))
        plot( ES_values, bootsd, 'linewidth', 2,'Color', def_col('yellow'))
        xlabel(x_ax_label)
        ylabel('Standard Deviation')
        title('Standard Deviation vs peak effect size')
        if strcmp(typo, 't4lm')
            ylim([0,0.4]);
        elseif strcmp(typo, 'R2')
            ylim([0,max([naivesd, issd, bootsd])]);
        elseif strcmp(typo, 'meanSD')
            ylim([0,0.3]);
            title('Standard Deviation vs 1/\sigma')
        end
        
        xlim([ES_values(1),ES_values(end)])
        
%         legend('Circular', 'Data-Splitting', 'Bootstrap' )
        set(gca,'fontsize', 20)
        set(gcf, 'position', pos_vector)
        export_fig([SIbootstrap_loc,'ResultsFigures/VarSimsFigures/', typo,'_', num2str(nsubj),'_std'], '-transparent')
    end
end