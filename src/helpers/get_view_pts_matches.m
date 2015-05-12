function [ pts ] = get_view_pts_matches( pointsTable,view )
%GET_VIEW_PTS gets points from a specific view and returns it in a
%convenient format.

mask = pointsTable(view,:,1) > -1;

pts(1,:) = pointsTable(view,mask,1); %rows
pts(2,:) = pointsTable(view,mask,2); %cols
end
