function [ Rt, inlierIndexes] = pnp( S,k)

%FORNOW
[BK,Ps] = loadDinoGt();

P = cell2mat(Ps(k));

[K,R,C] = DecomposeCameraMatrix(P);

Rt = R*C;
Rt = eye(3,4);

inlierIndexes = 1:length(S.bkIndexes);
end

