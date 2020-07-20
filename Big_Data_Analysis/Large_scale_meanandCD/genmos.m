% This script generates the mos from the images using the 4000 randomly
% chosen subjects.

mean = imgload('mean');
std = imgload('std'); %Q: what happens if the entry of std is 0/very small, this gets set to infinity right?

mos = mean./std;

global parloc
imgsave(mos, 'r_mos', parloc)