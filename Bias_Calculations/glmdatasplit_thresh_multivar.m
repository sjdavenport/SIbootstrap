function [ R2_est, true, top_lm_indices]  = glmdatasplit_thresh_multivar( X, data, true_R2, mask, contrast, threshold, use_inter )
% GLMINDEPSPLIT_THRESH_MULTIVAR( X, data, true_R2, mask, contrast, threshold, use_inter )
% calculates a 50:50 split of the data and uses the first half to find the 
% locations of the local maxima and the second half to find the values 
% observed there.
%--------------------------------------------------------------------------
% ARGUMENTS
% X         the design matrix.
% data      a 2d matrix that is the number of subjects by the number of
%           voxels.
% true_R2   a 3d array giving the true R2 at each voxel.
% mask      the mask over which to do the inference. Usually we take it to
%           be intersection of the subject masks. If this is not specified
%           the MNI mask of the brain is used.
% contrast  the contrast vector to use in the linear model
% threshold the threshold to use, RFT is implemented if this is omitted. 
% use_inter 0/1, specifes whether to use an intercept or not. Default = 1.
%--------------------------------------------------------------------------
% OUTPUT
% R2est         corrected R2 estimates at significant local maxima.
% true          true R2 values at significant local maxima.
% top_lm_indicies the indicies of the local maxima of the estimated R2
%               above the threshold
%--------------------------------------------------------------------------
% EXAMPLES - Note this requires the RFTtoolbox package.
% Mag = 0.5822*ones(1, 9);
% Rad = 10;
% Sig = gensig( Mag, Rad, 6, stdsize, {[45.5, 54.5, 45.5], [20,20,20], [71,20,20], [20,20,71], [20,89,20], [71,89,20], [71,20, 71], [20, 89, 71], [71, 89, 71]} );
% contrast = [0,1];
% true_f2 = Sig.^2;
% true_R2 = true_f2./(1+true_f2);
% true_R2 = true_R2(:)';
% B = 100;
% stdsize = [91,109,91];
% nsubj = 20;
% data = zeros(nsubj, prod(stdsize));
%
% noise = noisegen(stdsize, nsubj, FWHM, 3 );
% x = normrnd(0, 1, [1, nsubj])';
% for I = 1:nSubj
%     data(I, :) = 1 + Sig.*x(I) + noise(I,:);
% end
%
% [ R2_est, true, top_lm_indices]  = ...
%   glmindepsplit_thresh_multivar( x, data, true_R2, subject_mask, contrast, NaN, 1 )
%--------------------------------------------------------------------------
% PACKAGES REQUIRED
% RFTtoolbox
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 4
    mask = imgload('MNImask');
end
if nargin < 8
    use_inter = 1;
end

%Calculate the number of subjects
s = size(data);
nsubj = s(1);
nsubjover2 = floor(nsubj/2);

data_max = data(1:nsubjover2, :);

out = MVlm_multivar( X(1:nsubjover2, :), data_max, contrast);
est_std_residuals = out.std_residuals;
est_t = out.tstat;

Fstat = est_t.^2;
nvar = size(X,2);
if use_inter == 1
    nvar = nvar + 1;
end

if isnan(threshold)
    fwhm_est = est_smooth(reshape(est_std_residuals', [91,109,91, nsubjover2]));
    resel_vec = spm_resels_vol(mask, fwhm_est)';
    threshold = spm_uc( 0.05, [1,(nsubjover2 - nvar)], 'F', resel_vec, 1 );
end

mask_of_greater_than_threshold = Fstat > threshold;
mask_of_greater_than_threshold = reshape(mask_of_greater_than_threshold, [91,109,91]).*mask;
[top_lm_indices,top] = lmindices(Fstat,Inf, mask_of_greater_than_threshold);

if top == 0
    R2_est = NaN;
    true = NaN;
end

if top > 0 
    data_est = data((nsubjover2 + 1):nsubj,:);
    out2 = MVlm_multivar( X((nsubjover2 + 1):nsubj, :), data_est, contrast);
end

if top > 0
    R2_est = out2.R2(top_lm_indices);
    true_R2 = true_R2(:);
    true = true_R2(top_lm_indices);
end

end

