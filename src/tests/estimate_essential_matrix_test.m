%% INITIALIZATION
clear
clc
K = calibrate_camera('../datasets/dino/calibration','*.ppm');
[pointsTable,Ps] = load_dino_gt();
[corrPts1,corrPts2] = get_correspondces(1,2,pointsTable);
%% Estimate essential matrix E - TEST FOR INTERNAL AND EPIPOLAR CONSTRAINT

% Insert outliers
% pts1(:,1) = [430 280];
% pts1(:,20) = [435 145];
% pts1(:,25) = [405 440];
% pts1(:,30) = [1 576];
% pts1(:,35) = [10 10];
F = estimate_fundamental_matrix(corrPts1,corrPts2);

E = K'*F*K;

if is_homogeneous(corrPts1) == false
    corrPts1 = conv_to_homogeneous(corrPts1);
    corrPts2 = conv_to_homogeneous(corrPts2);
end

E2 = EssentialMatrixFrom2DPoints(corrPts1, corrPts2, K);

epipolar_constraint_E_test(E, corrPts1, corrPts2);
epipolar_constraint_E_test(E2, corrPts1, corrPts2);
