function [F, inlier_indexes] = estimate_fundamental_matrix_ransac(corrPts1, corrPts2, nIterations, distThresh)
% ESTIMATE_FUNDAMENTAL_MATRIX_RANSAC - Fundamental matrix F by RANSAC.
% 
% [F] = ESTIMATE_FUNDAMENTAL_MATRIX_RANSAC(corrPts1, corrPts2, nIterations,
% distThresh)
% 
% From Algorithm 26 page 262 IREG by Klas Nordberg
% --------------------------------------------
% Input: corrPts1 2xN - Correspondence points in view 1
%        corrPts2 2xN - Correspondence points in view 2
%        nIterations - Number of iterations 
%        distThresh - A pixel distance threshold

% fprintf('---RANSAC---');
nMaxIterations = 0;
nCorrs = length(corrPts1);
for m = 1:nIterations
    
%     if(mod(m,100)==0)
%         fprintf('.');
%     end
    
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
        inliers_logical = inliers_bin;
        inlier_indexes = find(inliers_bin);
        
        outlier_indexes = find(~inliers_bin);
    end
    
end
% fprintf('DONE\n');
% fprintf('Total number of correspondences: %d \n', nCorrs);
% fprintf('RANSAC best iteration %d ...Inliers: %d \n', best_iteration, nMaxIterations);


F = ransacBestF;

end