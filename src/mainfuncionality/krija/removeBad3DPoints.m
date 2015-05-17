%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%| If a 3D-point has made a large change in position OR its reprojection   |
%| errors in the views are large then remove the corresponding 3D point    |
%| from the table.                                                         |
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |


function [P,BK] = removeBad3DPoints(BK,Q,oldP,newP)

    %% STEP 1 - Remove 3D-points that has made a large change in position
    
    % Choose a threshold
    threshold = 0.5;

    % Calculate the distance difference in every dimension
    distance_diff_P = zeros(size(oldP));
    distance_diff_P(1,:) = (oldP(1,:) - newP(1,:)).^2;
    distance_diff_P(2,:) = (oldP(2,:) - newP(2,:)).^2;
    distance_diff_P(3,:) = (oldP(3,:) - newP(3,:)).^2;
    
    % Calculate the distance difference in every 3D-point
    distance_diff_XYZ = zeros(1, size(oldP,2));
    distance_diff_XYZ = sqrt(distance_diff_P(1,:) + distance_diff_P(2,:) + distance_diff_P(3,:));
    
    % Find the indices of the large distance difference
    large_indices = find(distance_diff_XYZ > threshold);
    
    % Remove points from P
    temp_P = newP;
    temp_P(:,large_indices) = [];
    P = temp_P;
    
    % Remove columns from BK
    BK(:,large_indices,:) = [];
    
    %% STEP 2 - Remove 3D-points if their reprojection error is large 
    
    
end






