function [ matches ] = gt_corr(newPts,oldPts)
% Finds correspondeces between feature points in two images.
% treats -1 as no point and ignores is. This makes it easier 
% to keep indexing in order.
%
% Inputs:
%       x1: 2xN array of points in first image
%       x2: 2xN array of points in seconds image
%       I1: first image
%       I2: second image
% Outsputs:
%       matches:  a list of indexes with the same length as newPts
%       describing corresponding indexes in oldPts

%FORNOW: lets just use GT...
ind1 = find_in_gt(newPts);
ind2 = find_in_gt(oldPts); 
matches = zeros(1,length(ind2));
for i = 1:length(ind1);
    for j = 1:length(ind2)
        if((ind1(i) == ind2(j)) & ((ind1(i) ~=-1) & (ind2(j) ~=-1)))
            %we that newPoints(ii) mathces oldPoints(j)
            matches(i) = j;
        end
    end
end


end

