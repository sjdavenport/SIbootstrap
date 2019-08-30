function power = powercalcF( N, cohensf2, p, alpha, m )
% powercalcF(N, cohensf2, alpha ) calculates the power given the number of subjects
% assuming a one sample t-stat and a given value of Cohen's d.
%--------------------------------------------------------------------------
% ARGUMENTS
% N             the number of subjects
% cohensf2      the cohens f^2 of the non-central F-statistic
% p             the number of parameters in the linear model. Default = 1.
% alpha         the alpha level, default is 0.05.
% m             the number of contrasts to test, default = 1.
%--------------------------------------------------------------------------
% OUTPUT
% power         the power of the specifed test
%--------------------------------------------------------------------------
% EXAMPLES
% cohensf2 = 1.519;
% power = powercalcF( 20, 0.1 );
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 3
    p = 1;
end
if nargin < 4
    alpha = 0.05;
end
if nargin < 5
    m = 1;
end

power = zeros(1, length(N));

for I = 1:length(N)
    falphaquantile = finv(1-alpha, m, N(I)-p);
    power(I) = 1 - ncfcdf(falphaquantile, 1, N(I)-p, N(I)*cohensf2);
end

end
