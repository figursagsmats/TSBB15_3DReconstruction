function normimage(M)

% Displays a gray-scale image of the real part of matrix M in 256 gray-levels
% The image is normalized such that the least value is black and the largest
% is white.

M = real(M);

maxx = max(max(M));
minn = min(min(M));
dyn = maxx - minn;

if (dyn == 0),
  fprintf('Constant image. No image is rendered.\n');
else  
  colormap(gray(256));
  image(256 * (M - minn) / (maxx - minn));axis('ij');
end
