function [epipolarMean, internalConstraint] = epipolar_constraint_E_test(E, corrPts1, corrPts2)
% EPIPOLAR_CONSTRAINT_E_TEST - Test if the epipolar constraint is satisfied
% for the essential matrix E. Also test if the internal constraint is
% satisfied. The test calculates the sum, mean and median of the constraints.
% --------------------------------------------
% Input: An essential matrix E.
%        Correspondence points corrPoint1 and corrPoint2. 2xN + homogeneous
% Output: epipolarMean - The mean of the epipolar constraint of all points
%         internalConstraint - Internal constraint, should be zero-matrix

% Check if homogeneous, convert if not
if is_homogeneous(corrPts1) == false
    corrPts1 = conv_to_homogeneous(corrPts1);
    corrPts2 = conv_to_homogeneous(corrPts2);
end

% Test the internal constraint with mean and median, 
% should return value close to zero.
internalConstraint = (E*E')*E - 0.5*trace(E'*E)*E;
totalIntConstraint = sum(internalConstraint(:));
internalConstraintMedian = mean(internalConstraint(:));
internalConstraintMean = mean(internalConstraint(:));

% Test the epipolar constraint for each corresponding point.
nCorrs = length(corrPts1);
epipolarConstraint = zeros(nCorrs,1);
for i = 1:nCorrs
    epipolarConstraint(i) = corrPts1(:,i)'*E*corrPts2(:,i);
end

% Test the mean and median of the epipolar constraint of all points.
epipolarMean = mean(epipolarConstraint);
epipolarMedian = median(epipolarConstraint);

assert(totalIntConstraint < 0.1, 'The internal constraint for E is not satisfied');
assert(internalConstraintMean < 0.1, 'The mean of the internal constraint for E is not satisfied');
assert(internalConstraintMedian < 0.1, 'The median of the internal constraint for E is not satisfied');
assert(epipolarMean < 1, 'The mean of epipolar constraint for E is not satisfied');
assert(epipolarMedian < 1, 'The median of epipolar constraint for E is not satisfied');

end