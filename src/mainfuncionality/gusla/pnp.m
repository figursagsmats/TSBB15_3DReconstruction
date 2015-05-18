function [ Rt, inlierIndexes] = pnp(S ,K)


corrPts1=S.pts1;
corrPts2=S.pts2;
pts3d = S.pts3d;

nPoints= size(corrPts1,2);
if(nPoints > 9)
    [F,inlinersIdxMap] = fundamentalMatrixRansac(corrPts1,corrPts2);
    [inlierPts3d,inlierPts2d] = spliceConcensus(pts3d,corrPts2,inlinersIdxMap);
    inlierIndexes = inlinersIdxMap;

else
    fprintf('WARNING: not enough points in S to perform RANSAC\n');
    inlierPts3d = pts3d;
    inlierPts2d = corrPts2;
    inlierIndexes = 1:nPoints;
end

x3d_h = [inlierPts3d' ones(size(inlierPts3d,2),1)];
x2d_h = [inlierPts2d' ones(size(inlierPts2d,2),1)];
A = K;

[Rp,Tp,Xc,sol]=efficient_pnp_gauss(x3d_h,x2d_h,A);

Rt = [Rp Tp];
end

