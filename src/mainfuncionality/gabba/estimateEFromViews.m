function E = estimateEFromViews(Rt1, Rt2)
% ESTIMATEEFROMVIEWS Essential matrix E from 2 camera poses.
% 
% Align the world coordinate system with the first camera.
% Camera pose for first camera is now [I|0] and [R|t] for second camera.
% 
% [E] = ESTIMATEEFROMVIEWS(Rt1, Rt2)
% 
% From Equation (8.65) page 139 IREG by Klas Nordberg
% --------------------------------------------
% Input: Two camera poses Rt1 and Rt2.
% Output: Essential matrix E.
Rt = align_camera_centered_view(Rt1,Rt2);

% Extract 3x3 rotation matrix.
R = Rt(1:3,1:3);

% Extract translation vector t.
t = Rt(:,end);

% Convert t to a skew-symmetric matrix to able to use matrix product as cross-product.
tx = conv_to_skew_sym(t);
E = R'*tx;

end

