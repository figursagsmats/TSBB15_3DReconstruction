function [F] = estimate_fundamental_matrix(corrPts1, corrPts2)
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
nIterations = 5000;
distThresh = 3;
F_ransac = estimate_fundamental_matrix_ransac(corrPts1, corrPts2, nIterations, distThresh);


%% === Gold standard algorithm ====

F = estimate_fundamental_matrix_gs(corrPts1, corrPts2, F_ransac);
end