function out = dispres_thresh(type, groupsize, printres, nct)
% DISPRES_THRESH(type, groupsize, printres, nct)
% records the thresholded results.
%--------------------------------------------------------------------------
% ARGUMENTS
% type          'mean', 'tstat', 't4lm' or 'vbmagesex'
% groupsize     the number of subjects in each small group
% printres      0/1 whether to print the results. Default is 1.
% nct           0/1 noncentral t correction. 1 corrects for the mean of a
%               noncentral t distribution. Deafult it 1. (Only applicable
%               to the 'tstat' case.
%--------------------------------------------------------------------------
% OUTPUT
% out           a structural array with vectors containing the bias and mse
%               for each of the methods: is, naive, boot. Eg out.biasis and
%               out.MSEis are the bias and MSE for Data-Splitting.
%--------------------------------------------------------------------------
% EXAMPLES
% dispres_thresh('mean', 20)
% dispres_thresh('tstat', 20)
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.

global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc)
    error('SIbootstrap_loc must be defined by running startup.m')
end

if nargin < 1
    type = 'tstat';
end
if nargin < 2
    groupsize = 20;
end
if nargin < 3
    printres = 1;
end

if strcmp(type, 't') || strcmp(type, 'tstat') 
    if nargin < 5
        nct = 1;
    end
else
    nct = 0;
end

if strcmp(type, 'vbmagesex')
    masktype = 'vbm_mask001';
    filending = [SIbootstrap_loc, 'Results/', type, 'B100nsubj',num2str(groupsize),'Thresh',masktype,'.mat'];
else
    filending = [SIbootstrap_loc,  'Results/', type, 'B100nsubj',num2str(groupsize),'Thresh.mat'];
end

try
    temp = load(filending);
catch
    error('You don''t have that set of variables stored.')
end

A = temp.A;
B = temp.B;
try
    C = temp.C;
    D = temp.D;
end

Jcurrent = A(:,1);
Jmax = Jcurrent(end);

nboot = 100;
if printres
    if strcmp(type, 'm') || strcmp(type,'mean')
        fprintf('Results for the mean with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize,Jmax, nboot);
    elseif strcmp(type, 't') || strcmp(type, 'tstat')
        fprintf('Results for the t-stat with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize, Jmax, nboot);
    elseif strcmp(type, 't4lm')
        fprintf('Results for t4lm with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize, Jmax, nboot);
    elseif strcmp(type, 'vbmagesex')
        fprintf('Results for vbmagesex with nSubj = %d, Jmax = %d and B = %d.\n\n',groupsize, Jmax, nboot);
    end
end

if strcmp(type, 'vbmagesex')
    boot = A(:,3);
    naive = A(:,5);
    is = B(:,3);
    trueatloc = A(:,9);
    trueatlocis = B(:,5);
elseif strcmp(type, 'mean') || strcmp(type, 't4lm')
    boot = A(:,3)/100;
    naive = A(:,4)/100;
    is = B(:,3)/100;
    trueatloc = A(:,5)/100;
    trueatlocis = B(:,4)/100;
else
    if nct == 1
        boot = A(:,3)/nctcorrection(groupsize);
        naive = A(:,4)/nctcorrection(groupsize); %correcting for non-central t
        is = B(:,3)/nctcorrection(groupsize/2);
    else
        boot = A(:,3);
        naive = A(:,4);
        is = B(:,3);
    end
    trueatloc = A(:,5);
    trueatlocis = B(:,4);
end


out.biasboot = boot(~isnan(boot)) - trueatloc(~isnan(boot));
out.MSEboot = out.biasboot.^2;

out.biasnaive = naive(~isnan(boot)) - trueatloc(~isnan(boot));
out.MSEnaive = out.biasnaive.^2;

out.biasis = is(~isnan(is)) - trueatlocis(~isnan(is));
out.MSEis = out.biasis.^2;

if printres
    fprintf('The Average Bias and MSE averaged over all the significant peaks:\n')
    
    fprintf('Average Naive bias: %0.4f\n',mean(out.biasnaive))
    fprintf('Average Boot  bias: %0.4f\n',mean(out.biasboot))
    fprintf('Average Indep bias: %0.4f\n',mean(out.biasis))
    fprintf('Average Naive MSE: %0.4f\n',mean(out.MSEnaive))
    fprintf('Average Boot  MSE: %0.4f\n',mean(out.MSEboot))
    fprintf('Average Indep MSE: %0.4f\n',mean(out.MSEis))
end

end

