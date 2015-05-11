function [Cs] = load_dino_cmats_gt()
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

gt = load('../datasets/dino/dino_gt.mat');
%switch so that views are rows and points are cols.
Cs = gt.newPs;
end
