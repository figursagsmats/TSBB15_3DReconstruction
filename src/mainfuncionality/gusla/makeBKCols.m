function [ newBKCols ] = makeBKCols(BK,pts1,pts2,row1,row2)

nColsToAdd = size(pts1,2);
nRowsBK = size(BK,1);

newBKCols = ones(nRowsBK,nColsToAdd,2)*-1;

newBKCols(row1,:,1) = pts1(1,:);
newBKCols(row1,:,2) = pts2(2,:);

newBKCols(row2,:,1) = pts2(1,:);
newBKCols(row2,:,2) = pts2(1,:);
end

