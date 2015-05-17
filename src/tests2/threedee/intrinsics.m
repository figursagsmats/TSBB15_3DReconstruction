function [ K ] = intrinsics(focalLengthMm,pixelsPerMm)


%The focal length in world units, typically expressed in millimeters.
F = focalLengthMm;

% Number of pixels per mm in the x and y direction respectively.
sx = pixelsPerMm;
sy = pixelsPerMm;

s = 0;  %axis skew
x0 = 0;
y0 = 0;


fx = F*sx;
fy = F*sy;

K = [fx  s   x0;
     0   fy  y0;
     0   0   1 ];
K = K';
 

end

