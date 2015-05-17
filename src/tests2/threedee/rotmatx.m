function [ Rx ] = rotmatx( angle )

a = cosd(angle);
b = -sind(angle);
c = sind(angle);
d = a;

Rx = [1  0  0;
     0  a  b;
     0  c  d];

end

