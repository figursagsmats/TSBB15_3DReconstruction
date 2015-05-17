function [Rt] = align_camera_centered_view(Rt1, Rt2)
% ALIGN_CAMERA_CENTERED_VIEW Align the world coordinate system with the
% camera coordinate system of the first camera.
% 
% Equation (8.62) page 138 IREG, by Klas Nordberg
% 
% --------------------------------------------
% [Rt] = ALIGN_CAMERA_CENTERED_VIEW(Rt1,Rt2)
% Input: Camera poses Rt1 and Rt2 from two cameras.
% Output: Camera matrix Rt.
% Transformation: [R1|t1] becomes [I|0] and the relative transformation
% between the two cameras is [R|t].
% 

R1 = Rt1(1:3,1:3);
R2 = Rt2(1:3,1:3);

t1 = Rt1(:,end);
t2 = Rt2(:,end);

R = R2*R1';
t = R1'*(t2-t1);

Rt = [R t];

end