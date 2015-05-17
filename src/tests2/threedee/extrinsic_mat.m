function [ Rt ] = extrinsic_mat(position,rotation)

%EXTRINSIC 1 
C = position;  % camera pos
xangle = rotation(1);
yangle = rotation(2);

Rc = rotmatx(xangle)*rotmaty(yangle);

R = Rc'
t = -R*C;

Rt = [R t;0 0 0 1];
end

