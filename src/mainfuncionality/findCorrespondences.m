function [ indexMap ] = findCorrespondences( ftPts1,ftPts2,img1,img2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ROI_SIZE = 15;

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

nPoints1 = size(ftPts1,2);
nPoints2 = size(ftPts2,2);

% these steps is just for clairty.
rows1 = ftPts1(2,:)-1; % cut_out_rois takes 0-based indexes...wtf..
cols1 = ftPts1(1,:)-1;
rows2 = ftPts2(2,:)-1;
cols2 = ftPts2(1,:)-1;

rois1 = cut_out_rois(img1, round(cols1), round(rows1), ROI_SIZE);
rois2 = cut_out_rois(img2, round(cols2), round(rows2), ROI_SIZE);

similarityMat = zeros(nPoints1, nPoints2);

for k = 1:nPoints1
    roi = rois1(:,k);
    for m = 1:nPoints2
        roger = rois2(:,m); %roy & roger hehehe
        similarityMat(k,m) = sqrt(sum((roi-roger).^2));
    end
end

[Y, ind1, ind2] = joint_min(similarityMat);
indexMap = [ind1, ind2]';

end

