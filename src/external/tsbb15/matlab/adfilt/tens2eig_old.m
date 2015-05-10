function [Lambda, EigVec] = tens2eig(Tcomp)
%  [Lambda, EigVec] = tens2eig(Tcomp)
%
%  Compute the eigensystem of a 2D or 3D tensor.
%
%Author: Johan Wiklund
%

% Added support for 2D tensors, and changed 3D
% component order to be consistent with
% Magnus H's code for 3D orient.
%
% Changed 2D component order
%
% /Per-Erik

% Put tensor components in matrix

sz=size(Tcomp,1);

if (sz~=6)&(sz~=3)
    error('Tcomp should be a 6 or 3 component column vector.');
end
if (sz==6)
    T = [ Tcomp([1 4 5]) ...
	  Tcomp([4 2 6]) ...
	  Tcomp([5 6 3]) ];
else
    T = [ Tcomp([1 2]) ...
	  Tcomp([2 3])  ];
end

% Solve for eigenvalues and eigenvectors
[EigVec, Lambda]=eig(T);
Lambda=diag(Lambda);

% Make sure all eigenvalues are positive
lm=min(Lambda);

if lm < 0
    if(sz==6)
	Lambda = Lambda + -lm;
    else
	Lambda = abs(Lambda);
    end
end

% Sort in descending order
Lambda= -Lambda;
[Lambda,I]=sort(Lambda);
EigVec=EigVec(:,I);
Lambda= -Lambda;


