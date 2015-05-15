%% INITIALIZATION
clear
clc
global images;
images = load_dataset('../datasets/dino/images/','*.ppm');

K = calibrate_camera('../datasets/dino/calibration','*.ppm');
[pointsTable,Ps] = load_dino_gt();
[corrPts1,corrPts2] = get_correspondces(1,2,pointsTable);

if is_homogeneous(corrPts1) == false
    corrPtsHomo1 = conv_to_homogeneous(corrPts1);
    corrPtsHomo2 = conv_to_homogeneous(corrPts2);
end

E = EssentialMatrixFrom2DPoints(corrPtsHomo1, corrPtsHomo2, K);

% Equation 8.80, IREG by Klas Nordberg
W = [0 1 0;
    -1 0 0;
    0 0 1];

[U, ~, V] = svd(E);

t(:,1) = V(:,3);
t(:,2) = -V(:,3);

R(:,:,1) = V*W*U';
R(:,:,2) = V*W'*U';

% Set first camera as origin.
Rt1 = [1 0 0 0;
       0 1 0 0;
       0 0 1 0];

% Transform into C-normalized coordinates.
normCorrPts1 = K\corrPtsHomo1;
normCorrPts2 = K\corrPtsHomo2;

% Normalize to 2D-points
normCorrPts1 = norml(normCorrPts1, true);
normCorrPts2 = norml(normCorrPts2, true);

%% TEST FOR THE 4 CASES OF Rt

nCorrectCasesLinear = 0;
nCorrectCasesOptimal = 0;
for n = 1:length(corrPts1)
    
    for tDirection = 1:2
        for RDirection = 1:2

            % Pick an Rt.
            Rt2 = [R(:,:,RDirection) t(:,tDirection)];

            % Get 3D-point for Rt1 and Rt2.
            X_optimal_homogeneous = triangulate_optimal(Rt1, Rt2, normCorrPts1(:,n), normCorrPts2(:,n));
            X_linear_homogeneous = triangulate_linear(Rt1, Rt2, normCorrPts1(:,n), normCorrPts2(:,n));
%             [worldCoords, reproj] = triangulate(corrPts1', corrPts2', Rt1', Rt2');

            X_linear = norml(X_linear_homogeneous);
            X_optimal = norml(X_optimal_homogeneous);
%             worldCoords = worldCoords';

            correct_case_linear = rt_direction_test(R, t, X_linear, RDirection, tDirection, 'linear');
            correct_case_optimal = rt_direction_test(R, t, X_optimal, RDirection, tDirection, 'optimal');
            fprintf('============================= \n');

            if correct_case_linear == true
                fprintf('The correct number of cases for linear is: tDirection = %d and RDirection = %d \n', tDirection, RDirection);
                Rt = Rt2;
                nCorrectCasesOptimal = 0;
            else if correct_case_optimal == true
                    fprintf('The correct number of cases for optimal is: tDirection = %d and RDirection = %d \n', tDirection, RDirection);
                    nCorrectCasesLinear = nCorrectCasesLinear + 1;
                end
            end % End of: if

        end % End of: for-loop RDirection
    end % End of: for-loop tDirection
end % End of: for-loop nPoints

fprintf('The number of correct cases for linear: %d of %d \n', nCorrectCasesLinear, length(corrPts1));
fprintf('The number of correct cases for optimal: %d of %d \n', nCorrectCasesOptimal, length(corrPts1));

