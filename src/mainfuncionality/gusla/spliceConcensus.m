function [ corrPts1,corrPts2,rest1,rest2 ] = spliceConcensus( pts1,pts2,correspondingIndexes )
% Use this function to extract the concensus from two list of points.
% Also return points that weren't matched separatly
%
%
% Author: Gustav Lagnström

idx1 = correspondingIndexes(1,:);
idx2 = correspondingIndexes(2,:);
corrPts1 = pts1(:,idx1);
corrPts2 = pts2(:,idx2);

pts1(:,idx1) = [];
pts2(:,idx2) = [];

rest1 = pts1;
rest2 = pts2;


end

