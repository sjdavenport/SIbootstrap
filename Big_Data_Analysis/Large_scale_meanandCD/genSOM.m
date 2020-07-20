% Generate the SOM: which is the sum over masks. And the SOM_MNI which is
% the SOM but multiplied by the MNI_mask of the brain.

subs4mean = loaddata('subs4mean');
nSubj = length(subs4mean);

global stdsize
SOM = zeros(stdsize);

for I = subs4mean
    SOM  = readimg(I, 'mask', 1) + SOM; 
    %actual = 1 in readimg so that we take the actual subject list
    if mod(I,100) == 0
        disp(I)
    end
end

MNImask = imgload('MNImask');
SOM_MNImask = SOM.*MNImask;

imgsave(SOM, 'SOM', 2)
imgsave(SOM_MNImask, 'SOM_MNImask', 2)
