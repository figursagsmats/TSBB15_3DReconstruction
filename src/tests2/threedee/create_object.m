function [ object ] = create_object( type )

depth = 4;
object = struct();
x = [0 4 4 9 9  4  4  12 12 0 ];
y = [0 0 7 7 11 11 16 16 20 20];

nVerts = length(x);
z1 = zeros(1,nVerts);
z2 = ones(1,nVerts) *-depth;
object.verticies = [x x; z1 z2;y y];
surfaceMaxLength = 10;

front = [1 2 3 4 5 6 7 8 9 10];
pillar = [1 10 20 11 0 0 0 0 0 0];
back = front+10;
object.surfaces = [front;back;pillar]                
for i = 1:nVerts-1
    p1 = i;
    p2 = i+1;
    p3 = p2 + 10;
    p4 = p1 + 10;
    surface = [p1 p2 p3 p4 zeros(1,surfaceMaxLength-4)];
    object.surfaces(end+1,:) = surface;
    
end

