function [isHomogenous] = is_homogenous( points )
%IS_HOMOGENOUS Check if given 2xN/3xN/4xN/... points are in homogenous coordinates.

nHomogenous = sum(1 == points(end,:));

if nHomogenous == length(points)
    isHomogenous = 1;
else
    isHomogenous = 0;
end

end

