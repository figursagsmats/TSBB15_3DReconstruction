%
%function msetup(sigma, alpha, beta, j)
%
%   This function initializes the parameters of the map function
%
%              /            beta         \ 1/j
%              |           x             |
%	   m = | ----------------------- |
%              |  beta+alpha        beta |
%              \ x           + sigma     /
%
%   As used by the tensRemap routine.
%
%   See "Signal Processing for Computer Vision", page 315.
%
%Per-Erik Forssen, 1998
%
