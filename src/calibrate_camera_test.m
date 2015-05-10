
[ pointsTable, Ps ] = load_dino_gt();

P = cell2mat(Ps(1))

[K,r,c] = DecomposeCameraMatrix(P);

R = -r;
A = [eye(3) c];

B = [R;0 0 0];
d = [0;0;0;1];
B = [B d];

K*A*B

