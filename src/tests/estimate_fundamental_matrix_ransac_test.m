img1 = images(1).img;
img2 = images(2).img;

corrList = zeros(size(pts1));

corrList(1,:) = 1:length(pts1);
corrList(2,:) = 1:length(pts1);

% These are very well-placed and suitable outliers for testing.
pts1(:,1) = [430 280];
pts1(:,20) = [435 145];
pts1(:,25) = [405 440];
pts1(:,30) = [1 576];
pts1(:,35) = [10 10];

% show_corresp(img1, img2, pts1, pts2, corrList);
%%
nIterations = ransac_number_of_trials(0.99, 0.5, 8);
[F_ransac, indexInliers] = estimate_fundamental_matrix_ransac(pts1, pts2, nIterations, 2);

sumEpipolarRans = 0;
% Epipolar constraint
for i = 1:length(pts1)
    
   if i ~= 1 && i ~= 20 && i ~= 25 && i ~= 30 && i ~= 35  % with outliers
        a = conv_to_homogeneous(pts1(:,i));
        b = conv_to_homogeneous(pts2(:,i));
        sumEpipolarRans = sumEpipolarRans + a'*F_ransac*b;
   end
end
sumEpipolarRans

sumEpipolarGS = 0;
F_gs = estimate_fundamental_matrix_gs(pts1(:,indexInliers), pts2(:,indexInliers), F_ransac);
for i = 1:length(pts1)
   if i ~= 1 && i ~= 20 && i ~= 25 && i ~= 30 && i ~= 35
        a = conv_to_homogeneous(pts1(:,i));
        b = conv_to_homogeneous(pts2(:,i));
        sumEpipolarGS = sumEpipolarGS + a'*F_gs*b;
   end
end
sumEpipolarGS

% Plot epipolar lines on img1 for points2
figure
imshow(img1, []);
hold on
 plot_eplines(F_gs, pts2(:,inlierIndexes), [0 1000 0  1000]);
 plot(pts1(1,indexInliers), pts1(2,indexInliers), '*g');