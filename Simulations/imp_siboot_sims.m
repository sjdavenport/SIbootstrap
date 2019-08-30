function imp_siboot_sims( nsubj, type, effectsize, sim_tot, B )
% IMP_SIBOOT_SIMS( nsubj, type, effectsizescale ) implements the
% simulations for the SIbootstrap paper.
%--------------------------------------------------------------------------
% ARGUMENTS
% nsubj             the number of subjects
% type              the type either T, R2, t4lm or mean
% effectsize        the effectsize of the maxima
% sim_tot           the total number of iterations
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 4
    sim_tot = 1000;
end
if nargin < 5
    B = 100;
end
std_dev = 1;
FWHM = 3;

if  strcmp(type, 'mean') || strcmp(type, 'mean2')
%     [effectsizescale, ~] = matchsimspowerCD2R2( effectsize, nsubj );
    std_dev = 0.5/effectsize;
    effectsize = 1;
elseif strcmp(type, 't4lm')
    std_dev = 0.5/effectsize;
    effectsize = 0.5;
end
%We'll take CD = 0.1:0.1:0.6;

for Jmax = 1:sim_tot
    calcests_sims_thresh(type, nsubj, Jmax, FWHM, std_dev, B, effectsize)
end

end

