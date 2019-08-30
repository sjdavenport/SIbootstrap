function CD = matchsimspowerR22CD( R2, Nforapprox, CD_upper, p, alpha )
% MATCHSIMSPOWERR22CD( R2, Nforapprox, CD_upper, p, alpha ) calculates the 
% corresponding Cohen's d for equal simulation power.
%--------------------------------------------------------------------------
% ARGUMENTS
% R2          the R^2 value with which to match.
% Nforapprox a represenative number of subjects at which to match the power
% CD_upper    the upper Cohen's d value over which to do a binary segmentation
% p           the number of parameters in the model
% alpha       the alpha value at which to threshold
%--------------------------------------------------------------------------
% OUTPUT
% CD          the value of Cohen's d in order to match the power.
%--------------------------------------------------------------------------
% EXAMPLES
% Cohensd = 0.1;
% [~, R2] = matchsimspowerCD2R2( Cohensd );
% CD = matchsimspowerR22CD( R2 )
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 2
    Nforapprox = 30;
end
if nargin < 3
    CD_upper = 5;
end
if nargin < 4
    p = 2;
end
if nargin < 5
    alpha = 0.05;
end

f2  = R2/(1-R2);
f2power = powercalcF( Nforapprox, f2, p, alpha );

error_diff = 1;

CD_lower = 0;
CDpowerupper = powercalcT( Nforapprox, CD_upper, alpha );

if CDpowerupper < f2power
    error('Your upper Cohen''s d limit is too low');
end

while error_diff > 0.001
    CD = (CD_upper + CD_lower)/2;
    
    CDpower = powercalcT( Nforapprox, CD, alpha );
    error_diff = abs(CDpower - f2power);
    
    if f2power < CDpower
        CD_upper = CD;
    else
        CD_lower = CD;
    end
end

end

