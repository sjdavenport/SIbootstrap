function [ R2est, naiveest, top_lm_indices, trueval] = glmbias_thresh_multivar( local, B, X, data, true_R2, mask, contrast, threshold, use_inter, use_para)
% GLMBIAS_THRESH_MULTIVAR( local, B, X, data, true_R2, mask, contrast, threshold, use_inter)
% takes in glm data and returns bootstrap corrected esimates of the partial R^2.
%--------------------------------------------------------------------------
% ARGUMENTS
% local     0/1. 1 means that the value at the maximum of the bootstrap is
%           compared to the value of the mean at that voxel. 0 means it is 
%           compared to the maximum of the mean. DEFAULT: 1.
% B         the number of bootstrap iterations to do. DEFAULT: 1000.
% X         the design matrix.
% data      a 2d matrix that is the number of subjects by the number of
%           voxels.
% true_R2   a 3d array giving the true R2 at each voxel.
% mask      the mask over which to do the inference. Usually we take it to
%           be intersection of the subject masks. If this is not specified
%           the mask is just taken to be 1 everywhere.
% contrast  the contrast vector to use in the linear model
% threshold the threshold to use, RFT is implemented if tthreshold is 
%           omitted or set to NaN.
% use_inter 0/1, specifes whether to use an intercept or not. Default = 1.
% use_para  0/1, specifies whether to parallelize the bootstrap part.
%           Default is 0 ie not to.
%--------------------------------------------------------------------------
% OUTPUT
% R2est         corrected R2 estimates at significant local maxima.
% naiveest      circular R2 estimates at significant local maxima.
% top_lm_indices the indices of the local maxima of the estimated R2
%               above the threshold
% trueval       true R2 values at significant local maxima.
%--------------------------------------------------------------------------
% EXAMPLE - Note this requires the RFTtoolbox package.
% Mag = 0.5822*ones(1, 9);
% Rad = 10;
% stdsize = [91,109,91];
% Sig = gensig( Mag, Rad, 6, stdsize, {[45.5, 54.5, 45.5], [20,20,20], [71,20,20], [20,20,71], [20,89,20], [71,89,20], [71,20, 71], [20, 89, 71], [71, 89, 71]} );
% contrast = [0,1];
% Sig = Sig(:)';
% true_f2 = Sig.^2;
% true_R2 = true_f2./(1+true_f2);
% B = 100;
% nsubj = 50;
% data = zeros(nsubj, prod(stdsize));
% subject_mask = ones(stdsize);
% FWHM = 3; %FWHM in voxels.
% 
% noise = noisegen(stdsize, nsubj, FWHM, 3 );
% x = normrnd(0, 1, [1, nsubj])';
% for I = 1:nsubj
%     I
%     data(I, :) = 1 + Sig.*x(I) + noise(I,:);
% end
% 
% [ est, estwas, top_lm_indices, trueval] = ...
%   glmbias_thresh_multivar( 1, B, x, data, true_R2, subject_mask, contrast, NaN, 1);
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
if nargin < 8
    threshold =  NaN;
end
if nargin < 9
    use_inter = 1;
end
if nargin < 10
    use_para = 0;
end

s = size(true_R2);
nvar = size(X,2);
if use_inter == 1
    nvar = nvar + 1;
end
if s(1) ~= 1
    error('The true_mean vector must be a row vector')
end

[nSubj, nVox] = size(data);
if nargin < 5
    mask = ones(1, nVox);
end
out = MVlm_multivar( X, data, contrast, use_inter );
est_std_residuals = out.std_residuals;
est_fitted = out.fitted;
est_R2 = out.R2;
est_t = out.tstat;
evalin( 'base', 'clear data' ) %Gets rid of data because it can take up a lot of space!

Fstat = est_t.^2;
    
if isnan(threshold)
    %Use RFT to set the threshold if one hasn't been provided.
    fwhm_est = est_smooth(reshape(est_std_residuals', [91,109,91, nSubj]));
    resel_vec = spm_resels_vol(mask, fwhm_est)';
    
    threshold = spm_uc( 0.05, [1,(nSubj-nvar)], 'F', resel_vec, 1 );
end

mask_of_greater_than_threshold = Fstat > threshold;
mask_of_greater_than_threshold = reshape(mask_of_greater_than_threshold, [91,109,91]).*mask;

[top_lm_indices, top] = lmindices(Fstat, Inf, mask_of_greater_than_threshold);

if top == 0
    R2est = NaN;
    naiveest = NaN;
    trueval = NaN;
    return
end

R2_bias = 0;

if use_para
    R2_bias_vec = zeros(1, B);
    parfor b = 1:B
        sample_index = randsample(nSubj,nSubj,1);
        boot_residuals = est_std_residuals(sample_index, :);
        boot_data = est_fitted + boot_residuals;
        out = MVlm_multivar( X, boot_data, contrast, use_inter );
        boot_R2 = out.R2;
        lm_indices = lmindices(boot_R2, top, mask);
        
        if local == 1
            R2_bias_vec(b) =  boot_R2(lm_indices) - est_R2(lm_indices);
        else
            R2_bias_vec(b) = boot_R2(lm_indices) - est_R2(top_lm_indices);
        end
    end
    R2_bias = sum(R2_bias_vec);
else
    for b = 1:B
        b
        sample_index = randsample(nSubj,nSubj,1);
        boot_residuals = est_std_residuals(sample_index, :);
        boot_data = est_fitted + boot_residuals;
        out = MVlm_multivar( X, boot_data, contrast, use_inter );
        boot_R2 = out.R2;
        lm_indices = lmindices(boot_R2, top, mask);
        
        if local == 1
            R2_bias = R2_bias + boot_R2(lm_indices) - est_R2(lm_indices);
        else
            R2_bias = R2_bias + boot_R2(lm_indices) - est_R2(top_lm_indices);
        end
    end
end

R2_bias = R2_bias/B;
R2est = est_R2(top_lm_indices) - R2_bias;
naiveest = est_R2(top_lm_indices);

if isnan(true_R2)
    trueval = NaN;
else 
    trueval = true_R2(top_lm_indices);
end

end

