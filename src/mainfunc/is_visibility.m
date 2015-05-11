% The visibility function
% Input: PointTable, k, j
% Output: 1 if visible, 0 if not visible

function [W] = is_visibility(PointTable)

    % If the position is equal to [-1; -1] it means that the point is not
    % visible in this view.
    W = PointTable > 0;
    
end