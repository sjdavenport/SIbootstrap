% Running VBM data against Age and Sex - Preparation for Large Scale Linear
% Modelling
%
% Note this code will not run without modifications we have included it to 
% illustrate how the large scale linear model can be run. (When
% you have a large number of subjects that cannot fit all at once in
% memory.) Unfortunately we are unable to share the original data this is 
% run on as it is part of the UK Biobank, however we encourage the reader to
% try this on their own data or on simulated large scale data. 
%
% Note that imgsave and imgload are functions (not included in the current
% package which save and load in the respective images).

%% Load in Age and Sex Variables
Sex = bbvars('Sex'); %Loads in an nsubj by 1 vector with the sex of each subject.
Age = bbvars('Age'); %Loads in an nsubj by 1 vector with the age of each subject.

nsubj = length(Sex); %Calculates the number of subjects.
subs4mean = loaddata('subs4mean'); %Loads in the 4000 subjects set aside to calculate the ground truth.
%These subjects have been chosen at random from the 8940 total subjects.

vbm_maskNAN = imgload('vbm_maskNAN'); %Loads in the VBM mask
%% 
stdsize = [91,109,91]; %The size of the 2mm MNI brain.
agey = zeros(stdsize); %Empty matrix to store the sum of Age*Y over all subjects, at every voxel.
sexy = zeros(stdsize); %Empty matrix to store the sum of Age*Sex over all subjects, at every voxel.
agesexy = zeros(stdsize); %Empty matrix to store the sum of Age*Sex*Y over all subjects, at every voxel.

for I = 1:nsubj
    subject_image = readvbm(subs4mean(I),1); %Reads in the VBM data for the Ith subject used for the ground truth.
    
    agey = agey + subject_image*Age(I);
    
    sexy = sexy + subject_image*Sex(I);
    
    agesexy = agesexy + subject_image*Sex(I)*Age(I);
    
    disp(I);
end

%Mask the data
agey = agey.*vbm_maskNAN;
sexy = sexy.*vbm_maskNAN;
agesexy = agesexy.*vbm_maskNAN;

imgsave(agey,'smooth_vbmagey')
imgsave(sexy,'smooth_vbmsexy')
imgsave(agesexy,'smooth_vbmagesexy')
