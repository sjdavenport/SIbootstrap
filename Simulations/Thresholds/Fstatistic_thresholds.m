% Code to calculate the thresholds for the GLM simulations for the paper.
% This requires code from the RFTtoolbox.

niters = 5000;
FWHM = 3;

for df = 3:5:98 %This can of course be parallelized as it takes a bit of time to run.
    max_dist = simthresh( [1, df], FWHM, niters, 'F' ); %simthresh is code from the RFTtoolbox.
    threshold = prctile(max_dist, 100*(1-alpha));
end