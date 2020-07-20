% This script generates the mean from the images using the 4000 randomly
% chosen subjects. Readimg, Imgload and imgsave are functions to load in and save
% nifti files. They are available at github.com/sjdavenport/BrainStat/.

% Load in a vector containing the subjects set aside for the mean.
subs4mean = loaddata('subs4mean');
nsubj = length(subs4mean);

global stdsize
r_mean_img = zeros(stdsize);

%This loops through all of the subjects that are to be used to calculate
%the random mean.
for I = subs4mean
    r_mean_img = readimg(I, 'copes', 1) + r_mean_img; 
    %actual = 1 in readimg so that we take the actual subject list
    if mod(I,100) == 0
        disp(I)
    end
end

r_mean_img = r_mean_img/nsubj;

imgsave(r_mean_img, 'r_mean_img', parloc)

%% Deal with outer brain stuff
MNImask = logical(imgload('MNImask'));

fullmeanNAN = nan(stdsize);
fullmeanNAN(MNImask) = fullmean(MNImask);

imgsave(fullmeanNAN,'fullmean',2)


%Other way to open things:
%fid = fopen('subjlist.txt');
%subjects = textscan(fid, '%s', 8945, 'delimiter', '\n');
%fclose(fid);
