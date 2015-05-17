function [ Rt ] = estimateRt(E,K,corrPoint1,corrPoint2)
% ESTIMATERT - A camera pose Rt consistent with E
% 
% Estimate a relative camera pose Rt that is consistent
% with the essential matrix E and for which the 3D-point 
% that corresponds to corrPoint1 and corrPoint2 lies in front
% of both cameras.
% 
% [Rt] = ESTIMATERT(E, corrPoint1, corrPoint2, K)
% 
% From Algorithm 5 page 138 IREG by Klas Nordberg
% --------------------------------------------
% Input: An essential matrix E.
%        A pair of correspondence points corrPoint1 and corrPoint2.
%        Intrinsic camera matrix K.
% Output: Rotation and translation matrix Rt.

if is_homogeneous(corrPoint1) == false
    corrPointHomo1 = conv_to_homogeneous(corrPoint1);
    corrPointHomo2 = conv_to_homogeneous(corrPoint2);
end

% Algorithm 5 - IREG page 141, by Klas Nordberg.
W = [0 1 0;
    -1 0 0;
     0 0 1];

[U, ~, V] = svd(E);
t(:,1) = V(:,3);
t(:,2) = -V(:,3);

R(:,:,1) = V*W*U';
R(:,:,2) = V*W'*U';

% Set first camera as origin.
Rt1 = [1 0 0 0;
       0 1 0 0;
       0 0 1 0];

% Transform into C-normalized coordinates.
normCorrPoint1 = K\corrPointHomo1;
normCorrPoint2 = K\corrPointHomo2;

% Normalize to 2D-points
normCorrPoint1 = norml(normCorrPoint1, true);
normCorrPoint2 = norml(normCorrPoint2, true);

for tDirection = 1:2
    for RDirection = 1:2
        
        % Pick one of the four Rt:s.
        Rt2 = [R(:,:,RDirection) t(:,tDirection)];
        
        % Get 3D-point from Rt1 and Rt2.
        X_homogeneous = triangulate_linear(Rt1, Rt2, normCorrPoint1, normCorrPoint2);
        X = norml(X_homogeneous);

        X2 = R(:,:,RDirection)*X + t(:,tDirection);

        z1 = X(3);
        z2 = X2(3);

        % On one of the four cases, we get a point infront of our camera. 
        if (z1 > 0) && (z2 > 0)
            Rt = Rt2;
            break;
        end

    end % End of: for-loop RDirection
end % End of: for-loop tDirection
end

