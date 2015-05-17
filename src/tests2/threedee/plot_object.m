function [] = plot_object( object, color)

nSurfaces = size(object.surfaces,1);
hold on
for i = 1:nSurfaces
    polygon = object.surfaces(i,:);
    polygon = polygon(polygon>0);
    
    v = object.verticies(:,polygon);
    X = v(1,:);
    Y = v(2,:);
    Z = v(3,:);
    C = ones(1,length(X))*color;
    h = fill3(X,Y,Z,C);
    h.FaceLighting = 'gouraud';
    
    
end
light
end

