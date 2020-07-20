% Calulate the MOS over the 4000 random subjects using all the available data at each voxel. (Not
% eliminating the ones where data is missing.)
subs4mean = loaddata('subs4mean');
nSubj = length(subs4mean);
% Calculate the MOS using the available data at each voxel instead of
% setting to zero the ones which have no data.

SOM = imgload('SOM_MNImask'); %As we're only interested at looking at stuff within the brain!

global stdsize
fullmean_sq = zeros(stdsize);
fullmean = zeros(stdsize);
fullMOS = zeros(stdsize);

for I = subs4mean
    img = readimg(I, 'copes', 1);
    mask = readimg(I,'mask',1);
    
    fullmean = fullmean + img.*mask;
    fullmean_sq = fullmean_sq + (img.^2).*mask;
    
    %actual = 1 in readimg so that we take the actual subject list
    if mod(I,100) == 0
        disp(I)
    end
end

fullmean = fullmean./SOM;
fullmean_sq = fullmean_sq./SOM;

fullvar = (SOM./(SOM-1)).*(fullmean_sq - fullmean.^2);

fullstd = sqrt(fullvar);

fullmos = fullmean./fullstd;
% fullmos(isnan(fullmos)) = 0;

imgsave(fullmean,'fullmean',2)
imgsave(fullmean_sq,'fullmean_sq',2)
imgsave(fullstd,'fullstd',2)
imgsave(fullvar,'fullvar',2)
imgsave(fullmos,'fullmos',2)

%% Deal with outer brain stuff
MNImask = logical(imgload('MNImask'));

fullmeanNAN = nan(stdsize);
fullmeanNAN(MNImask) = fullmean(MNImask);

imgsave(fullmeanNAN,'fullmean',2)

