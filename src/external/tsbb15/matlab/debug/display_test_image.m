radius = 128;

% Get test image
image = generate_test_image(radius);

% Create a noise image, twice as wide as "image"
image_with_noise = generate_test_image2(radius);

% Coordinates for extracting sub-image of the same size as "image", centered horizontally
x = radius + (1:radius*2);
y = 1:radius*2;

% Combine the images
final_image = image + image_with_noise(x,y);

figure(1)
% Show image
image(final_image);
colormap(jet(radius));
axis image;
