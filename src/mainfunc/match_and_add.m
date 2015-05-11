function [ pointsTable ] = match_and_add( featurePts,pointsTable )

nFtPts = length(featurePts);
nViews = size(pointsTable,1);
if(nargin < 2) %no pointsTable input means first view.
    pointsTable = zeros(1,nFtPts,2);
    pointsTable(1,:,1) = featurePts(1,:);
    pointsTable(1,:,2) = featurePts(2,:);
else
    
    %FORNOW: this is ridiculus cause we compare GT with GT...
    
    %lets find
    
    ptsFromLastView = get_view_pts(pointsTable,nViews);
    for i = 1:nFtPts
        for j = 1:length(ptsFromLastView)
            if(featurePts(:,i) == ptsFromLastView(:,j)) %
                pointsTable(nViews+1,j,1) = featurePts(1,i); % row
                pointsTable(nViews+1,j,2) = featurePts(2,i); % col
            else
                
            end
        end
    end
end


end

