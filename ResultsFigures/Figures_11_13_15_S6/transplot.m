function scatterPoints = transplot(x,y,sizeOfCircle,opacity, color)
% TRANSPLOT(x,y,sizeOfCirlce,opacity) makes a plot of x against y with the
% option for opacity.
%--------------------------------------------------------------------------
% ARGUMENTS
% x     A vector of points
% y     A vector of points which is the same length as x.
% sizeOfCircle  Specifies the size of the cirle. If its just one number you
%               get a sphere, if its a vector with two numbers the first 
%               is the scaling in the x direction and the second is the scaling
%               in the y direction.
% opactiy   a number between 0 and 1.
% color     specifies the color, default is blue.
%--------------------------------------------------------------------------
% OUTPUT
% A plot of x against y.
%--------------------------------------------------------------------------
% EXAMPLES
% transplot(randn(5000,1),randn(5000,1),0.1,0.05)
% set(scatterPoints,'FaceColor',[1,0,0]);
%--------------------------------------------------------------------------
% AUTHOR: Thomas Nichols and Sam Davenport
if nargin < 4
    defaultColors = get(0,'DefaultAxesColorOrder');
    color = defaultColors(1,:);
end

if length(sizeOfCircle) == 1
   sizeOfCircle =  repmat(sizeOfCircle, 2,1);
end

assert(size(x,2)  == 1 && size(y,2)  == 1 , 'x and y should be column vectors');
t= 0:pi/10:2*pi;

rep_x = repmat(x',[size(t,2),1]);
rep_y = repmat(y',[size(t,2),1]);
rep_t = repmat(t',[ 1, size(x,1)]);

scatterPoints = patch((sizeOfCircle(1)*sin(rep_t)+ rep_x),(sizeOfCircle(2)*cos(rep_t)+rep_y),color,'edgecolor','none');
alpha(scatterPoints,opacity);

end
