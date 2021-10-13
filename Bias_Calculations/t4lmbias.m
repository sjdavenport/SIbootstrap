function [ meanest, naiveest, trueval, top_lm_indices ] = t4lmbias( local, B, data, true_mean, mask, threshold, use_para) 
% T4LMBIAS( local, B, data, mask, threshold, true_mean ) takes in data and 
% estimates the bias in the mean at local maxima of the t statistic via 
% bootstrapping.
%--------------------------------------------------------------------------
% ARGUMENTS
% local     0/1. 1 means that the value at the maximum of the bootstrap is
%           compared to the value of the mean at that voxel. 0 means it is 
%           compared to the maximum of the mean. DEFAULT: 1
% B         the number of bootstrap iterations to do. DEFAULT: 1000.
% X         the design matrix.
% data      a 2d matrix that is the number of subjects by the number of
%           voxels.
% true_mean   a 3d array giving the true mean at each voxel.
% mask      the mask over which to do the inference. Usually we take it to
%           be intersection of the subject masks. If this is not specified
%           the mask is just taken to be 1 everywhere.
% threshold the threshold to use, RFT is implemented if this is omitted.
%--------------------------------------------------------------------------
% OUTPUT
% meanest       corrected mean estimates at significant local maxima of the
%               t-statistic.
% naiveest      circular mean estimates at significant local maxima of the
%               t-statistic.
% top_lm_indices the indices of the local maxima of the t-statistic.
%               above the threshold
% trueval       true mean values at significant local maxima of the 
%               t-statistic.
%--------------------------------------------------------------------------
% EXAMPLES - Note this requires the RFTtoolbox package.
% Mag = ones(1,9);
% Rad = 10;
% stdsize = [91,109,91];
% Sig = gensig( Mag, Rad, 6, stdsize, {[45.5, 54.5, 45.5], [20,20,20], [71,20,20], [20,20,71], [20,89,20], [71,89,20], [71,20, 71], [20, 89, 71], [71, 89, 71]} );
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
% [ est, circular_est, trueval, top_lm_indices ] = ...
%     t4lmbias(1, B, data, Sig, subject_mask);
% 
% subplot(1,2,1)
% plot(trueval, est, '*')
% hold on
% minax = min([trueval, est]); maxax = max([trueval, est]);
% plot([minax,maxax], [minax,maxax], '--')
% xlabel('True mean value'); ylabel('Estimated mean value')
% title('True vs Bootstrap corrected estimate')
% subplot(1,2,2)
% plot(trueval, circular_est, '*')
% hold on
% minax = min([trueval, circular_est]); maxax = max([trueval, circular_est]);
% plot([minax,maxax], [minax,maxax], '--')
% xlabel('True mean value'); ylabel('Estimated mean value')
% title('True vs Circular corrected estimate')
%--------------------------------------------------------------------------
% PACKAGES REQUIRED
% RFTtoolbox
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 1
    local = 1;
end
if nargin < 2
    B = 1000;
end
if nargin < 4
    true_mean = NaN;
end
if nargin < 6
    threshold = NaN;
end
if nargin < 7
    use_para = 0;
end


s = size(true_mean);
if s(1) ~= 1
    error('The true_mean vector must be a row vector')
end

[nSubj, nVox] = size(data);
if nargin < 5
    mask = ones(1, nVox);
end
[est_mean_vec, ~, est_CD_vec] = meanmos(data, 0);

if isnan(threshold)
    fwhm_est = est_smooth(reshape(data', [91,109,91, nSubj]));
    resel_vec = spm_resels_vol(mask, fwhm_est)';
    threshold = spm_uc( 0.05, [1,(nSubj-1)], 'T', resel_vec, 1 );
end

mask_of_greater_than_threshold = (sqrt(nSubj)*est_CD_vec > threshold);
mask_of_greater_than_threshold = reshape(mask_of_greater_than_threshold, [91,109,91]).*mask;

[~,top_lm_indices] = lmindices(est_CD_vec, 'all', mask_of_greater_than_threshold);
top = length(top_lm_indices);

if top == 0
    meanest = NaN;
    naiveest = NaN;
    trueval = NaN;
    return
end

bias = 0;
if use_para
    lm_bias_vec = zeros(1, B);
    parfor b = 1:B
        b
        sample_index = randsample(nSubj,nSubj,1);
        temp_data = data(sample_index, :);
        
        [mean_map, ~, CD_map] = calcCD(temp_data, 0);
        
        [~,lm_indices] = lmindices(CD_map, top, mask);
        if local == 1
            lm_bias_vec(b) = mean_map(lm_indices) - est_mean_vec(lm_indices);
        else
            lm_bias_vec(b) = mean_map(lm_indices) - est_mean_vec(top_lm_indices);
        end
    end
    bias = sum(lm_bias_vec);
else
    for b = 1:B
        b
        sample_index = randsample(nSubj,nSubj,1);
        temp_data = data(sample_index, :);
        
        [mean_map, ~, CD_map] = calcCD(temp_data, 0);
        
        lm_indices = lmindices(CD_map, top, mask);
        if local == 1
            bias = bias + mean_map(lm_indices) - est_mean_vec(lm_indices);
        else
            bias = bias + mean_map(lm_indices) - est_mean_vec(top_lm_indices);
        end
    end
end

bias = bias/B;
meanest = est_mean_vec(top_lm_indices) - bias;

naiveest = est_mean_vec(top_lm_indices);
if isnan(true_mean)
    trueval = NaN;
else
    trueval = true_mean(top_lm_indices);
end

end

