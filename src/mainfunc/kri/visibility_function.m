%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%|                                                                         |
%| The visibility function                                                 |
%| -= [W] = is_visibility(PointTable)                                      |
%|                                                                         |
%| Input: A 2D-pointTable that is (N, 2P), N is amount of views            |
%|                                        P is amount of 2D-points.        |
%|        Ex: There is 300 2D-points                                       |
%|            There is 10 camera views                                     |
%|            The PointTable should be size(PointTable) -> [10 600]        |
%|                                                                         |
%|        THE POINTTABLE NEEDS TO BE in the following structure:           |
%|                 Ex: [ x11 y11 x12 y12 ... ... x1P y1P;                  |
%|                       x21 y21 x22 y22 ... ... x2P y2P;                  |
%|                        |   |   |   |  ... ...  |   | ;                  |
%|                       xN1 yN1 xN2 yN2 ... ... xNP yNP ];                |
%|        This is described why in IREG, Section 12.3.2 by Klas Nordberg   |
%|                                                                         |
%| Output: W that is (N,2P) but only consists of ones (if visible) and     |
%| zeros (if not visible).                                                 |
%|                                                                         |
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |

function [W, J] = visibility_function(correspondence_points_2D, vars, N_VIEWS, N_POINTS)

    % If the position is equal to [-1; -1] it means that the point is not
    % visible in this view.
    
    % Create the W
    W = correspondence_points_2D > 0;
    W = double(W);
    W = W';
    W = W(:);
    
    % Initiate J
    J = ones(N_VIEWS*(N_POINTS*2), 1);
    J = J.*W;
    J(J == 0) = [];
    J = zeros(size(J,1), size(vars,1));
    J_temp = double(zeros(size(J,1)/2, size(vars,1)));
    
    % Extract 3D-points
    X = reshape(vars(1+(N_VIEWS*12):end),[3 N_POINTS]);
    
    % Instantiate variables for the mask 'Jacobpattern'
    cam_fill = ones(1,12);
    point_fill = ones(1,3);
    
    visible_2D_points = correspondence_points_2D(:,1:2:end);
    visible_2D_points = double(visible_2D_points > 0);
    
    % Create the mask for 'Jacobpattern'
    row_counter = 1;
    for m=1:N_POINTS
        
        visible_views = find(visible_2D_points(:,m));
        n_visible_views = sum(visible_2D_points(:,m));
        
        for n=1:n_visible_views
            C_start = 12*(visible_views(n)-1)+1;
            C_end = 12*(visible_views(n)-1)+12;  
            J_temp(row_counter, C_start:C_end) = cam_fill;
            
            P_step = N_VIEWS*12 + 1;
            P_start = P_step + (m-1)*3;
            P_end = P_step + (m-1)*3 + 2;
            J_temp(row_counter, P_start:P_end) = point_fill;
            
            row_counter = row_counter + 1;
        end
    end
    
    J(1:2:end,:) = J_temp;
    J(2:2:end,:) = J_temp;
    
    J = sparse(J);
    
end







