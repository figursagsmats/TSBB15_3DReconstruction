%% INITIALIZATION
clear
clc
global images; 
images = load_dataset('../datasets/dino/images/','*.ppm');

K = calibrate_camera('../datasets/dino/calibration','*.ppm');
[pointsTable,Ps] = load_dino_gt();
[corrPts1,corrPts2] = get_correspondces(1,2,pointsTable);
%% Estimate essential matrix E - TEST FOR INTERNAL AND EPIPOLAR CONSTRAINT

% Insert outliers
% corrPts1(:,1) = [430 280];
% corrPts1(:,20) = [435 145];
% corrPts1(:,25) = [405 440];
% corrPts1(:,30) = [1 576];
% corrPts1(:,35) = [10 10];
F = estimate_fundamental_matrix(corrPts1, corrPts2);

if is_homogeneous(corrPts1) == false
    corrPts1 = conv_to_homogeneous(corrPts1);
    corrPts2 = conv_to_homogeneous(corrPts2);
end

%%
% E_diego = EssentialMatrixFrom2DPoints(corrPts1, corrPts2, K);
E = estimate_essential_matrix(F,K);

normCorrPts1 = NormalizedCoordinates(corrPts1, K);
normCorrPts2 = NormalizedCoordinates(corrPts2, K);

normCorrPts1 = norml(normCorrPts1);
normCorrPts2 = norml(normCorrPts2);

epipolar_constraint_E_test(E, corrPts1, corrPts2);
% epipolar_constraint_E_test(E_diego, normCorrPts1, normCorrPts2);
