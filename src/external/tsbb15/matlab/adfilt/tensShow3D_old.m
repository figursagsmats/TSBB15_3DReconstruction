%function h = tensShow3D(C,imfig,tensfig)
%
% Command to visualize tensors corresponding to
% the the points in figure IMFIG that you left-click.
% The tensor is vizualized in figure TENSFIG.
% Z should be depth or time coordinate of the frame
% you are pointing in (in IMFIG).
%
% C should be a slice of a tensor volume
%  either with dimensions (y x 3 3) if the tensor
%         is represented as a full 3x3 matrix
%  or     with dimensions (y x 6) if the tensor
%         is represented by its 6 independent components.
%
% A right-click in figure IMFIG ends the routine.
%
% See also tensOrient3D tensLP3D tensMap3D 
%
%By Per-Erik Forssen, 1998

%In order to make the adaptive filtering exercise run
%smoother on 8bit palette systems, all images should
%have the same palette:
function h = tensShow3D(C,imfig,tensfig)

csz=size(C);
fail=1;
if size(csz,2)==3,
    if csz(3)==6,
	fail=0;     % (y x 6) case
	C2=C;
    end;
end;
if size(csz,2)==4,
    if((csz(3)==3)&(csz(4)==3)),
	fail=0;
	C2=C(:,:,[1 4 5 7 8 9]);
    end;
end;
if fail==1,
    error('Tensor data should be of size (Y X 6) or (Y X 3 3)');
    exit(1);
end;

colormap([1:255]'/255*[1 1 1]);

button=0;

figure(imfig)
[x y button] = ginput(1); % read one mouse click.
while(button~=3)
    x=round(x);
    y=round(y);
    t = reshape(C2(y,x,:),[6 1]);
    [eigval,eigvec] = tens2eig(t);
    figure(tensfig)
    h = tensorshape3D(eigval,eigvec,1);
    s=sprintf('Tensor in x=%d y=%d',x,y);
    title(s);
    figure(imfig)
    [x y button] = ginput(1); % read one mouse click.    
end
disp('Done.'); 
