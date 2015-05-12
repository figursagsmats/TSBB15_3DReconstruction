function [ pointsTable ] = match_and_add( featurePts,pointsTable,images)
% Calculates correspondes between previous images and the new image and
% adds the view to pointsTable


%FORNOW: just select the correct row in gt and add it
gtPointsTable = load_dino_gt();
if(nargin < 2) %no pointsTable input means first view.
    
    pointsTable = gtPointsTable(1,:,:);
else
   viewInGt = find_which_gt_view(featurePts)
   pointsTable(viewInGt,:,:) = gtPointsTable(viewInGt,:,:);
end


end

