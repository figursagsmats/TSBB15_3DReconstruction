%function mysetup(alpha, beta,  j)
%
%   This function initializes the parameters of the map function
%
%            /                   beta           \ 1/j
%            |        (x(1-alpha))              |
%	my = | -------------------------------- |
%            |            beta             beta |
%            \ (x(1-alpha))   + (alpha(1-x))    /
%
%
%   See "Signal Processing for Computer Vision", page 315.
%
%Per-Erik Forssen, 1998
%

