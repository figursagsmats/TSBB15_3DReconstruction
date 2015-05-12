function [ view ] = find_which_gt_view( featurePts )
view = -1;
pointsTableGT = load_dino_gt();
%Just figure out which view the points belonged to in GT.
for i = 1:size(pointsTableGT,1) % iterate over views
    gtPts = get_view_pts(pointsTableGT,i);
    nMatchingElements = sum(sum(ismember(featurePts,gtPts)));
    if(nMatchingElements == numel(featurePts))
        view = i;
        break;
    end
    
end
end

