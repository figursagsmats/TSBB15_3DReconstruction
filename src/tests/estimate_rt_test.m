%% INITIALIZATION
clear
clc
global images;
images = load_dataset('../datasets/dino/images/','*.ppm');

K = calibrate_camera('../datasets/dino/calibration','*.ppm');
[pointsTable,Ps] = load_dino_gt();
[corrPts1,corrPts2] = get_correspondces(1,2,pointsTable);

%% TEST FOR RT FROM ESSENTIAL MATRIX E.

if is_homogeneous(corrPts1) == false
    corrPtsHomo1 = conv_to_homogeneous(corrPts1);
    corrPtsHomo2 = conv_to_homogeneous(corrPts2);
end

E = EssentialMatrixFrom2DPoints(corrPtsHomo1, corrPtsHomo2, K);

W = [0 1 0;
    -1 0 0;
    0 0 1];

[U, ~, V] = svd(E);
t(:,1) = V(:,3);
t(:,2) = -V(:,3);


R(:,:,1) = V*W*U';
R(:,:,2) = V*W'*U';

Rt1 = [1 0 0 0;
    0 1 0 0;
    0 0 1 0];

corrPoint1 = corrPtsHomo1(:,1);
corrPoint2 = corrPtsHomo2(:,1);

for tDirection = 1:2
    for RDirection = 1:2
        
        % Pick an Rt.
        Rt2 = [R(:,:,RDirection) t(:,tDirection)];
        
        % Get 3D-point for Rt1 and Rt2.
        X_optimal_homogeneous = triangulate_optimal(Rt1, Rt2, corrPoint1, corrPoint2);
        X_linear_homogeneous = triangulate_linear(Rt1, Rt2, corrPoint1, corrPoint2);
        [worldCoords, reproj] = triangulate(corrPts1(:,1)', corrPts2(:,1)', Rt1', Rt2');
        
        X_linear = norml(X_linear_homogeneous);
        X_optimal = norml(X_optimal_homogeneous);
        worldCoords = worldCoords';
        
        correct_case_linear = test_rt_direction(R, t, X_linear, RDirection, tDirection);
        correct_case_optimal = test_rt_direction(R, t, X_optimal, RDirection, tDirection);
        correct_case_WC = test_rt_direction(R, t, worldCoords, RDirection, tDirection);
        
        if correct_case_linear == true
            fprintf('The correct case for linear is: tDirection %d and RDirection %d \n', tDirection, RDirection);
            Rt = Rt2;
        else if correct_case_optimal == true
                fprintf('The correct case for optimal is: tDirection %d and RDirection %d \n', tDirection, RDirection);
            else if correct_case_WC == true
                    fprintf('The correct case for worldCoords is: tDirection %d and RDirection %d \n', tDirection, RDirection);
                end
            end
        end % End of: if
    end % End of for-loop
end