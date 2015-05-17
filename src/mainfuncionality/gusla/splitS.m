function [C,U] = splitS(inlierIndexes,S)

mask = zeros(size(S.bkIndexes));
mask(inlierIndexes) = 1;
mask = logical(mask);
C.bkIndexes = S.bkIndexes(mask);
C.pts1 = S.pts1(:,mask);
C.pts2 = S.pts2(:,mask);
C.pts3d = S.pts3d(:,mask);

U.bkIndexes = S.bkIndexes(~mask);
U.pts1 = S.pts1(:,~mask);
U.pts2 = S.pts2(:,~mask);
U.pts3d = S.pts3d(:,~mask);

end

