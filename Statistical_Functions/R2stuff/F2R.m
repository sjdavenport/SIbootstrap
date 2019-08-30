function [R2, f2] = F2R( Fstat, n, p, p_0 )
% F2R( Fstat, n, p, p_0 ) convert the value of the F-statistic to an R^2-statistic 
% using the transformation as derived in the useful results.
%--------------------------------------------------------------------------
% ARGUMENTS
% Fstat     The value of the F statistic
% n         the number of data points (ie number of subjects/length of Y).
% p         the number of parameters in the model.
% p_0       the number of parameters in the 
%--------------------------------------------------------------------------
% OUTPUT
% R2        The value of the corresponding R^2 value.
%--------------------------------------------------------------------------
% EXAMPLES
% F2R(4*4000, 4000, 2, 1)
% F2R(0.05^2*4000, 4000, 2, 1)
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 4
    p_0 = p - 1;
    warning('We have assumed that the null model is the full model except leaving out one parameter');
end

if isequal(size(n), [1,1])
    n = n*ones(size(Fstat));
end

R2 = 1 - 1./((p-p_0)./(n-p).*Fstat + 1);

f2 = ((p-p_0)./(n-p)).*Fstat;

end
