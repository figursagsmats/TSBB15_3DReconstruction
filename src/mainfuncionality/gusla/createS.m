function [S,remainingCorrs1,remainingCorrs2] = createS(corrPts1,corrPts2,tableIndexes,P,BK)

    mask = tableIndexes~=-1;
    bkIndexes = tableIndexes(mask);
    S = struct();
    
    S.bkIndexes = bkIndexes;
    S.pts1 = corrPts1(:,mask);
    S.pts2 = corrPts2(:,mask);
    S.pts3d = P(:,bkIndexes);
    
    remainingCorrs1 = corrPts1(:,~mask);
    remainingCorrs2 = corrPts2(:,~mask);
    
end

