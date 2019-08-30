function out = prep_Xbar_plots( type, groupsize, thresh, no_axis_limits)
% PREP_XBAR_PLOTS( type, nsubj, thresh, no_axis_limits, nboot ) prepares
% variables for use in the plotting of the Xbar estimates.
%--------------------------------------------------------------------------
% ARGUMENTS
% type
% groupsize
% thresh
% no_axis_limits
% nboot
%--------------------------------------------------------------------------
% OUTPUT
% out   A structure with the required varibles.
%--------------------------------------------------------------------------
% AUTHOR: Sam Davenport.
if nargin < 4
    no_axis_limits = 1;
end

out.type = type;
out.circ_size = 1.5;
out.label_for_y = NaN;

if strcmp(type, 't') || strcmp(type, 'tstat')
    out.type = 'tstat';
    out.label_for_x = 'Cohens d';
    nct = 1;
elseif strcmp(type, 't4lm')
    out.type = 't4lm';
    out.label_for_x = 'mean';
    nct = 1;
    out.label_for_y = 'the mean';
elseif strcmp(type, 'mean') || strcmp(type, 'SSmean')
    out.label_for_x = 'mean';
    nct = 0;
    out.label_for_y = 'the mean';
elseif strcmp(type, 'vbmagesex') && thresh == 1
    out.label_for_x = 'R^2';
    nct = 0;
else
    error('type not found')
end

if isnan(out.label_for_y)
    out.label_for_y = out.label_for_x;
end

out.xlims = 'mode';
out.ylims = 'mode';
out.xlims_naive = 'mode';
out.ylims_naive = 'mode';
out.trans_level = 0.2;

out.height = 800;
out.width = 800;
if ~no_axis_limits
    if groupsize == 20
        if strcmp(type, 'mean')
            out.xlims = [-.30,1.40];
            out.ylims = [-.50,2.50];
            out.xlims_naive = [1.00,3.00];
            out.ylims_naive = [4.0,2.00];
        elseif strcmp(type, 'tstat')
            out.xlims = [0, 1.6];
            out.ylims = [0,3.5];
            out.width = 1.4*out.width;
            out.xlims_naive = [1,3.5];
            out.ylims_naive = [-1,4];
            out.trans_level = 0.2;
        elseif strcmp(type, 't4lm')
            out.xlims = [0,1.40];
            out.ylims = [0,1.80];
            out.xlims_naive = [-0.3,2.7];
            out.ylims_naive = [-0.7,2.7];
        end
    elseif groupsize == 50
        if strcmp(type, 'mean') 
            out.xlims = [.50,1.40];
            out.ylims = [.40,2.00];
            out.xlims_naive = [1.00,2.00];
            out.ylims_naive = [.70,1.90];
            out.trans_level = 0.4;
        elseif strcmp(type, 'tstat')
            out.xlims = [0, 1.6];
            out.ylims = [0, 2.5];
            out.xlims_naive = [0.9, 2.4];
            out.ylims_naive = [0, 2.5];
            out.trans_level = 0.15;
        elseif strcmp(type, 't4lm')
            out.xlims = [0,1.40];
            out.ylims = [-.10,1.80];
            out.xlims_naive = [-0.3,2.7];
            out.ylims_naive = [-0.7,2.7];
        elseif strcmp(type, 'vbmagesex')
            out.xlims = [0,0.25];
            out.ylims = [0,0.55];
            out.trans_level = 0.6;
        end
    elseif groupsize == 100
        if strcmp(type, 'mean')
            out.xlims = [.70,1.40];
            out.ylims = [.60,1.70];
            out.xlims_naive = [1.00,1.80];
            out.ylims_naive = [.80,1.80];
            out.trans_level = 0.6;
        elseif strcmp(type, 'tstat')
            out.xlims = [0, 1.6];
            out.ylims = [-0.1, 2.1];
            out.xlims_naive = [0.9, 2.4];
            out.ylims_naive = [0, 2.5];
            out.trans_level = 0.15;
        elseif strcmp(type, 't4lm')
            out.xlims = [0,1.40];
            out.ylims = [0,1.70];
            out.xlims_naive = [-0.3,2.7];
            out.ylims_naive = [-0.7,2.7];
        elseif strcmp(type, 'vbmagesex')
            out.xlims = [0,0.25];
            out.ylims = [0,0.45];
            out.trans_level = 0.4;
        end
    elseif groupsize == 150
        if strcmp(type, 'vbmagesex')
            out.xlims = [0,0.25];
            out.ylims = [0,0.4];
            out.trans_level = 0.4;
        end
    end

end

% For the mean need to add stuff below!
if strcmp(type, 'tstat')
    out.xlims_naive = [0.7,3.5];
    out.ylims_naive = [0,2];
elseif strcmp(type, 't4lm')
    out.xlims_naive = [0,2.00];
    out.ylims_naive = [0,2.00];
end

if strcmp(type, 'mean')
    if groupsize == 20
        out.xtick = -0.25:0.25:1.4;
    elseif groupsize == 50
        out.xtick =  0.6:0.2:1.4;
    elseif groupsize == 100
        out.xtick =  0.8:0.2:1.4;
    end
elseif strcmp(type, 't4lm')
    out.xtick = 0:0.2:1.4;
elseif strcmp(type, 'tstat')
    out.xtick = 0:0.5:1.5;
elseif strcmp(type, 'vbmagesex')
    out.xtick = 0:0.05:0.25;
end

out.circ_size = [diff(out.xlims), diff(out.ylims)]/100;
out.circ_size_naive = [diff(out.xlims_naive), diff(out.ylims_naive)]/100;

%% Get Data
[A, B] = loadres_thresh(type, groupsize);

if strcmp(type, 'vbmagesex')
    out.boot = A(:,3);
    out.naive = A(:,5);
    out.is = B(:,3);
    out.truenaiveboot = A(:,9);
    out.trueatlocis = B(:,5);
    out.Amax = A(:,2);
    out.Bmax = B(:,2);
else
    if nct == 1
        out.boot = A(:,3)/nctcorrection(groupsize);
        out.naive = A(:,4)/nctcorrection(groupsize); %correcting for non-central t
        out.is = B(:,3)/nctcorrection(groupsize/2);
    else
        out.boot = A(:,3);
        out.naive = A(:,4);
        out.is = B(:,3);
    end
    out.truenaiveboot = A(:,5);
    out.trueatlocis = B(:,4);
    out.Amax = A(:,2);
    out.Bmax = B(:,2);
end

if strcmp(type, 'mean') || strcmp(type, 't4lm')
    out.boot = out.boot/100;
    out.is = out.is/100;
    out.naive = out.naive/100;
    
    out.truenaiveboot = out.truenaiveboot/100;
    out.trueatlocis = out.trueatlocis/100;
end

end

