function tensorshape2D(Lambda, EigVec, Flag)
%  tensorshape(Lambda, EigVec, Flag)
%  Visualizes the tensor according to the supplied eigenvalues
%  and eigenvectors.
%
% The visualization is always scaled to fit the figure.
%
%   Lambda: Eigenvalues sorted in descending order
%   EigVec: Corresponding eigenvectors
%   Flag  : 0 for ellipse, non zero for circle+ellipse.
%
%Per-Erik Forssen, 1998

if nargin ~= 3
  help tensorshape2D
  return
end

samples=1000;
t=[1:samples]/samples*2*pi;

minor=Lambda(2);
major=Lambda(1);

if Flag
    circle=Lambda(2)*(cos(t)+sqrt(-1)*sin(t));
    minor=minor/10;
end

ellipse=[major*cos(t); minor*sin(t)];

%
% Rotate the ellipse
%

alpha=atan2(EigVec(1,1),EigVec(2,1));
rot=[cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];
ellipse=rot*ellipse;
ellipse=ellipse(1,:)+ellipse(2,:)*sqrt(-1);

hold off
%
% Plot ellipse and circle
%
if Flag
    plot(circle,'g');hold on
end
plot(ellipse,'r'),hold off

%
% Set general scale
%

axis([-Lambda(1) Lambda(1) -Lambda(1) Lambda(1)]);

