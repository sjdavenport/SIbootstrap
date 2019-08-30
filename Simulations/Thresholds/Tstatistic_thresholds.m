% Code to calculate the thresholds for the one-sample t statistic
% simulations for the paper. This requires code from the RFTtoolbox.

niters = 5000;
FWHM = 3;
alpha = 0.05;

for df = 4:5:99 %This can of course be parallelized as it takes a while to run.
    max_dist = simthresh( [1, df], FWHM, niters, 'T' ); %simthresh is code from the RFTtoolbox.
    threshold = prctile(max_dist, 100*(1-alpha));
end