function [ Rz ] = rotmatz( angle )

a = cosd(angle);
b = -sind(angle);
c = sind(angle);
d = a;

Rz = [a  b  0;
      c  d  0;
      0  0  1];
end
