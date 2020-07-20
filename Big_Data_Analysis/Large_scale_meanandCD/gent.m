% This script generates the meansq, var, std and t from the images using the 4000 randomly
% chosen subjects.

subs4mean = loaddata('subs4mean');
nSubj = length(subs4mean);

global stdsize
r_meansq_img = zeros(stdsize);

%This loops through all of the subjects that are to be used to calculate
%the random mean.
for I = subs4mean
    r_meansq_img  = readimg(I, 'copes', 1).^2 + r_meansq_img; 
    %actual = 1 in readimg so that we take the actual subject list
    if mod(I,100) == 0
        disp(I)
    end
end

r_meansq_img = r_meansq_img/nSubj;
r_mean_img = imgload('mean');

r_var_img = (nSubj/(nSubj-1))*(r_meansq_img - r_mean_img.^2);
r_std_img = sqrt(r_var_img);

r_t_img = sqrt(nSubj)*r_mean_img./r_std_img;

global parloc
imgsave(r_meansq_img, 'r_meansq_img', parloc)
imgsave(r_var_img, 'r_var_img', parloc)
imgsave(r_std_img, 'r_std_img', parloc)
imgsave(r_t_img, 'r_t_img', parloc)

%Other way to open things:
%fid = fopen('subjlist.txt');
%subjects = textscan(fid, '%s', 8945, 'delimiter', '\n');
%fclose(fid);
