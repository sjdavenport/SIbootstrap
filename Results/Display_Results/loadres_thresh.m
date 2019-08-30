function [bootnaive_ests, is_ests] = loadres_thresh(type, groupsize)
% LOADRES_THRES(type, groupsize, B) loads in the data corresponding to the
% thresholded estimates.
%--------------------------------------------------------------------------
% ARGUMENTS
% type      'mean', 'tstat', 't4lm' or 'vbmagesex'
% groupsize the size of the groups of subjects to test.
%--------------------------------------------------------------------------
% OUTPUT
% A summary of the data.
%--------------------------------------------------------------------------
% EXAMPLES
% M = loadres('tstat',20)
%--------------------------------------------------------------------------
if nargin < 1
    type = 'tstat';
end
if nargin < 2
   	groupsize = 20;
end

global SIbootstrap_loc %Needs to be set via startup.m
if isempty(SIbootstrap_loc) 
    error('SIbootstrap_loc must be defined by running startup.m')
end


if strcmp(type, 'vbmagesex')
    masktype = 'vbm_mask001';
    filending = [SIbootstrap_loc, 'Results/', type, 'B100nsubj',num2str(groupsize),'Thresh',masktype];
else
    filending = [SIbootstrap_loc,  'Results/', type, 'B100nsubj',num2str(groupsize),'Thresh'];
end

filending = [filending, '.mat'];

try
    M = load(filending);
catch
    filending
    error('You don''t have that set of variables stored.')
end
bootnaive_ests = M.A;
is_ests = M.B;

end

