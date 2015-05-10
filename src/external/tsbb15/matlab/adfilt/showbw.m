%function h=showbw(img,stretch_flag)
%
% Displays the grayscale image IMG
% in current figure.
% If the optional argument STRETCH_FLAG
% is non-zero the image will be contrast
% stretched before it is displayed.
%
%Per-Erik Forssen, 1998

function h=showbw(img,stretch_flag)

if nargin==1
    stretch_flag=0;
end;

subplot(1,1,1)
colormap([1:255]'/255*[1 1 1]) % create and activate a greyscale palette.
if stretch_flag
    imagesc(img)
else
    image(img)
end
axis image
