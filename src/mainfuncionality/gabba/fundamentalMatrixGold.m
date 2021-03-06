function [F] = fundamentalMatrixGold(FInitial,corrPts1,corrPts2)
% ESTIMATE_FUNDAMENTAL_MATRIX_GS Fundamental matrix F
% 
% Use Gold Standard algorithm to estimate the fundamental matrix F.
% 
% [F] = ESTIMATE_FUNDAMENTAL_MATRIX_GS(corrPts1, corrPts2, F)
% 
% From Algorithm 24 page 251 IREG by Klas Nordberg
% --------------------------------------------
% Input: Correspondence points - 2xN
%        Fundamental matrix F = 3x3
%        corrPts1 = 2xN
%        corrPts2 = 2xN
% Output: Fundamental matrix F.

nCorrs = length(corrPts1);
% Get camera matricies - C2 = [I | O](?)
[C1,C2] = fmatrix_cameras(FInitial);

%  Triangulate all points
X_homogenous = zeros(4,nCorrs);
for k = 1:nCorrs
    x1 = corrPts1(:,k);
    x2 = corrPts2(:,k);
    X_homogenous(:,k) = triangulate_optimal(C1,C2,x1,x2);
end

% Normalization to homogenous coordinates
X = norml(X_homogenous);

% Pack the data into a vector of 12 + 3*n parameters
vars = [C2(:); X(:)];
Xt = corrPts1;
Xi = corrPts2;

% Cost-function fmatrix_residuals_gs, 
% returns r = [deltaX1; deltaY1; deltaX2; deltaY2]
% Create function handle - input parameter is x now
get_r = @(x)fmatrix_residuals_gs(x,Xt,Xi);

% We guess an intial condition as our camera paramaters and 
% triangulated 3D-points.
start_guess = vars;
[output] = lsqnonlin(get_r, start_guess);

% Get the local minima of the camera paramters.
C_min = output(1:12);
C_min = reshape(C_min, [3 4]);

% Get fundamental matrix from best C
F = fmatrix_from_cameras(C_min, C2);
end

