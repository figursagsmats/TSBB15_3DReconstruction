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

if nargin < 4
    % TODO: Check if i have to save the inliers/outliers from RANSAC
    F = estimate_fundamental_matrix(corrPts1, corrPts2);
end

E0 = K'*F*K;

[U, ~, V] = svd(E0);

D = [1 0 0;
     0 1 0;
     0 0 0;];
 
E = U*D*V';

if is_homogeneous(corrPts1) == false
    corrPts1 = conv_to_homogeneous(corrPts1);
    corrPts2 = conv_to_homogeneous(corrPts2);
end

firstEpConstraint = corrPts1(:,1)'*E*corrPts2(:,1);

nCorrs = length(corrPts1);
sumEpConstraint = 0;
for i = 1:nCorrs
    sumEpConstraint = sumEpConstraint + corrPts1(:,i)'*E*corrPts2(:,i);
end

fprintf('>>Epipolar constraint - first point for E << \n %f', firstEpConstraint);
fprintf('>>>>>Sum of all points for E <<<<< \n %f', sumEpConstraint);


end