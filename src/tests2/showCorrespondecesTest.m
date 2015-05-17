clear all; close all;
images = load_dataset('../datasets/dino/images/','*.ppm');

x = [100,150];
y = [100,80];
x2 = x+50;
y2 = y+50;
img = imread('autumn.tif');
figure,imshow(img)

%# make sure the image doesn't disappear if we plot something else
hold on

%# define points (in matrix coordinates)
p1 = [10 100];
p2 = [100 20];


%# plot the points.
%# Note that depending on the definition of the points,
%# you may have to swap x and y
plot(x,y,'Color','r','LineWidth',1)
plot(x2,y2,'Color','r','LineWidth',1)