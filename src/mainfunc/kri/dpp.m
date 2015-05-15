% The distance function

function r = dpp(vars, N_VIEWS, N_POINTS, W, Xt)

    % 3D positions
    Np = size(Xt,2);
    X = reshape(vars(((1+N_VIEWS)*12):end),[4 Np]);
    
    % r is a single vector of all the reprojection errors
    % there should be no zeros in this vector when the loops are finished
    r = zeros(N_VIEWS*(N_POINTS*2), 1);
     
    for m = 1:N_VIEWS
        Rt = reshape(vars(1+((m-1)*12):12+((m-1)*12)),[3 4]);
        
        start_of_x = (1+N_POINTS_2D*(m-1));
        end_of_x = (1+N_POINTS_2D*m);
        
        start_of_y = (2+N_POINTS_2D*(m-1));
        end_of_y = (2+N_POINTS_2D*m);
        
        % x
        r(start_of_x:2:end_of_x) = Xt(start_of_x):2:(end_of_x) - ( (Rt(1,:)*X) ./ (Rt(3,:)*X) );
        % y
        r(start_of_y:2:end_of_y) = Xt(start_of_y:2:end_of_y) - ( (Rt(2,:)*X) ./ (Rt(3,:)*X) );
    end
    
    % Erase all the points that are not visible
    r = r.*W; %This will multiply all errors with a 0 or 1
    r(r == 0) = []; %This will trim away all the zeros (not visible points) from the reprojection errors
    
end