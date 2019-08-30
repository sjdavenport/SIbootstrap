%% Code to generate Figures S7, S8.

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

save_loc = [SIbootstrap_loc, 'ResultsFigures/Top20/'];

%%
axis_font_size = 25;
set(0,'defaultAxesFontSize', axis_font_size);

% corresponding_figure = 'S3';
pos_vector = [0,550,1200,1000];
npeaks = 15;
rmse_plots = zeros(4,npeaks);
std_plots = zeros(4,npeaks);
bias_plots = zeros(4,npeaks);
% nsubj = 100;

for types = {'tstat', 't4lm', 'R2'}
    % for types = {'mean'}
    type = types{1};
    if strcmp(type, 'R2')
        nsubj_vec = [100,150];
        boot_index = 3;
        naive_index = 5;
        true_index = 9;
        rsme_ylimit = [0,0.25];
    else
        nsubj_vec = [50,100];
        boot_index = 3;
        naive_index = 4;
        true_index = 5;
    end
    
    if strcmp(type, 'tstat')
        rsme_ylimit = [0,0.6];
    elseif strcmp(type, 't4lm')
        rsme_ylimit = [0,0.13];
    end
    
    filename = [save_loc, type];
    
    for I = 0:(length(nsubj_vec)-1)
        nsubj = nsubj_vec(I+1);
        if strcmp(type, 'R2')
            masktype = 'vbm_mask001';
            filending = [SIbootstrap_loc, 'Results/vbmagesexB100nsubj',num2str(nsubj),'Thresh',masktype,'.mat'];
        else
            filending = [SIbootstrap_loc,  'Results/', type, 'B100nsubj',num2str(nsubj),'Thresh.mat'];
        end
        
        temp = load(filending);
        A = temp.A;
        
        if strcmp(type, 'mean') || strcmp(type, 't4lm')
            A(:,[boot_index,naive_index,true_index]) = A(:,[boot_index,naive_index,true_index])/100;
        end
        
        bootbiasdiff = A(:,boot_index) - A(:,true_index);
        bootmsediff = bootbiasdiff.^2;
        
        naivebiasdiff = A(:,naive_index) - A(:,true_index);
        naivemsediff = naivebiasdiff.^2;
        
        for peakno = 1:npeaks
            peakloc = (A(:,2) == peakno);
            bootbiaspeak = bootbiasdiff(peakloc);
            bootmsepeak = bootmsediff(peakloc);
            bias_plots(1+2*I,peakno) = mean(bootbiaspeak(~isnan(bootbiaspeak)));
            rmse_plots(1+2*I, peakno) = sqrt(mean(bootmsepeak(~isnan(bootbiaspeak))));
            std_plots(1+2*I, peakno) = sqrt(rmse_plots(1+2*I, peakno)^2 - bias_plots(1+2*I,peakno)^2);
            
            naivebiaspeak = naivebiasdiff(peakloc);
            naivemsepeak = naivemsediff(peakloc);
            bias_plots(2+2*I,peakno) = mean(naivebiaspeak(~isnan(bootbiaspeak)));
            rmse_plots(2+2*I, peakno) = sqrt(mean(naivemsepeak(~isnan(bootbiaspeak))));
            std_plots(2+2*I, peakno) = sqrt(rmse_plots(2+2*I, peakno)^2 - bias_plots(2+2*I,peakno)^2);
        end
        
        
    end
    if strcmp(type, 'tstat')
        yaxis_units = 'Cohen''s d';
        title_beg = 'One Sample Cohen''s d';
    elseif strcmp(type, 'R2')
        yaxis_units = 'partial R^2';
        title_beg = 'R^2';
    elseif strcmp(type, 't4lm') || strcmp(type, 'mean')
        yaxis_units = '% BOLD';
        title_beg = 'One Sample Mean';
    end
    
    h = plot(1:npeaks, bias_plots, 'Linewidth', 4);
    set(h, {'color'}, {def_col('yellow'); def_col('red'); def_col('yellow'); def_col('red')});
    set(h, {'LineStyle'}, {':'; ':';'-';'-'});
    if strcmp(type, 'tstat')
        legend('Bootstrap: N = 50', 'Circular: N = 50', 'Bootstrap: N = 100', 'Circular: N = 100')
    elseif strcmp(type, 'R2')
        legend('Bootstrap: N = 100', 'Circular: N = 100', 'Bootstrap: N = 150', 'Circular: N = 150')
    end
    xlim([1,npeaks])
    xticks(1:npeaks)
%     title(['Bias versus peak rank for N=',num2str(nsubj_vec(1)),' and ',num2str(nsubj_vec(2))])
    title([title_beg, ' bias versus peak rank'])
    xlabel('n (the index of the peak rank)')
    ylabel(['Bias_n in ', yaxis_units]);
    set(gcf, 'position', pos_vector)
    export_fig([filename,'_top_bias'], '-transparent')
    
%     h = plot(1:npeaks, std_plots, 'Linewidth', 4);
%     set(h, {'color'}, {def_col('yellow'); def_col('red'); def_col('yellow'); def_col('red')});
%     set(h, {'LineStyle'}, {':'; ':';'-';'-'});
%     xlim([1,npeaks])
%     xticks(1:npeaks)
%     title(['Std versus peak rank for N=',num2str(nsubj_vec(1)),' and ',num2str(nsubj_vec(2))])
%     xlabel('nth largest peak')
%     ylabel(['Std in ', yaxis_units]);
%     set(gcf, 'position', pos_vector)
%     export_fig([filename,'_top_std'], '-transparent')
    
    h = plot(1:npeaks, rmse_plots, 'Linewidth', 4);
    set(h, {'color'}, {def_col('yellow'); def_col('red'); def_col('yellow'); def_col('red')});
    set(h, {'LineStyle'}, {':'; ':';'-';'-'});
    xlim([1,npeaks])
    ylim(rsme_ylimit)
    xticks(1:npeaks)
%     title(['RMSE versus peak rank for N=',num2str(nsubj_vec(1)),' and ',num2str(nsubj_vec(2))])
    title([title_beg, ' RMSE versus peak rank'])
    xlabel('n (the index of the peak rank)')
    ylabel(['RMSE_n in ', yaxis_units]);
    set(gcf, 'position', pos_vector)
    export_fig([filename,'_top_rmse'], '-transparent')
end

% for types = {'tstat', 't4lm', 'mean', 'R2'}
% % for types = {'mean'}
%     type = types{1};
%     if strcmp(type, 'R2')
%         nsubj_vec = [100,150];
%         boot_index = 3;
%         naive_index = 5;
%         true_index = 9;
%     else
%         nsubj_vec = [20,50,100];
%         boot_index = 3;
%         naive_index = 4;
%         true_index = 5;
%     end
%
%     for nsubj = nsubj_vec
%         if strcmp(type, 'R2')
%             masktype = 'vbm_mask001';
%             filending = [SIbootstrap_loc, 'Results/vbmagesexB100nsubj',num2str(nsubj),'Thresh',masktype,'.mat'];
%             if nsubj == 100
%                 ledge = 1;
%             else
%                 ledge = 0;
%             end
%         else
%             filending = [SIbootstrap_loc,  'Results/', type, 'B100nsubj',num2str(nsubj),'Thresh.mat'];
%             if nsubj == 50
%                 ledge = 1;
%             else
%                 ledge = 0;
%             end
%         end
%
%         temp = load(filending);
%         A = temp.A;
%
%         if strcmp(type, 'mean') || strcmp(type, 't4lm')
%             A(:,[boot_index,naive_index,true_index]) = A(:,[boot_index,naive_index,true_index])/100;
%         end
%
%         bootbiasdiff = A(:,boot_index) - A(:,true_index);
%         bootmsediff = bootbiasdiff.^2;
%
%         naivebiasdiff = A(:,naive_index) - A(:,true_index);
%         naivemsediff = naivebiasdiff.^2;
%
%         for peakno = 1:npeaks
%             peakloc = (A(:,2) == peakno);
%             bootbiaspeak = bootbiasdiff(peakloc);
%             bootmsepeak = bootmsediff(peakloc);
%             bias_plots(1,peakno) = mean(bootbiaspeak(~isnan(bootbiaspeak)));
%             rmse_plots(1, peakno) = sqrt(mean(bootmsepeak(~isnan(bootbiaspeak))));
%             std_plots(1, peakno) = sqrt(rmse_plots(1, peakno)^2 - bias_plots(1,peakno)^2);
%
%             naivebiaspeak = naivebiasdiff(peakloc);
%             naivemsepeak = naivemsediff(peakloc);
%             bias_plots(2,peakno) = mean(naivebiaspeak(~isnan(bootbiaspeak)));
%             rmse_plots(2, peakno) = sqrt(mean(naivemsepeak(~isnan(bootbiaspeak))));
%             std_plots(2, peakno) = sqrt(rmse_plots(2, peakno)^2 - bias_plots(2,peakno)^2);
%         end
%
%         if strcmp(type, 'tstat')
%             yaxis_units = 'Cohens'' d';
%         elseif strcmp(type, 'vbmagesex')
%             yaxis_units = 'R^2';
%         elseif strcmp(type, 't4lm') || strcmp(type, 'mean')
%             yaxis_units = '% BOLD';
%         end
%
%         filename = [save_loc, type, '_nsubj', num2str(nsubj)];
%
%         h = plot(1:npeaks, bias_plots);
%         set(h, {'color'}, {def_col('yellow'); def_col('red')});
%         if ledge == 1
%             legend('Bootstrap', 'Circular')
%         end
%         xlim([1,npeaks])
%         xticks(1:npeaks)
%         title(['Bias versus peak rank for N=',num2str(nsubj)])
%         xlabel('nth largest peak')
%         ylabel(['Bias in ', yaxis_units]);
%         set(gcf, 'position', pos_vector)
%         export_fig([filename,'_bias'], '-transparent')
%
%         h = plot(1:npeaks, std_plots);
%         set(h, {'color'}, {def_col('yellow'); def_col('red')});
%         xlim([1,npeaks])
%         xticks(1:npeaks)
%         title(['Std versus peak rank for N=',num2str(nsubj)])
%         xlabel('nth largest peak')
%         ylabel(['Std in ', yaxis_units]);
%         set(gcf, 'position', pos_vector)
%         export_fig([filename,'_std'], '-transparent')
%
%         h = plot(1:npeaks, rmse_plots);
%         set(h, {'color'}, {def_col('yellow'); def_col('red')});
%         xlim([1,npeaks])
%         xticks(1:npeaks)
%         title(['RMSE versus peak rank for N=',num2str(nsubj)])
%         xlabel('nth largest peak')
%         ylabel(['RMSE in ', yaxis_units]);
%         set(gcf, 'position', pos_vector)
%         export_fig([filename,'_rmse'], '-transparent')
%     end
% end