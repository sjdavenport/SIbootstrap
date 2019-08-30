function [ nvox, avnvox ] = nvoxabovethresh( nsubj, version, nsims )
% nvoxabovethresh( type, nsubj ) runs the simulations to calculate the
% number of voxels that lie above a given threshold.
%--------------------------------------------------------------------------
% ARGUMENTS
% nsubj     the number of subjects
% version   if = 'sims' then runs the simulations else runs the real data.
% nsims     the number of simulations
%--------------------------------------------------------------------------
% OUTPUT
% nvox      the number of voxels above the 0.05 voxelwise threshold across
%           all simulations
% avnvox    the average number of voxels above the 0.05 voxelwise threshold 
%           across all simulations
%--------------------------------------------------------------------------
% EXAMPLES
% nsubj = 10; version = 'normal'; nsims = 1;
% nvoxabovethresh( nsubj, version, nsims )
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 2
    version = 'Sims';
end
if nargin < 3
    nsims = 1000;
end
FWHM = 3;
stdsize = [91,109,91];

global SIloc
global server_dir
if strcmp(version, 'Sims') || strcmp(version, 'sims')
    Mag = repmat(0.5, 1, 9); %Main simulation setting
    Rad = 10;
    Sig = gensig( Mag, Rad, 6, stdsize, {[45.5, 54.5, 45.5], [20,20,20], [71,20,20], [20,20,71], [20,89,20], [71,89,20], [71,20, 71], [20, 89, 71], [71, 89, 71]} );
    % end
    Sig = Sig(:)';
    
    server_addon = [server_dir, 'SIbootstrap/Simulations/'];
    
    load([server_addon,'Thresholds/store_thresh_nsubj.mat'])
    store_thresh_mate = tstat_thresholds(nsubj-1);
    threshold = store_thresh_mate(1,2); %(1,2) is the index corresponding to FWHM = 3.
    std_dev = 1;
    saveloc = [SIloc,'Simulations/Power/nvoxstore/',num2str(nsubj)];
else
    saveloc = [SIloc,'Results/PowerResults/',num2str(nsubj)];
%     saveloc = [SIloc,'Results/PowerResults/',version,'_',num2str(nsubj)]; %add version into this string!! :)
    nsims = floor(4940/nsubj);
%     nsims = 1;
    mask = imgload('MNImask');
end

nvox = 0;
sim = 0;
save(saveloc, 'nvox', 'sim')

for sim = 1:nsims
    sim
    loadin = load(saveloc, 'nvox');
    nvox = loadin.nvox;
    if strcmp(version, 'Sims') || strcmp(version, 'sims')
        noise = noisegen(stdsize, nsubj, FWHM, 3 );
        data = zeros([nsubj, stdsize]);
        for I = 1:nsubj
            data(I, :) = Sig + std_dev*noise(I,:);
        end
    else
        data = loadsubs((sim-1)*nsubj+1:sim*nsubj, 'copes', 1, 0);
        fwhm_est = est_smooth(reshape(data', [91,109,91, nsubj]));
        resel_vec = spm_resels_vol(mask, fwhm_est)';
        threshold = spm_uc( 0.05, [1,(nsubj-1)], 'T', resel_vec, 1 );
    end
    
    onesamplet = mvtstat(data);
    abovethresh = (onesamplet > threshold);
    nvox = nvox + sum(abovethresh(:));
    save(saveloc, 'nvox', 'sim')
end

avnvox = nvox/nsims;

save(saveloc, 'nvox', 'avnvox', 'sim')

end

