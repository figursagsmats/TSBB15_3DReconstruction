function [featurePts, bkIndexes] = getFeaturePts(view,BK);

bkIndexes = find(BK(view,:,1) ~= -1);

featurePts(1,:) = BK(view,bkIndexes,1); %rows
featurePts(2,:) = BK(view,bkIndexes,2); %cols

end

