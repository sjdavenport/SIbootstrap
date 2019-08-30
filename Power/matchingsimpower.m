% This file derives the beta required to acheive a similar power to the one-sample 
% t simulations with the GLM simulations, see the supplementary material.

p = 2;
beta = 0.5822;
f2 = beta^2;
R2 = f2/(1+f2);
alpha = 0.05;
N = 30;

falphaquantile = finv(1-alpha, 1, N-p);
power = 1 - ncfcdf(falphaquantile, 1, N-p, N*f2)

%%
Cohensd = 0.5;

% talphaquantile = norminv(1-alpha, 0, 1);
% power = 1 - normcdf(talphaquantile, sqrt(N)*Cohensd, 1)
talphaquantile = tinv(1-alpha, (N-1));
power = 1 - nctcdf(talphaquantile, N-1, sqrt(N)*Cohensd)

%%
Cohensd = 0.5;
[~, R2] = matchsimspowerCD2R2( Cohensd )
%%
Cohensd = 0.5;
[~, R2] = matchsimspowerCD2R2( Cohensd )

%%
Cohensd = 0.1;
[beta, R2] = matchsimspowerCD2R2( Cohensd )

%%
R2 = 0.0246;
CD = matchsimspowerR22CD( R2 )

%%
R2 = 0.05;
CD = matchsimspowerR22CD( R2 )

%%
beta = 0.5652;
f2 = beta^2;
R2 = f2/(1+f2);
CD = matchsimspowerR22CD( R2 )
%%
R2_vec = 0.05:0.05:0.35;
CD_vec = zeros(1, length(R2_vec));
for I = 1:length(R2_vec)
    CD_vec(I) = matchsimspowerR22CD( R2_vec(I) )
end

sigma_vec = repmat(0.5,1, length(CD_vec))./CD_vec
%% Use the following stddevs:
stddev_vec = [3,2.75,2.5,2.25, 2,1.75, 1.5,1.25,1];
stddev_vec = [3,2.5, 2, 1.5,1];
mu = 0.5;
CD_vec = mu./stddev_vec;
R2_vec = zeros(1, length(CD_vec));
for I = 1:length(CD_vec)
    [~,R2_vec(I)] = matchsimspowerCD2R2( CD_vec(I) );
end
R2_vec

%%
CD_vec = 0.1:0.1:0.7;
R2_vec = zeros(1, length(CD_vec));
for I = 1:length(CD_vec)
    [~,R2_vec(I)] = matchsimspowerCD2R2( CD_vec(I) );
end
R2_vec

