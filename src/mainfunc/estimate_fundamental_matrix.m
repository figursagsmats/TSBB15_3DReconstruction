function [F] = estimate_fundamental_matrix(corrPts1, corrPts2)
%% 	ESTIMATE_FUNDAMENTAL_MATRIX Fundamental matrix F
% 
% Use RANSAC and then Gold Standard algorithm to calculate fundamental matrix F.
% 
% calculate_fundamental_matrix(corrPts1, corrPts2)
% Input: Correspondence points 2xN
% corrPts1 = 2xN
% corrPts2 = 2xN

%% === RANSAC robust estimation ====
nIterations = 5000;
distThresh = 3;
F_ransac = estimate_fundamental_matrix_ransac(corrPts1, corrPts2, nIterations, distThresh);


%% === Gold standard algorithm ====

F = estimate_fundamental_matrix_gs(corrPts1, corrPts2, F_ransac);
end