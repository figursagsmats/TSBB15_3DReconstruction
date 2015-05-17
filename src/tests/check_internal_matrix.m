%% INITIALIZATION
clear
clc
global images; 
images = load_dataset('../datasets/dino/images/','*.ppm');
[pointsTable,Ps] = load_dino_gt();

P = cell2mat(Ps(1));
lastK = DecomposeCameraMatrix(P);
K(:,:,1) = lastK;
for n = 2:length(Ps)
   
   P = cell2mat(Ps(n));
   K(:,:,n) = DecomposeCameraMatrix(P);
%    K(n) = K;
%    diff = abs(K - lastK)
%    n
%    sum(diff(:)) 
end


