clear all
close all
clc
f = create_object('F');

K = intrinsics(35,79)

%cameraParams = cameraParameters('IntrinsicMatrix',K);
cameraParams = cameraParameters();
R = rotmatx(90)*rotmaty(180);
t = [10 10 10]
%P = [cameraMatrix(cameraParams,R,t) [0 0 0 1]']
P = cameraMatrix(cameraParams,R,t);

S = eye(3)*50;
f.verticies = S*f.verticies
x3 = [f.verticies;ones(1,length(f.verticies))];


figure
plot_object(f,0.5);
cam = plotCamera('Location',t,'Orientation',R,'Opacity',0,'Size', 200);
axis equal
xlabel('X(mm)') % x-axis label
ylabel('Y(mm)') % y-axis label
zlabel('Z(mm)') % y-axis label


x = [0  1  1  0  0  0  1  1  0  0  1  1  1  1  0  0];
y = [0  0  1  1  0  0  0  1  1  0  0  0  1  1  1  1];
z = [0  0  0  0  0  1  1  1  1  1  1  0  0  1  1  0];
 
%x4d = [x(:),y(:),z(:),ones(m*n,1)]';
x2d = norml(P*x3');
nPoints = size(x3,2);
x2 = zeros(1,nPoints); y2 = zeros(1,nPoints);
x2(:) = x2d(1,:);
y2(:) = x2d(2,:);

figure
plot(x2,y2)
axis equal

