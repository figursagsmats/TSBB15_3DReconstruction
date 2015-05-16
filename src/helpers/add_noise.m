function [noisedPoints] = add_noise(p, sigma, my)
% ADD_NOISE - Add noise to points coordinates.
% Gauss normal distribution.
% Default: sigma = 0.1, mean = 0
% 
% Input: p - A set of points p with size 2xN/3xN/4xN... or Nx2/Nx3/Nx4...
%        sigma - Standard deviation
%        mean - mean value
% 
% Output: A set of points noisedPoints with the same size as p.
% 
% [noisedPoints] = add_noise(p)
% [noisedPoints] = add_noise(p, variance, mean)

if nargin == 1
    my = 0;
    sigma = 0.1;
end

% if scale < 0
%     disp('ERROR! You cannot scale with negative value. Running default...');
%     scale = 1;
% end

noise = sigma*randn(size(p)) + my;
noisedPoints = p + noise;

end