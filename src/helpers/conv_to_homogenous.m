function [pHomogounes] = conv_to_homogenous(p)
% CONV_TO_HOMOGENOUS Convert to homogenous coordinates
% Convert 2D or 3D points to homogenous coordinates
% Input: p = 2xN or 3xN (even works for MxN dimension points) 

pHomogenous = [p; ones(size(p,2))]

end