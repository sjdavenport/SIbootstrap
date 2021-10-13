function [ meanest, naiveest, trueval, top_lm_indices ] = lmbias_thresh( local, B, data, true_mean, mask, threshold )
% LMBIAS takes in data and estimates the bias at the locations of local 
% maxima of the mean via bootstrapping.
%--------------------------------------------------------------------------
% ARGUMENTS
% local     0/1. 1 means that the value at the maximum of the bootstrap is
%           compared to the value of the mean at that voxel. 0 means it is 
%           compared to the maximum of the mean. DEFAULT: 1
% top       a number less than the total number of voxels in each image
%           that denotes the number of top values to consider. Eg top = 1,
%           means that the bias is just calculated for the maximum. top = 2
%           means that the bias is calculated for the top two values etc.
%           DEFAULT: 20
% B         the number of bootstrap iterations to do. DEFAULT: 50
% data      a 2d matrix that is the number of subjects by the number of
%           voxels.
% true_mean a 3d array giving the true signal at each voxel.
% mask      the mask over which to do the inference. Usually we take it to
%           be intersection of the subject masks. If this is not specified
%           the MNI mask of the brain is used.
%--------------------------------------------------------------------------
% OUTPUT
% meanest       a 1xtop vector of the estimates of the mean for the top top
%               values.
% naiveest      the estimate of the mean using the naive method which
%               doesn't correct for the bias.
% trueatlocs    the true values at the locations of the local maxima of the
%               estimated mean.
% top_lm_indicies the indicies of the local maxima of the estimated mean.
%--------------------------------------------------------------------------
% EXAMPLES - Note this requires the RFTtoolbox package.
% Mag = [2,4,4];
% Rad = 10;
% stdsize = [91,109,91];
% Sig = gensig( Mag, Rad, 6, stdsize, {[20,30,20], [40,70,40], [40, 70,70]} );
% Sig = Sig(:)';
% B = 100;
% nsubj = 100;
% data = zeros(nsubj, prod(stdsize));
% subject_mask = ones(stdsize);
% 
% FWHM = 3; %FWHM in voxels.
% noise = noisegen(stdsize, nsubj, FWHM, 3 );
% for I = 1:nsubj
%     data(I, :) = Sig + noise(I,:);
% end
% 
% threshold = 2;
% [est, naiveest, trueval, top_lm_indices ] = ...
%     lmbias_thresh(1, B, data, Sig, subject_mask, threshold); 
%--------------------------------------------------------------------------
% PACKAGES REQUIRED
% RFTtoolbox
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 1
    local = 1;
end
if nargin < 2
    B = 100;
end
if nargin < 4
    true_mean = imgload('fullmean');
    true_mean = true_mean(:)';
end
if nargin < 5
    mask = imgload('MNImask');
end

s = size(true_mean);
if s(1) ~= 1
    error('The true_mean vector must be a row vector')
end

[nSubj, ~] = size(data);

est_mean_vec = mean(data, 1);
mask_of_greater_than_threshold = est_mean_vec > threshold;

mask_of_greater_than_threshold = reshape(mask_of_greater_than_threshold, [91,109,91]).*mask;
[~,top_lm_indices] = lmindices(est_mean_vec, 'all', mask_of_greater_than_threshold);
top = length(top_lm_indices);

if top == 0
    meanest = NaN;
    naiveest = NaN;
    trueval = NaN;
    return
end

bias = 0;
for b = 1:B
    b
    sample_index = randsample(nSubj,nSubj,1);
    temp_data = data(sample_index, :);
    mean_map = mean(temp_data,1);
    
    [~,lm_indices] = lmindices(mean_map, top, mask);
    if local == 1
        bias = bias + mean_map(lm_indices) - est_mean_vec(lm_indices);
    else
        bias = bias + mean_map(lm_indices) - est_mean_vec(top_lm_indices);
    end
end

bias = bias/B;
meanest = est_mean_vec(top_lm_indices) - bias;

naiveest = est_mean_vec(top_lm_indices);
trueval = true_mean(top_lm_indices);

end

