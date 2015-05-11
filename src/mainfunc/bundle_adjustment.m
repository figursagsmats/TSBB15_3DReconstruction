%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%|                                                                         |
%| -= The bundle adjustment function inputs/outputs:                       |
%|   -> bundle_adjustment(Q, P, BK, PointsTable)  /  [Q, P, BK]                |
%|                                                                         |
%| * Minimizes the error projection from the 3D-point to the new view.     |
%| The error (epsilon) is a 2D-vector from the projected position to the   |
%| correct position.                                                       |
%|                                                                         |
%| * This function will minimize the error and update the matrices Q, P    |
%| and BK according to the bundle adjustment equation. As can be seen in:  |
%| '18.3 Incremental bundle adjustment, Introduction to Representations    |
%| and Estimation in Geometry by Klas Nordberg'.                           |
%|                                                                         |
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%|                                                                         | 
%| Q: The Rt of each camera view. Each Rt is saved as a 3x4 matrix in a    |
%| 3D-matrix Q.                                                            |
%|                                                                         |
%| P: The triangulated 3D-points from earlier views. The points are saved  |
%| in a 4D-matrix, P,  where every point has a x-,y- & z -coordinate.      |
%| Every point is saved as a 4x1 vector. P is a 4xN matrix.                |
%|                                                                         | 
%| BK: The bookkeeping table. Consisting of P, Q and the corresponding     |
%| 2D-points.                                                              |
%|                                                                         | 
%| PointsTable: A Table consisting of corresponding 2D-points (2xN).       |
%|                                                                         | 
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |

function [Q, P, BK] = bundle_adjustment(Q, P, BK, pointsTable)

    % Instantiate variables
    const N_VIEWS = size(Q,3); %Amount of views
    const N_POINTS = size(P,3); %Amount of points
    X = P; %Saving the 3D-points to variable X (4xN)
    Rt_min = zeros(size(Q));
    X_min = zeros(size(X));
    
    % The jacobian
    % Following the steps from Mathworks; Jacobian with LSQNONLIN:
    % http://se.mathworks.com/help/optim/ug/nonlinear-least-squares-with-full-jacobian.html?refresh=true
    
    % The minimization loop
    for k = 1:N_VIEWS
        
        % Visibility matrix in view k
        Wk = is_visibility(pointsTable(:,:,k)); 
        
        % Feature detected 2D-points on view k
        Xk = pointsTable(:,:,k); 
        
        % The Rt in view k
        Qk = Q(:,:,k); 
        
        % Put views and 3D-points in a 1D-vector for lsqnonlin
        vars = [Qk(:);  
                 X(:)];
        
        % Create the anonymous function dpp for lsqnonlin
        % The function will return the euclidian distance
        get_r = @(x)dpp(vars, Xk);
        
        % The initial guess
        start_guess = vars;
        
        % Minimize the error with lsqnonlin
        [output, ~] = lsqnonlin(get_r, start_guess);
        
        % Extract the minimized C-matrix from output
        Rt_min(:,:,k) = reshape(output(1:12), [3 4]);

        % Extract the minimized 3D-points from output
        count = 1;
        for m=13:3:length(output)
            X_min(:,:,count) = output(m:(m+2));
            count = count + 1;
        end
        
    end
end









