function power = powercalcT( N, cohensd, alpha )
% powerCalcT(N, cohensd, alpha ) calculates the power given the number of subjects
% assuming a one sample t-stat and a given value of Cohen's d.
%--------------------------------------------------------------------------
% ARGUMENTS
% N             the number of subjects
% cohensd       the cohens d of the non-central t-statistic
% alpha         the alpha level, default is 0.05
%--------------------------------------------------------------------------
% OUTPUT
% power         the power of the specifed test
%--------------------------------------------------------------------------
% EXAMPLES
% cohensd = 1.519;
% power = powercalcT( 20, cohensd );
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 3
    alpha = 0.05;
end
power = zeros(1, length(N));

for I = 1:length(N)
    talphaquantile = tinv(1-alpha, N(I)-1);
    power(I) = 1 - nctcdf(talphaquantile, N(I)-1, cohensd*sqrt(N(I)));
end

end
