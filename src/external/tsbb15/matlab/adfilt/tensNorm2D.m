%function Im=tensNorm2D(T)
%
% Compute the Frobenius norm of
% a tensor in T3 format.
%

function Im=tensNorm2D(T)

Im=sqrt(squeeze(T(:,:,1)).^2+2*squeeze(T(:,:,2)).^2+squeeze(T(:,:,3)).^2);