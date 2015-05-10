function [pointsTable,viewImageMapping,nViews] = rearrange_views(pointsTable)

nViews = size(pointsTable,1);

%TODO: implement
pointsTable;
for i =1:nViews
	viewImageMapping(i) = i;
end
end

