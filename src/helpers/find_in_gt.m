function [ indexes, view ] = find_in_gt( featurePts )

view = -1;
pointsTableGT = load_dino_gt();
indexes = ones(1,size(featurePts,2))*-1;
%Just figure out which view the points belonged to in GT.
for i = 1:size(pointsTableGT,1) % iterate over views
    gtPts = get_view_pts(pointsTableGT,i);
    nMatchingElements = sum(sum(ismember(featurePts,gtPts)));
    
    
    if(nMatchingElements == numel(featurePts))
        %we have the right view now. lets get indexes
        view = i;
        for j = 1:length(featurePts)

            for k = 1:length(gtPts)
                x = featurePts(:,j);
                y = gtPts(:,k); 
                if((x == y) & (x ~= -1)) %
                    indexes(j) = k;
                end
            end
        end
        break;
    end
end

end

