function [isHomogeneous] = is_homogeneous(points)
%IS_HOMOGENOUS Check if given 2xN/3xN/4xN/... points are in homogenous coordinates.

nHomogeneous = sum(1 == points(end,:));

if nHomogeneous == size(points, 2)
    isHomogeneous = 1;
else
    isHomogeneous = 0;
end

end

