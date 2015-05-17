function [F, inlierIndexes] = estimate_fundamental_matrix(corrPts1, corrPts2)
% ESTIMATE_FUNDAMENTAL_MATRIX Fundamental matrix F
% 
% Use RANSAC and Gold Standard algorithm to estimate the fundamental matrix F.
% 
% [F] = ESTIMATE_FUNDAMENTAL_MATRIX(corrPts1, corrPts2)
% --------------------------------------------
% Input: Correspondence points - 2xN
% corrPts1 = 2xN
% corrPts2 = 2xN
% Output: Fundamental matrix F

%% === RANSAC robust estimation ====

p = 0.99;
w = 0.5;
s = 8; % 8-points algorithm
nIterations = ransac_number_of_trials(p, w, s);
distThresh = 2;

[F_ransac, inlierIndexes] = estimate_fundamental_matrix_ransac(corrPts1, corrPts2, nIterations, distThresh);
%% === Gold standard algorithm ====

F = estimate_fundamental_matrix_gs(corrPts1(:,inlierIndexes), corrPts2(:,inlierIndexes), F_ransac);
end