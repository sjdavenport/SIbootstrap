function [ xbar, std_dev, CD, tstat ] = calcCD( data, threeD, setnanaszero)
% calcCD( data, threeD, setnanaszero) calculates the mean, standard
% deviation, Cohen's d and t-statistic.
%--------------------------------------------------------------------------
% ARGUMENTS
% data          An nsubj by nvox matrix with the data. Can also take in an 
%               nsubj by Dim matrix with the data but not fixed the output
%               for this yet, the output is then [1, 91, 109, 91] not
%               [91,109,91].
% threeD        0/1. Whether to return a 3D image or not.
% setnanaszero  0/1. Whether to treats NaNs as zeros or not.
%--------------------------------------------------------------------------
% OUTPUT
% xbar          The mean over subjects at each voxel.
% std           The estimate of the standard deviation at each voxel.
% CD            xbar/std.
% tstat         sqrt(nsubj)*CD: the t-statistic at each voxel.
%--------------------------------------------------------------------------
% EXAMPLES
% noise = noisegen([91,109,91], 20, 6, 1);
% [xbar, std, ~, tstat] = calcCD(noise);
% size(xbar)
%
% nsubj = 20;
% noise = noisegen([91,109,91], nsubj, 6, 3);
% [xbar, std_dev, ~, tstat] = meanmos(noise);
% vox = 150;
% noise_at_vox = noise(:, vox);
% mu = mean(noise_at_vox)
% sigmatilde = std(noise_at_vox)
% sqrt(nsubj)*mu/sigmatilde
% tstat(vox)
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 3
    threeD = 0;
end
if nargin < 4
   setnanaszero = 1;
end
sD = size(data);
nSubj = sD(1);

% if sD(end) > sD(1)
%     warning('remember for now meanmos requires that the first corrordinate is nSubj')
% end

xbar = mean(data);
sq_xbar = mean(data.^2);
    
est_var = (nSubj/(nSubj-1))*(sq_xbar - (xbar.^2));

std_dev = sqrt(est_var);
CD = xbar./std_dev;

if threeD
    global stdsize
    CD = reshape(CD, stdsize);    
    xbar = reshape(xbar, stdsize);
    std_dev = reshape(std_dev, stdsize);
end

if setnanaszero
    CD(isnan(CD))=0;
end

tstat = CD*sqrt(nSubj);

end

