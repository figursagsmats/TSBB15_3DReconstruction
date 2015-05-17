function [ Ry ] = rotmaty( angle )

a = cosd(angle);
b = sind(angle);
c = -sind(angle);
d = a;

Ry = [a  0  b;
      0  1  0;
      c  0  d];
end
