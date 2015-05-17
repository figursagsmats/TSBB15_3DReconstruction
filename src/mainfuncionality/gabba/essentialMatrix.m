function [ E ] = essentialMatrix(F,K)
% ESTIMATE_ESSENTIAL_MATRIX - Essential matrix E
% 
% [E] = ESTIMATE_ESSENTIAL_MATRIX(F, K)
% 
% From Equation (8.62) page 138 IREG by Klas Nordberg 
% --------------------------------------------
% Input: Fundamental matrix F.
%        Intrinsic camera matrix K.
% Output: Essential matrix E.

E0 = K'*F*K;

[U, ~, V] = svd(E0);

D = [1 0 0;
     0 1 0;
     0 0 0;];
 
E = U*D*V';
end

