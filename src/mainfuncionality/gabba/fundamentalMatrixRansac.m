function [F,inlinersIndexes] = fundamentalMatrixRansac(corrPts1, corrPts2)
% FUNDAMENTALMATRIXRANSAC - Fundamental matrix F by RANSAC.
% 
% [F] = FUNDAMENTALMATRIXRANSAC(corrPts1, corrPts2, nIterations,
% distThresh)
% 
% From Algorithm 26 page 262 IREG by Klas Nordberg
% --------------------------------------------
% Input: corrPts1 2xN - Correspondence points in view 1
%        corrPts2 2xN - Correspondence points in view 2

p = 0.99; % Desired probability for a good sample.
w = 0.5; % Probability for an outlier.
s = 8; % number of samples, 8-point algorithm
distThresh = 2;
nIterations = ransac_number_of_trials(p,w,s);


fprintf('---RANSAC---');
nMaxIterations = 0;
nCorrs = length(corrPts1);
for m = 1:nIterations
    
    if(mod(m,100)==0)
        fprintf('.');
    end
    
    N = datasample(1:nCorrs,8,'Replace',false);

    
    F = fmatrix_stls(corrPts1(1:2,N), corrPts2(1:2,N));     %calculate F     
    
    dist = abs(fmatrix_residuals(F,corrPts1(1:2,:),corrPts2(1:2,:)));
    
    % Nr of inliers
    inliers_bin = (dist(1,:) < distThresh) & (dist(2,:) < distThresh);
    nInliers = sum(inliers_bin);
    
    if(nMaxIterations < nInliers)
        best_iteration = m;
        nMaxIterations = nInliers;
        ransacBestF = F;
        inlinersIndexes = find(inliers_bin);
    end
    
end

fprintf('DONE\n');
fprintf('Total number of correspondences: %d \n', nCorrs);
fprintf('RANSAC best iteration %d ...Inliers: %d \n', best_iteration, nMaxIterations);


F = ransacBestF;

end

