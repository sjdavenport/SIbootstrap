function out = dispres_sims_thresh( type, groupsize, FWHM, ES, std_dev, printres )
% dispres_sims_thresh( type, groupsize, std_dev, FWHM, version, printres )
% displays a summary of the results obtained for a set of different possible options.
%--------------------------------------------------------------------------
% ARGUMENTS
% type      Specifies whether we're looking at a t or a mean stat. Options
%           are 'tstat' (Cohen's d at Cohen's d peaks), 't4lm' (mean at Cohen's d peaks)
%           'R2' (R2 at R2 peaks) and 'mean' (mean at mean peaks).
% groupsize the size of the groups of subjects to test.
% FWHM      the FWHM in voxels
% printres  0/1 whether to give a print out of the results. Default is to
%           do so.
%--------------------------------------------------------------------------
% OUTPUT
% out       the output which is a structure such that:
% out.mseboot, out.msenaive, out.mseis are the MSEs from applying the
% bootstrap, naive (circular) and independent splitting/data splitting methods.
% out.biasboot, out.biasnaive, out.biasis are the biases from applying the
% bootstrap, naive (circular) and independent splitting/data splitting methods.
%--------------------------------------------------------------------------
% EXAMPLES
%--------------------------------------------------------------------------
if nargin < 2
    groupsize = 50;
end
if nargin < 3
    FWHM = 3;
end
if nargin < 4
    ES = NaN;
    ESstr = '';
else 
    ES = 100*ES;
    ESstr = ['_ES',num2str(ES)];
end
if nargin < 5
    std_dev = 1;
end
if nargin < 6
    printres = 1;
end

global SIbootstrap_loc
if isempty(SIbootstrap_loc)
    error(['You need to set SIbootstrap_loc to be the location of the', ...
    ' SIbootstrap repository in the startup file and run it'])
end

if floor(FWHM) ~= FWHM
    FWHM = strcat(num2str(floor(FWHM)), 'point', num2str(5));
else
    FWHM = num2str(FWHM);
end

if strcmp(type, 'tstat')
    filestart = strcat('tstatThresh/B100sd',num2str(std_dev),'FWHM', FWHM, 'nsubj',num2str(groupsize),'SIMS');
elseif strcmp(type, 't4lm')
    filestart = strcat('t4lmThresh/B100sd',num2str(std_dev),'FWHM', FWHM, 'nsubj',num2str(groupsize),'SIMS');
elseif strcmp(type, 'mean')
    filestart = strcat('meanThresh/B100sd',num2str(std_dev),'FWHM', FWHM, 'nsubj',num2str(groupsize),'SIMSversion2');
elseif strcmp(type, 'meanSD')
    filestart = strcat('meanThresh/B100sd',num2str(std_dev),'FWHM', FWHM, 'nsubj',num2str(groupsize),'SIMS');
elseif strcmp(type, 'R2')
    filestart = strcat('R2Thresh/B100sd',num2str(std_dev),'FWHM', FWHM, 'nsubj',num2str(groupsize),'SIMS');
else
    error('This type is not stored')
end
filestart = [filestart, ESstr];

try
    tempo = load(strcat(SIbootstrap_loc,'/Simulations/', filestart));
    nct = 0;
    a = 1
catch
    error('Those variables stored or repo_loc is misspecified')
end
A = tempo.A;
B = tempo.B;

Jcurrent = A(:,1);
Jmax = Jcurrent(end);

nboots = 100;
if printres == 1
    if strcmp(type,'mean')
        fprintf('Results for the mean with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize,Jmax, nboots);
    elseif strcmp(type, 'tstat')
        fprintf('Results for Cohen''s d estimation at Cohen''s d peaks with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize, Jmax, nboots);
    elseif strcmp(type, 't4lm')
        fprintf('Results for mean estimation at Cohen''s d peaks with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize, Jmax, nboots);
    elseif strcmp(type, 'R2')
        fprintf('Results for R2 estimation at R2 peaks with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize, Jmax, nboots);
    end
end

boot = A(:,3);

if nct == 1
    naive = A(:,4)/nctcorrection(groupsize); %correcting for non-central t
    if isempty(B)
        is = NaN;
    else
        is = B(:,3)/nctcorrection(groupsize/2);
    end
else
    naive = A(:,4);
    is = B(:,3);
end

trueatloc = A(:,5);
if isempty(B)
    trueatlocis = NaN;
else
%     trueatlocis = sqrt(B(:,4));
    trueatlocis = B(:,4);
end

out.biasis = is - trueatlocis;
out.biasnaive = naive - trueatloc;
out.biasboot = boot - trueatloc;

out.mseboot = out.biasboot.^2;
out.msenaive = out.biasnaive.^2;
out.mseis = out.biasis.^2;

out.biasboot = out.biasboot(~isnan(out.biasboot));
out.biasnaive = out.biasnaive(~isnan(out.biasnaive));
out.biasis = out.biasis(~isnan(out.biasis));

out.mseboot = out.mseboot(~isnan(out.mseboot));
out.msenaive = out.msenaive(~isnan(out.msenaive));
out.mseis = out.mseis(~isnan(out.mseis));

if printres
    fprintf('The Average Bias and MSE averaged over all the significant peaks:\n')
    
    fprintf('Average Naive bias: %0.4f\n',mean(out.biasnaive))
    fprintf('Average Boot  bias: %0.4f\n',mean(out.biasboot))
    fprintf('Average Indep bias: %0.4f\n',mean(out.biasis))
    fprintf('Average Naive MSE: %0.4f\n',mean(out.msenaive))
    fprintf('Average Boot  MSE: %0.4f\n',mean(out.mseboot))
    fprintf('Average Indep MSE: %0.4f\n',mean(out.mseis))
end

end

