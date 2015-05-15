function [F] = estimate_fundamental_matrix_ransac(corrPts1, corrPts2, nIterations, distThresh)
% ESTIMATE_FUNDAMENTAL_MATRIX_RANSAC - Fundamental matrix F by using RANSAC
% 
% Returns fundamental matrix F, estimated with RANSAC.
% Input: corrPts1 2xN - Correspondence points in view 1
%        corrPts2 2xN - Correspondence points in view 2
%        nIterations - Number of iterations 
%        distThresh - A pixel distance threshold
%        

fprintf('---RANSAC---');
nMaxIterations = 0;
nCorrs = length(corrPts1);
for m = 1:nIterations
    
    if(mod(m,100)==0)
        fprintf('.');
    end
    
    N = datasample(1:nCorrs,8,'Replace',false);    %choose random samples
    F = fmatrix_stls(corrPts1(1:2,N), corrPts2(1:2,N));     %calculate F     
    
    dist = abs(fmatrix_residuals(F,corrPts1(1:2,:),corrPts2(1:2,:)));
    
    % Nr of inliers
    inliers_bin = (dist(1,:) < distThresh) & (dist(1,:) < distThresh);
    nInliers = sum(inliers_bin);
    
    if(nMaxIterations < nInliers)
        best_iteration = m;
        nMaxIterations = nInliers;
        ransacBestF = F;
%         inlier_indexes = find(inliers_bin);
%         outlier_indexes = find(~inliers_bin);
    end
    
end
fprintf('DONE\n');
fprintf('Total number of correspondences: %d \n', nCorrs);
fprintf('RANSAC best iteration %d ...Inliers: %d \n', best_iteration, nMaxIterations);


F = ransacBestF;

end