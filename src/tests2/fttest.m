clear all;
close all;
%I1 = rgb2gray(imread('viprectification_deskLeft.png'));
%I2 = rgb2gray(imread('viprectification_deskRight.png'));
images = load_dataset('../datasets/dino/images/','*.ppm');

I1 = rgb2gray(images(1).img);
I2 = rgb2gray(images(2).img);

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[features1, valid_points1] = extractFeatures(I1, points1);
[features2, valid_points2] = extractFeatures(I2, points2);
indexPairs = matchFeatures(features1, features2);
matchedPoints1 = valid_points1(indexPairs(:, 1), :);
matchedPoints2 = valid_points2(indexPairs(:, 2), :);
figure; showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);