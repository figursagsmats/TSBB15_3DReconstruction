function [ pointsTable] = load_dino_2dpts_gt()
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

disp('BADino2.mat is loaded');
% disp('dino_gt.mat is loaded');
gt = load('../datasets/dino/BADino2.mat');

%switch so that views are rows and points are cols.
pointsTable = permute(gt.points2DMatrix,[2 1 3]);

end

