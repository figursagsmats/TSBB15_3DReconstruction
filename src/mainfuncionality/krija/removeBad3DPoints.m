%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%| If a 3D-point has made a large change in position OR its reprojection   |
%| errors in the views are large then remove the corresponding 3D point    |
%| from the table.                                                         |
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |


function [P,BK] = removeBad3DPoints(BK,Q,oldP,newP)


    %P = newP;
    
    % Choose a threshold for X movement in distance
    threshold_movement = 5.0;
    
    % Choose a threshold for reprojection errors
    threshold_r = 0.5;
    
    %% STEP 1 - Remove 3D-points that has made a large change in position
    
    % Calculate the distance difference in every dimension
    distance_diff_P = zeros(size(oldP));
    distance_diff_P(1,:) = (oldP(1,:) - newP(1,:)).^2;
    distance_diff_P(2,:) = (oldP(2,:) - newP(2,:)).^2;
    distance_diff_P(3,:) = (oldP(3,:) - newP(3,:)).^2;
    
    % Calculate the distance difference in every 3D-point
    distance_diff_XYZ = zeros(1, size(oldP,2));
    distance_diff_XYZ = sqrt(distance_diff_P(1,:) + distance_diff_P(2,:) + distance_diff_P(3,:));
    
    % Find the indices of the large distance difference
    large_indices = find(distance_diff_XYZ > threshold_movement);
    
    % Remove points from P
    temp_P = newP;
    temp_P(:,large_indices) = [];
    P = temp_P;
    
    % Remove columns from BK
    BK(:,large_indices,:) = [];
    
    %% STEP 2 - Make BK y_kj to -1 if their reprojection error is large 
    
    % Make 3D-points to homogenous
    X_new = conv_to_homogeneous(newP);
    
    % Create a visibility function W from BK
    W = double(BK(:,:,1) > 0);
    
    % Get number of views
    N_VIEWS = size(Q,2); 
    
    % Calculate the reprojection error in every point in every view
    r = zeros(size(BK));
    for m=1:N_VIEWS
        C = Q(m).P;
        r(m,:,1) = W(m,:).*(BK(m,:,1) - ( (C(1,:)*X_new) ./ (C(3,:)*X_new) ));
        r(m,:,2) = W(m,:).*(BK(m,:,2) - ( (C(2,:)*X_new) ./ (C(3,:)*X_new) ));
    end
    
    % Calculate reprojection euclidian distance
    r_distance = sqrt(r(:,:,1).^2 + r(:,:,2).^2);
    r_thresholded = double(r_distance < threshold_r);
    BK(:,:,1) = BK(:,:,1).*r_thresholded;
    BK(:,:,2) = BK(:,:,2).*r_thresholded;
    BK(BK == 0) = -1;
    
    r_thresholded_sum = sum(r_thresholded,1);
    outlier_removal_r_index = find(r_thresholded_sum > (N_VIEWS-1));
    
    % Remove columns from P
    P(:,outlier_removal_r_index) = [];
    
    % Remove columns from BK
    BK(:,outlier_removal_r_index,:) = [];
    
end






