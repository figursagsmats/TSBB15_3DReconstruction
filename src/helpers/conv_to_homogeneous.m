function [pHomogeneous] = conv_to_homogeneous(p)
% CONV_TO_HOMOGENOUS Convert to homogeneous coordinates
% Convert 2D or 3D points to homogeneous coordinates
% Input: p = 2xN or 3xN (even works for MxN points) 

if is_homogeneous(p) == false
    pHomogeneous = [p; ones(size(p,2), 1)'];
end

end