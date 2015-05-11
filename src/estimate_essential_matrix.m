function [E] = estimate_essential_matrix(corrPts1, corrPts2, K1, K2)
% CALCULATE_ESSENTIAL_MATRIX - Essential matrix E
% 
% Calculates the essential matrix E that satisfy the epipolar 
% constraint x1'*E*x2 = 0
% 
% calculate_essential_matrix(corrpts1, corrpts2, K1, K2)
% Input: corrPts1 = 2xN
%        corrPts2 = 2xN
%        Internal camera matrix K1 and K2

F = calculate_fundamental_matrix(corrPts1, corrPts2);

% From CVC - by Diego Cheda
% E = EssentialMatrixFrom2DPoints(corrPts1, corrPts2, K1);

% From Algorithm 25, page 252 - IREG by Klas Nordberg
% =========> Does normalization take place in F/K? <=========
E0 = K1'*F*K2;

[U, ~, V] = svd(E0);

D = [1 0 0;
     0 1 0;
     0 0 0;];
 
E = U*D*V';


end