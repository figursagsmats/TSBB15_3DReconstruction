clear
close all
clc
load BADino2

tic
points1 = newPoints2D{1};
points2 = newPoints2D{2};
nPoints = length(points1);

% Extract internal camera matrix K
% C1 = newPs{1};
% K1 = 1(1:3,1:3);
% 
% C2 = newPs{2};
% K2 = C2(1:3,1:3);

% indx1 = (points1 > 0);
% indx2 = (points2 > 0);

% a = indx1 == indx2


count = 1;
for i = 1:nPoints
        if (points1(1,i) > 0) && (points2(1,i) > 0)
            corrpts1(:,count) = points1(:,i);
            corrpts2(:,count) = points2(:,i);
            count = count + 1;
        end
end

% E = calculate_essential_matrix(corrpts1, corrpts2, K1, K2);

toc











