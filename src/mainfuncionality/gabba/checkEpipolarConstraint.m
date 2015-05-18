function [x1,x2] = checkEpipolarConstraint(pts1,pts2, E, K)
% CHECKEPIPOLARCONSTRAINT Check if the epipolar constraint is satisfied.
% 
% Check the constraint y1'*E*y2 = 0. Where y1 and y2 are corresponding
% points.
% 
% [isSatisfied] = CHECKEPIPOLARCONSTRAINT(E, y1, y2)
% 
% From Equation (8.63) page 138 IREG by Klas Nordberg 
% --------------------------------------------
% Input: E - essential matrix
%        y1 & y2 - Corresponding points
% Output: isSatisfied - true/false or 1/0

nPoints = size(pts1,2);



% ==========FILL WITH -1????===============
% if nPoints == 0 return error not a single point satisfied

THRESHHOLD = 0.2;

if is_homogeneous(pts1) == false
    pts1 = conv_to_homogeneous(pts1);
    pts2 = conv_to_homogeneous(pts2);
end

x1 = [];
x2 = [];
count = 1;
for n = 1:nPoints
    y1 = pts1(:,n);
    y2 = pts2(:,n);
    
    % Convert to C-normalized coordinates.
    y1 = K\y1;
    y2 = K\y2;
    
    % Normalize to homogeneous coordinates.
    y1 = norml(y1, true);
    y2 = norml(y2, true);

    epipolarConstraint = y1'*E*y2;

    if epipolarConstraint < THRESHHOLD
        x1(:,count) = pts1(:,n);
        x2(:,count) = pts2(:,n);
        count = count + 1;
    end
    
end
if(~isempty(x1))
    x1 = norml(x1, false);
    x2 = norml(x2, false);
end


end