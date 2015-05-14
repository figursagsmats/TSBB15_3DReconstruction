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

corrPts1 = NormalizedCoordinates(corrPtsHomo1, K);
corrPts2 = NormalizedCoordinates(corrPtsHomo2, K);

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

for tDirection = 1:2
    for RDirection = 1:2
        
        % Pick an Rt.
        Rt2 = [R(:,:,RDirection) t(:,tDirection)];
        % Get 3D-point for Rt1 and Rt2, where Rt1 is unit
        X_homogeneous = triangulate_optimal(Rt1, Rt2, corrPts1, corrPts2);
        X = norml(X_homogeneous);
        
        X2 = R(:,:,RDirection)*X + t(:,tDirection);
        
        % On one of the four cases, we get a point
        % infront of our cameras. Save the Rt for that case.
        if (X(3) > 0) && (X2(3) > 0)
            fprintf('It was tDirection %d and RDirection %d ', tDirection, RDirection);
            Rt = Rt2;
        end
    end
end

