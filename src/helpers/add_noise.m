function [noisedPoints] = add_noise(p, sigma, my)
% ADD_NOISE - Add noise to points coordinates.
% Normal distribution.
% Default: sigma = 0.1, mean = 0
% 
% [noisedPoints] = ADD_NOISE(p)
% [noisedPoints] = ADD_NOISE(p, variance, mean)
% --------------------------------------------
% Input: p - A set of points p with size 2xN/3xN/4xN... or Nx2/Nx3/Nx4...
%        sigma - Standard deviation
%        mean - mean value
% 
% Output: A set of points noisedPoints with the same size as p.

if nargin == 1
    my = 0;
    sigma = 0.1;
end

noise = sigma*randn(size(p)) + my;
noisedPoints = p + noise;

end