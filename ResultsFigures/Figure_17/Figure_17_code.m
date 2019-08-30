%% Code to generate Figure 16.
% export_fig is required in order to save the images. 

global def_col %Need to load startup.m for this to work.
global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) || isempty(def_col)
    error('SIbootstrap_loc and def_col must be defined by running startup.m')
end

save_loc = [SIbootstrap_loc, 'ResultsFigures/Figure_17/'];

%%
clf
pos_vector = [0,550,800,600];
set(0,'defaultAxesFontSize', 20);
set(gcf, 'position', pos_vector)

N = 1:80;
nvox = 228483; % The number of voxels in the 2mm MNImask;
alpha = 1-tcdf(5.10, 79); %alpha approx= 1.138*10^-6
cohensd = 1.519;
naive = powercalcT( N, cohensd, alpha );
correctedCD = 1.161;
corrected = powercalcT( N, correctedCD, alpha );

plot(N, naive*100, 'LineWidth', 2, 'Color', def_col('red'))
hold on
plot(N, corrected*100, 'LineWidth', 2, 'Color', def_col('yellow'))
xlabel('N: Number of Subjects')
ylabel('Corresponding Power (%)')
title('Power versus Sample Size')
legend('Circular', 'Bootstrap Corrected', 'Location', 'SouthEast')

export_fig([save_loc, 'Figure_17.pdf'], '-transparent')