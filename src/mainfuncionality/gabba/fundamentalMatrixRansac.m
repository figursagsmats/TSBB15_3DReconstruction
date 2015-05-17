function [F,inlinersIndexes] = fundamentalMatrixRansac(corrPts1,corrPts2)

F = eye(3,4);
inlinersIndexes = [1:length(corrPts1); 1:length(corrPts2)];

end

