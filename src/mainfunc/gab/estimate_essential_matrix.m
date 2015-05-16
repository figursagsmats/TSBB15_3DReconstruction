function [E] = estimate_essential_matrix(F, K)
% CALCULATE_ESSENTIAL_MATRIX - Essential matrix E
% 
% calculate_essential_matrix(F, K)
% Input: Fundamental matrix F.
%        Intrinsic camera matrix K.


% Equation (8.62) from IREG 
% (Introduction to Representations and Estimation 
% in Geometry) by Klas Nordberg 
E0 = K'*F*K;

[U, ~, V] = svd(E0);

D = [1 0 0;
     0 1 0;
     0 0 0;];
 
E = U*D*V';

end