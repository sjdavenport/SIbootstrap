%% Code to generate bias boxplots for Figures 10, 12, 14 and S5
% export_fig is required in order to save the images. 

for type = {'tstat'}
    clf
    generate_boxplots(type{1})
end

%%
for type = {'t4lm'}
    clf
    generate_boxplots(type{1})
end

%%
for type = {'mean'}
    clf
    generate_boxplots(type{1})
end

%%
for type = {'R2'}
    clf
    generate_boxplots(type{1})
end
