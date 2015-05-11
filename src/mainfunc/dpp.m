% The distance function

function r = dpp(vars, Xt)

% Cameras
C1 = reshape(vars(1:12),[3 4]);
% C2=[eye(3) zeros(3,1)];

% 3D positions
Np = size(Xt,2);
X = reshape(vars(13:end),[3 Np]);

Xtp = C1*[X;ones(1,Np)];
% Xip=C2*[X;ones(1,Np)];

% r = zeros(4,Np);

% r = zeros(2,Np);

r = sqrt((Xt(1,:)-Xtp(1,:)./Xtp(3,:)).^2+(Xt(2,:)-Xtp(2,:)./Xtp(3,:)).^2);
% r(2,:)=sqrt((Xi(1,:)-Xip(1,:)./Xip(3,:)).^2+(Xi(2,:)-Xip(2,:)./Xip(3,:)).^2);

% r(1,:)=Xt(1,:)-Xtp(1,:)./Xtp(3,:);
% r(2,:)=Xt(2,:)-Xtp(2,:)./Xtp(3,:);
% r(3,:)=Xi(1,:)-Xip(1,:)./Xip(3,:);
% r(4,:)=Xi(2,:)-Xip(2,:)./Xip(3,:);