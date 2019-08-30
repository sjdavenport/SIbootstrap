function [ mean_est, true, top_lm_indices ] = datasplit_thresh( data, true_mean, mask, threshold )
% DATASPLIT_THRESH( data, true_mean, mask, threshold) calculates a 50:50 
% split of the data and uses the first half to find the locations of the 
% local maxima of the mean and the second half to find the mean values 
% observed there. 
%--------------------------------------------------------------------------
% ARGUMENTS
% data      a 2d matrix that is the number of subjects by the number of
%           voxels.
% true_mean     a 3d array giving the true mean at each voxel.
% mask      the mask over which to do the inference. Usually we take it to
%           be intersection of the subject masks. If this is not specified
%           the mask is just taken to be 1 everywhere.
% threshold     the threshold to use.
%--------------------------------------------------------------------------
% OUTPUT
% 
%--------------------------------------------------------------------------
% EXAMPLE
% Mag = [2,4,4];
% Rad = 10;
% Sig = gensig( Mag, Rad, 6, stdsize, {[20,30,20], [40,70,40], [40, 70,70]} );
%
% stdsize = [91,109,91];
% subject_mask = ones(stdsize);
% FWHM = 3; %FWHM in voxels
% noise = noisegen(stdsize, nSubj, FWHM, 3 );
%
% for I = 1:nsubj
%     data(I, :) = Sig + noise(I,:);
% end
%
% threshold = 2;
% [ mean_est, true, top_lm_indices ] = datasplit_thresh( data, Sig, subject_mask, threshold)
%--------------------------------------------------------------------------
% PACKAGES REQUIRED
% RFTtoolbox
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 2
    true_mean = imgload('fullmean');
end
if nargin < 3
    mask = imgload('MNImask');
end

s = size(data);
nsubj = s(1);
nsubjover2 = floor(nsubj/2);

data_max = data(1:nsubjover2, :);

size(data_max);
max_mean_vec = mean(data_max);
mask_of_greater_than_threshold = max_mean_vec > threshold;
mask_of_greater_than_threshold = reshape(mask_of_greater_than_threshold, [91,109,91]).*mask;

[top_lm_indices, top] = lmindices(max_mean_vec, Inf, mask_of_greater_than_threshold);

if top == 0
    mean_est = NaN;
    true = NaN;
    return
end

data_est = data((nsubjover2 + 1):nsubj,:);
est_mean = mean( data_est );

mean_est = est_mean(top_lm_indices);
true_mean = true_mean(:);
true = true_mean(top_lm_indices);

end

