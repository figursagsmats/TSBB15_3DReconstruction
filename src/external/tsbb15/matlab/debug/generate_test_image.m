function image = generate_test_image(radius)
% Create coordinates
[x,y]=meshgrid(-radius:radius-1,-radius:radius-1);

% Create an image with radially increasing values
image=sqrt(x^2+y^2);

% Draw two lines
image(radius,:) = 0;
image(:,radius) = 0;
end
