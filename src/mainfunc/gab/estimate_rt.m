function [ Rt ] = estimate_rt(E, corrPoint1, corrPoint2 )
% CALCULATE_Rt - A camera pose Rt consistent with E
% 
% Calculate a relative camera pose Rt that is consistent
% with the essential matrix E and for which the 3D-point 
% that corresponds to corrPoint1 and corrPoint2 lies in front
% of both cameras.
% --------------------------------------------
% Input: An essential matrix E.
%        A pair of correspondence points corrPoint1 and corrPoint2.
%        with dimension: 2x1
% Output: Rotation and translation matrix Rt.
% 

W = [0 1 0;
    -1 0 0;
     0 0 1];

[U, ~, V] = svd(E);
t(:,1) = V(:,3);
t(:,2) = -V(:,3);


R(:,:,1) = V*W*U';
R(:,:,2) = V*W'*U';

Rt1 = [1 0 0 0;
       0 1 0 0;
       0 0 1 0];

  
for tDirection = 1:2
    for RDirection = 1:2
        
        % Pick an Rt.
        Rt2 = [R(:,:,RDirection) t(:,tDirection)];
        % Get 3D-point for Rt1 and Rt2, where Rt1 is unit
        X_homogenous = triangulate_optimal(Rt1, Rt2, corrPoint1, corrPoint2);
        X = norml(X_homogenous);
        
        X2 = R(:,:,RDirection)*X + t(:,tDirection);
        
        z1 = X(3);
        z2 = X2(3);
        % On one of the four cases, we get a point
        % infront of our cameras. Save the Rt for that case.
        if (z1 > 0) && (z2 > 0)
            Rt = Rt2;
        end
    end
end

end

