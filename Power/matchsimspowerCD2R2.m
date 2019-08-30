function [ mu, R2 ] = matchsimspowerCD2R2( Cohensd, Nforapprox, mu_upper, p, alpha )
% MATCHSIMSPOWERCD2R2( Cohensd, Nforapprox, beta_upper, p, alpha )
% calculates the corresponding beta and R2 for equal simulation power as
% described in the supplementary material.
%--------------------------------------------------------------------------
% ARGUMENTS
% Cohensd   the cohens d
% Nforapprox a represenative number of subjects at which to match the power
% mu_upper    the upper coefficient value over which to do a binary segmentation
% p           the number of parameters in the model
% alpha       the alpha value at which to threshold
%--------------------------------------------------------------------------
% OUTPUT
% mu          an estimate of the coefficient mu for the linear model
% R2          the corresponding R^2 from an equation with mu in it
%--------------------------------------------------------------------------
% EXAMPLES
% Cohensd = 0.5;
% [ mu, R2 ] = matchsimspowerCD2R2( Cohensd )
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport
if nargin < 2
    Nforapprox = 30;
end
if nargin < 3
    mu_upper = 5;
end
if nargin < 4
    p = 2;
end
if nargin < 5
    alpha = 0.05;
end

CDpower = powercalcT( Nforapprox, Cohensd, alpha );

error_diff = 1;

beta_lower = 0;
f2upper = mu_upper^2;
f2powerupper = powercalcF( Nforapprox, f2upper, p, alpha );

if f2powerupper < CDpower
    error('Your upper beta limit is too low');
end

while error_diff > 0.001
    mu = (mu_upper + beta_lower)/2;
    f2 = mu^2;
    
    f2power = powercalcF( Nforapprox, f2, p, alpha );
    error_diff = abs(CDpower - f2power);
    
    if CDpower < f2power
        mu_upper = mu;
    else
        beta_lower = mu;
    end
end
R2 = f2/(1+f2);

end

