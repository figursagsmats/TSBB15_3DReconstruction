function [ P ] = triangulateShit(Q1,Q2,corrPts1,corrPts2)

nPoints = size(corrPts1,2);

[BK,Ps] = loadDinoGt();

C1 = Q1;
C2 = Q2;

C1 = cell2mat(Ps(1));
C2 = cell2mat(Ps(2));
P = zeros(3,nPoints);
for i = 1:nPoints
    y1 = corrPts1(:,i);
    y2 = corrPts2(:,i);
    Pn = triangulate_optimal(C1,C2,y1,y2);
    
    P(:,i) = norml(Pn);
end

end

