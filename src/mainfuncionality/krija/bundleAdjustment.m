%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%|                                                                         |
%| -= The bundle adjustment function inputs/outputs:                       |
%|   -> bundle_adjustment(Q, P, BK, PointsTable)  /  [Q, P, BK]            |
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
%|                                                                         | 
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |

function [P,Q] = bundleAdjustment(P,Q,BK)

    % Instantiate variables
    N_VIEWS = size(Q,2); 
    %Amount of views
    
    tempQ = zeros(3,4,N_VIEWS);
    for m=1:N_VIEWS
        tempQ(:,:,m) = Q(m).P;
    end
    
    N_POINTS = size(P,2); 
    %Amount of points
    
    X = P;
    %Saving the 3D-points to variable X (4xN)
    
    % Change the pointsTable to correct structure [N 2P]
    correspondence_points_2D = zeros(N_VIEWS, N_POINTS*2);
    correspondence_points_2D(:, 1:2:end) = BK(1:N_VIEWS,:,1);
    correspondence_points_2D(:, 2:2:end) = BK(1:N_VIEWS,:,2);
    
    % Put views and 3D-points in a 1D-vector for lsqnonlin
    vars = [ tempQ(:);  
               X(:)    ];
    
    % Visibility function
    % Following the steps in 18.4.3 IREG by Klas Nordberg
    % The J is a JacobPattern generated by the visibility function
    [W, J] = visibility_function(correspondence_points_2D, vars, N_VIEWS, N_POINTS);
    
    % The jacobian option for LSQNONLIN
    % The jacobian mask is the visibility matrix W
    options = optimset('JacobPattern',J,'Algorithm','trust-region-reflective');

    % Create the anonymous function dpp for lsqnonlin
    % The function will return the euclidian distance
    get_r = @(x)dpp(x, N_VIEWS, N_POINTS, W, correspondence_points_2D);

    % The initial guess
    start_guess = vars;

    % Minimize the error with lsqnonlin
    output = lsqnonlin(get_r, start_guess, [], [], options);
    
    % Extract the minimized Rt-matrix from output
    Q_min = zeros(size(tempQ));
    for m = 1:N_VIEWS
       Q_min(:,:,m) = reshape(output(1+((m-1)*12):12+((m-1)*12)),[3 4]);
    end

    % Extract the minimized 3D-points from output
    P_min = reshape(output(1+(N_VIEWS*12):end),[3 N_POINTS]);
    
    % Apply the new minimized 3D-points and Rt-matrices
    % TODO: What is BK?
    P = P_min;
    for m=1:N_VIEWS
        Q(m).P = Q_min(:,:,m);
    end
    
end

