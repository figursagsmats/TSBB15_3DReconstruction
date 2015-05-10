function [ pts ] = get_view_pts( pointsTable,view )
%GET_VIEW_PTS gets points from a specific view and returns it in a
%convenient format.

pts(1,:) = pointsTable(view,:,1); %rows
pts(2,:) = pointsTable(view,:,2); %cols
end

