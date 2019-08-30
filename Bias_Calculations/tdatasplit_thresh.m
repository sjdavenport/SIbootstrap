function [ CD_or_mean_est, true_CD_or_mean, top_lm_indices ] = tdatasplit_thresh( data, truth, mask, threshold, estimate_mean )
% TINDEPSPLIT_THRESH( data, true_mos, mask, threshold, estimate_mean )
% calculates a 50:50 split of the data and uses the first half to find the 
% locations of the local maxima of the t-statistic and the second half to 
% find the values of Cohen's d observed there. Everything here is done in terms of t-testing.
%--------------------------------------------------------------------------
% ARGUMENTS
% data      a 2d matrix that is the number of subjects by the number of
%           voxels.
% truth     a 3d array giving the true (mean or Cohen's d) at each voxel.
% mask      the mask over which to do the inference. Usually we take it to
%           be intersection of the subject masks. If this is not specified
%           the mask is just taken to be 1 everywhere.
% threshold the threshold to use, RFT is implemented if this is omitted. 
% estimate_mean 0/1. If 1 the function estimates the mean instead of
%           Cohen's d. Default is 0 which estimates Cohen's d.
%--------------------------------------------------------------------------
% OUTPUT
% CD_or_mean_est    the data-splitting estimate of Cohen's d or the mean
%                   (depending on whether estimate_mean = 0 or 1) calculated 
%                   using the second half of the data at significant local 
%                   maxima of the first half. 
% true_CD_or_mean   the true of Cohen's d or the mean at significant local
%                   maxima found using the first half of the data.
% top_lm_indices    
%--------------------------------------------------------------------------
% EXAMPLE
% Mag = [2,4,4];
% Rad = 10;
% Sig = gensig( Mag, Rad, 6, stdsize, {[20,30,20], [40,70,40], [40, 70,70]} );
%
% stdsize = [91,109,91];
% subject_mask = ones(stdsize);
% noise = noisegen(stdsize, nSubj, FWHM, 3 );
%  
% FWHM = 3; %FWHM in voxels.
% noise = noisegen(stdsize, nsubj, FWHM, 3 );
% for I = 1:nsubj
%     data(I, :) = Sig + noise(I,:);
% end
%
% threshold = 2;
% [ mean_est, true, top_lm_indices ] = tindepsplit_thresh( data, Sig, subject_mask, threshold)
%--------------------------------------------------------------------------
% PACKAGES REQUIRED
% RFTtoolbox
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport

if nargin < 4
     threshold = NaN;
end
if nargin < 5
    estimate_mean = 0;
end

%Calculate the number of subjects
[s, nVox] = size(data);
if nargin < 3
    mask = ones(1, nVox);
end
nsubj = s(1);
nsubjover2 = floor(nsubj/2);

%% First half of the data
data_max = data(1:nsubjover2, :);
[ ~, ~, max_CD ] = calcCD( data_max );

%% Thresholding
if isnan(threshold)
    fwhm_est = est_smooth(reshape(data_max', [91,109,91, nsubjover2]));
    resel_vec = spm_resels_vol(mask, fwhm_est)';
    threshold = spm_uc( 0.05, [1,(nsubjover2-1)], 'T', resel_vec, 1 );
end

mask_of_greater_than_threshold = sqrt(nsubjover2)*max_CD > threshold;
mask_of_greater_than_threshold = reshape(mask_of_greater_than_threshold, [91,109,91]).*mask;

%% Find top indices
[top_lm_indices, top] = lmindices(max_CD, Inf, mask_of_greater_than_threshold);
if top == 0
    CD_or_mean_est = NaN;
    true_CD_or_mean = NaN;
    return
end

%% Second half of the data
data_est = data((nsubjover2 + 1):nsubj,:);
[ est_mean, ~, est_CD ] = calcCD( data_est );

if estimate_mean 
    CD_or_mean_est = est_mean(top_lm_indices);
else
    CD_or_mean_est = est_CD(top_lm_indices);
end

truth = truth(:);
true_CD_or_mean = truth(top_lm_indices);

end

