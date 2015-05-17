img1 = images(1).img;
img2 = images(2).img;

corrList = zeros(size(pts1));

corrList(1,:) = 1:length(pts1);
corrList(2,:) = 1:length(pts1);

% These are very well-placed and suitable outliers for testing.
% pts1(:,1) = [430 280];
% pts1(:,20) = [435 145];
% pts1(:,25) = [405 440];
% pts1(:,30) = [1 576];
% pts1(:,35) = [10 10];

% show_corresp(img1, img2, pts1, pts2, corrList);

F_ransac = estimate_fundamental_matrix_ransac(pts1, pts2, 5000, 3);
sumEpipolarRans = 0;

% Epipolar constraint
for i = 1:length(pts1)
    
%    if i ~= 1 && i ~= 20 && i ~= 25 && i ~= 30 && i ~= 35  % with outliers
        a = conv_to_homogeneous(pts1(:,i));
        b = conv_to_homogeneous(pts2(:,i));
        sumEpipolarRans = sumEpipolarRans + a'*F_ransac*b;
%    end
end
sumEpipolarRans

F_gs = estimate_fundamental_matrix_gs(pts1,pts2,F_ransac);
for i = 1:length(pts1)
%    if i ~= 1 && i ~= 20 && i ~= 25 && i ~= 30 && i ~= 35
        a = conv_to_homogeneous(pts1(:,i));
        b = conv_to_homogeneous(pts2(:,i));
        sumEpipolarRans = sumEpipolarRans + a'*F_gs*b;
%    end
end
sumEpipolarRans