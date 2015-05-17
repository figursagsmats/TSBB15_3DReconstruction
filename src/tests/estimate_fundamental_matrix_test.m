clear
clc
global images; 
images = load_dataset('../datasets/dino/images/','*.ppm');
K = calibrate_camera('../datasets/dino/calibration','*.ppm');
img1 = images(1).img;
img2 = images(2).img;

[pointsTable,Ps] = load_dino_gt(); %FORNOW
[pts1,pts2] = get_correspondces(1,2,pointsTable);

corrList = zeros(size(pts1));
corrList(1,:) = 1:length(pts1);
corrList(2,:) = 1:length(pts1);

% Matlabs built-in RANSAC
load stereoPointPairs
for m = 1:100
    [fRANSAC, inlierIndex] = estimateFundamentalMatrix(pts1', pts2', 'Method', 'RANSAC', 'NumTrials', 5000, 'DistanceThreshold', 0.01);
    a(m) = sum(inlierIndex == 1);
    if mod(m,100) == 0
        disp(m);
    end
end
plot(a)
ylim([0 40])
%%

matchedPoints1 = matchedPoints1';
matchedPoints2 = matchedPoints2';

pts1(:,1) = [430 280];
pts1(:,20) = [435 145];
pts1(:,25) = [405 440];
pts1(:,30) = [1 576];
pts1(:,35) = [10 10];

p = 0.99;
w = 0.5;
s = 8; % 8-points algorithm

nIterations = log(1 - p)/log(1-w^s);
for m = 1:100
    [F_ransac, inlierIndex] = estimate_fundamental_matrix_ransac(pts1, pts2, nIterations, 2);
    a(m) = sum(inlierIndex == 1);
    disp(m);
end
disp('DONE');
plot(a)
ylim([0 40])

