%% INITIALIZATION
clear
clc
global images;
images = load_dataset('../datasets/dino/images/','*.ppm');

K = calibrate_camera('../datasets/dino/calibration','*.ppm');
[pointsTable,Ps] = load_dino_gt();
[corrPts1,corrPts2] = get_correspondces(1,2,pointsTable);

corrPoint1 = corrPts1(:,1);
corrPoint2 = corrPts2(:,1);

if is_homogeneous(corrPoint1) == false
    corrPointHomo1 = conv_to_homogeneous(corrPoint1);
    corrPointHomo2 = conv_to_homogeneous(corrPoint2);
    
    corrPts1 = conv_to_homogeneous(corrPts1);
    corrPts2 = conv_to_homogeneous(corrPts2);
end

E = EssentialMatrixFrom2DPoints(corrPts1, corrPts2, K);

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
normCorrPoint1 = K\corrPointHomo1;
normCorrPoint2 = K\corrPointHomo2;

% Normalize to 2D-points
normCorrPoint1 = norml(normCorrPoint1, true);
normCorrPoint2 = norml(normCorrPoint2, true);

%% TEST FOR THE 4 CASES OF Rt

nCorrectCasesLinear = 0;
nCorrectCasesOptimal = 0;
    
for tDirection = 1:2
    for RDirection = 1:2

        % Pick an Rt.
        Rt2 = [R(:,:,RDirection) t(:,tDirection)];

        % Get 3D-point for Rt1 and Rt2.
        X_optimal_homogeneous = triangulate_optimal(Rt1, Rt2, normCorrPoint1, normCorrPoint2);
        X_linear_homogeneous = triangulate_linear(Rt1, Rt2, normCorrPoint1, normCorrPoint2);
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
        else if correct_case_optimal == true
                fprintf('The correct number of cases for optimal is: tDirection = %d and RDirection = %d \n', tDirection, RDirection);
            end
        end % End of: if

    end % End of: for-loop RDirection
end % End of: for-loop tDirection

