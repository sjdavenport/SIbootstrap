function Fstat = R2F( R2, n, p, p_0 )
% R2F( R2, n, p, p_0 ) converts the value of the R^2-statistic to an  F-statistic
% using the transformation as derived in the useful results.
%--------------------------------------------------------------------------
% ARGUMENTS
% Fstat     The value of the F statistic
% n         the number of data points (ie number of subjects/length of Y).
% p         the number of parameters in the model.
% p_0       the number of parameters in the null model.
%--------------------------------------------------------------------------
% OUTPUT
% R2        The value of the corresponding R^2 value.
%--------------------------------------------------------------------------
% EXAMPLES
% R2F(0.8, 4000, 2, 1)
% R2F(0.8, 4000, 2, 1)
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport

if isequal(size(n), [1,1]) && length(R2) > 1
    n = repmat(n, 1, length(R2));
end

Fstat = ((n-p)./(p-p_0)).*(R2./(1-R2));

end