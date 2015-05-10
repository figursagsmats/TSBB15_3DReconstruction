function [ht, hxy, hxz, hyz] = tensorshape3D(Lambda, EigVec, norm)
%  t = tensorshape3D(Lambda, EigVec, norm)
%  Visualizes the tensor according to the supplied eigenvalues
%  and eigenvectors.
%
%   Lambda: Eigenvalues sorted in descending order
%   EigVec: Corresponding eigenvectors
%   norm:   normalize with largest eigenvalue if true
%
%   Author: Johan Wiklund

if nargin ~= 3
  help tensorshape3D
  return
end

N=24;
if norm
  L0=1.0;
  L1=Lambda(2)/Lambda(1);
  L2=Lambda(3)/Lambda(1);
else
  L0=Lambda(1);
  L1=Lambda(2);
  L2=Lambda(3);
end

if L2 == 0
  L2 = eps;
end

% Define colormap
csphere=[0 1 0];
cdiscus=[1 1 0];
cspear=[1 0 0];
cgrid=[0 0 0];
colormap([csphere; cdiscus; cspear; cgrid]);

% Sphere controlled by L2
[X,Y,Z]= sphere(N);
X=L2*X;
Y=L2*Y;
Z=L2*Z;

% Discus controlled by L1
kant=L1/L2;
long0=1;
long1=N/2+1;
long2=N+1;
X(:,long0)= kant*X(:,long0);
X(:,long1)= kant*X(:,long1);
X(:,long2)= kant*X(:,long2);
Z(:,long0)= kant*Z(:,long0);
Z(:,long1)= kant*Z(:,long1);
Z(:,long2)= kant*Z(:,long2);

% Spear controlled by L0
Z(1,:)= -L0;
Z(N+1,:)= L0;

% Rotate shape
v1=EigVec(:,1)';
v2=EigVec(:,2)';
v3=EigVec(:,3)';

T=[v2;v3;v1];
NC=[X(:) Y(:) Z(:)]*T;
X=reshape(NC(:,1), N+1, N+1);
Y=reshape(NC(:,2), N+1, N+1);
Z=reshape(NC(:,3), N+1, N+1);

% Set colors
C=zeros([N,N]);
C(:,1)=1;
C(:,N/2)=1;
C(:,N/2+1)=1;
C(:,N)=1;
C(1,:)=2;
C(N,:)=2;

% Double longitudes at discontinuities
C1=N/2;
C2=N/2+1;
C3=N/2+2;
X=[X(:,1:2) X(:,2:C1) X(:,C1:C2) X(:,C2:C3) X(:,C3:N) X(:,N:N+1)]; 
Y=[Y(:,1:2) Y(:,2:C1) Y(:,C1:C2) Y(:,C2:C3) Y(:,C3:N) Y(:,N:N+1)]; 
Z=[Z(:,1:2) Z(:,2:C1) Z(:,C1:C2) Z(:,C2:C3) Z(:,C3:N) Z(:,N:N+1)]; 
C=[C(:,1:2) C(:,2:C1) C(:,C1:C2) C(:,C2:C3) C(:,C3:N) C(:,N)];

% Double latitudes at discontinuities
X=[X(1:2,:) ; X(2:N,:) ; X(N:N+1,:)];
Y=[Y(1:2,:) ; Y(2:N,:) ; Y(N:N+1,:)];
Z=[Z(1:2,:) ; Z(2:N,:) ; Z(N:N+1,:)];
C=[C(1,:) ; C(1:N,:) ; C(N,:)];

% Render surface
ht=surf(X,Y,Z,C);
caxis([0 3]);
set(ht, 'FaceLighting', 'phong')
%set(ht, 'EdgeColor', 'none');
set(ht, 'EdgeColor', cgrid);
%set(ht, 'AmbientStrength', 0.5);
%set(ht, 'DiffuseStrength', 0.8);
%set(ht, 'SpecularStrength', 1.0);
%set(ht, 'SpecularColorReflectance', 0.7);
set(ht, 'BackFaceLighting', 'lit');
%set(ht, 'FaceLighting', 'phong',...
%       'EdgeColor', [0.0 0.0 0.0],...
%       'AmbientStrength', 0.9,...
%       'DiffuseStrength', 0.8,...
%       'SpecularStrength', 1.0,...
%       'SpecularColorReflectance', 0.7,...
%       'BackFaceLighting', 'lit');
axis([-1 1 -1 1 -1 1]);
axis vis3d;
axis off;

% Render coordinate axis
v1=1.5*v1;
v2=1.5*v2;
patch([0 v1(1)], [0 v1(2)], [0 v1(3)], [1.0 1.0 1.0]);
patch([0 v2(1)], [0 v2(2)], [0 v2(3)], [1.0 1.0 1.0]);
as=0.95;
aw=0.01;
vert1=[-1.0 1.0 as  as  as  as]';
vert2=[ 0.0 0.0 aw  aw -aw -aw]';
vert3=[ 0.0 0.0 aw -aw -aw  aw]';
faces=[1 2 2; 2 3 4; 2 4 5; 2 5 6; 2 6 3];
% X-axis
hx=patch('Vertices', [vert1 vert2 vert3], 'Faces', faces, 'FaceColor', [0 0 0]);
set(hx, 'LineWidth', 1.0);
% Y-axis
hy=patch('Vertices', [vert2 vert1 vert3], 'Faces', faces, 'FaceColor', [0 0 0]);
set(hy, 'LineWidth', 1.0);
% Z-axis
hz=patch('Vertices', [vert2 vert3 vert1], 'Faces', faces, 'FaceColor', [0 0 0]);
set(hz, 'LineWidth', 1.0);

% Labels
text(1.1, 0, 0, '\bf X', 'HorizontalAlignment', 'Center');
text(0, 1.1, 0, '\bf Y', 'HorizontalAlignment', 'Center');
text(0, 0, 1.1, '\bf Z', 'HorizontalAlignment', 'Center');

% Axis planes
hold on
coord=[-1:0.1:1]'*ones(1,21);
zc=zeros([21,21]);
C=3*ones([21,21]);
% XY plane
X=coord;
Y=coord';
Z=zc;
hxy=mesh(X,Y,Z,C);
set(hxy, 'Visible', 'off');
% XZ plane
hxz=mesh(X,Z,Y,C);
set(hxz, 'Visible', 'off');
% YZ plane
hyz=mesh(Z,X,Y,C);
set(hyz, 'Visible', 'off');
hold off

% Camera properties
camproj('perspective');
camva(7);
rotate3d on;

% Light!
l1=light('Position',  v3);
l2=light('Position', -v3);
%l1=light('Position', 4*v3, 'Style', 'local');
%l2=light('Position', -4*v3, 'Style', 'local');
%l = camlight('left');
%r = camlight('right');
