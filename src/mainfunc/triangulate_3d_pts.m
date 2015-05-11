function [ X ] = triangulate_3d_pts( Q1,Q2,x1,x2 )
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here
Cs = load_dino_cmats_gt();

C1 = cell2mat(Cs(1));
C2 = cell2mat(Cs(2));
%X = triangulate_optimal(C1,C2,x1,x2);

X = zeros(size(x1));
end

