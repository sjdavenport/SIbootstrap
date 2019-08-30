function correction = nctcorrection(nu)
% NCTCORRECTION(nu) generates the correction factor for the mos for a t
% distribution with degrees of freedom nu. (With the sqrt(nu) in it!)
%--------------------------------------------------------------------------
% ARGUMENTS
% nu    the degrees of freedom.
%--------------------------------------------------------------------------
% OUTPUT
% correction    the correction factor.
%--------------------------------------------------------------------------
% EXAMPLES
% nctcorrection(10)
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport

correction = (sqrt(nu)/sqrt(2))*gamma((nu-1)/2)/gamma(nu/2);

end

