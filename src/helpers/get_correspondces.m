function [ x1, x2, X ] = get_correspondces( viewIndex1,viewIndex2,pointsTable,P )
%GET_CORRESPONDENCES Corresping points between two view.

pts1 = get_view_pts(pointsTable,viewIndex1);
pts2 = get_view_pts(pointsTable,viewIndex2);

if(nargin < 4)
mask = (pts1(1,:) > -1) & (pts2(1,:) > -1);
x1 = pts1(:,mask);
x2 = pts2(:,mask);

else
    mask = (pts1(1,:) > -1) & (pts2(1,:) > -1) & (P(1,:) > -1);
    x1 = pts1(:,mask);
    x2 = pts2(:,mask);
    X = P(mask);
end
end

