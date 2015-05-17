function [isSatisfied] = satisfies_epipolar_constraint(E, y1, y2)
% SATISFIES_EPIPOLAR_CONSTRAINT Check if the epipolar constraint is satisfied.
% 
% Check the constraint y1'*E*y2 = 0. Where y1 and y2 are corresponding
% points.
% 
% [isSatisfied] = SATISFIES_EPIPOLAR_CONSTRAINT(E, y1, y2)
% 
% From Equation (8.63) page 138 IREG by Klas Nordberg 
% --------------------------------------------
% Input: E - essential matrix
%        y1 & y2 - Corresponding points
% Output: isSatisfied - true/false or 1/0

const THRESHHOLD = 0.2;

if is_homogeneous(y1) == false
    y1 = conv_to_homogeneous(y1);
    y2 = conv_to_homogeneous(y2);
end

% Convert to C-normalized coordinates.
y1 = K\y1;
y2 = K\y2;

% Normalize to homogeneous coordinates.
y1 = norml(y1, true);
y2 = norml(y2, true);
    
epipolarConstraint = y1'*E*y2;

if epipolarConstraint < THRESHHOLD
    isSatisfied = true;
else
    isSatisfied = false;
end

end