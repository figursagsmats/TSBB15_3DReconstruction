%% INITIA
% clear
% clc
% K = calibrate_camera('../datasets/dino/calibration','*.ppm');
% [pointsTable,Ps] = load_dino_gt();
% [pts1, pts2] = get_correspondces(1,2,pointsTable);

%% Estimate essential matrix E
 
[corrPts1,corrPts2] = get_correspondces(1,2,pointsTable);
% Insert outliers
% pts1(:,1) = [430 280];
% pts1(:,20) = [435 145];
% pts1(:,25) = [405 440];
% pts1(:,30) = [1 576];
% pts1(:,35) = [10 10];
% F = estimate_fundamental_matrix(corrPts1,corrPts2);

if is_homogeneous(corrPts1) == false
    corrPts1 = conv_to_homogeneous(corrPts1);
    corrPts2 = conv_to_homogeneous(corrPts2);
end
E = EssentialMatrixFrom2DPoints(corrPts1, corrPts2, K);

epE = corrPts1(:,1)'*E*corrPts2(:,1)

nCorrs = length(corrPts1);
sumOfEp = 0;
for i = 1:nCorrs
    sumOfEp = sumOfEp + corrPts1(:,i)'*E*corrPts2(:,i);
end
sumOfEp


