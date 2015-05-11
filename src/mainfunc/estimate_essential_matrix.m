function [E] = estimate_essential_matrix(corrPts1, corrPts2, K, F)
% CALCULATE_ESSENTIAL_MATRIX - Essential matrix E
% 
% Calculates the essential matrix E that satisfy the epipolar 
% constraint x1'*E*x2 = 0
% 
% calculate_essential_matrix(corrpts1, corrpts2, K, F)
% Input: corrPts1 = 2xN
%        corrPts2 = 2xN
%        Internal camera matrix K1 and K2
%        F - fundamental matrix

% From CVC - by Diego Cheda
% E = EssentialMatrixFrom2DPoints(corrPts1, corrPts2, K1);

% From Algorithm 25, page 252 - IREG by Klas Nordberg
% =========> Does normalization take place in F/K? <=========
E0 = K'*F*K;

[U, ~, V] = svd(E0);

D = [1 0 0;
     0 1 0;
     0 0 0;];
 
E = U*D*V';

homoCorrPts1 = conv_to_homogenous(corrPts1);
homoCorrPts2 = conv_to_homogenous(corrPts2);

firstEpConstraint = homoCorrPts1(:,1)'*E*homoCorrPts2(:,1);

sumEpConstraint = 0;
for i = 1:length(corrPts)
    sumEpConstraint = sumEpConstraint + homoCorrPts1(:,i)'*E*homoCorrPts2(:,i);
end

fprintf('>>Epipolar constraint for first point<< %f', firstEpConstraint);
fprintf('>>>>>Sum of epipolar constraints<<<<< %f', sumEpConstraint);


end