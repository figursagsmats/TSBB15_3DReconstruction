function [ normalizedPoints ] = norml(points, keepHomogeneous)
%NORML Normalize point coordinates.
% 
%   [normalizedPoints] = NORML(points, keepHomogeneous)
% 
%   Input: points - 3xN/4xN/...
%          keepHomogeneous - true/false or 1/0

normPointsFactor = repmat(points(end,:), size(points,1), 1);
normalizedPoints = points./normPointsFactor;

if nargin < 2
    keepHomogeneous = false;
end

if keepHomogeneous == false
    normalizedPoints(end,:) = [];
end
   
end

