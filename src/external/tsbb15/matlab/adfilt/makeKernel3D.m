function kernel3D = makeKernel3D(kernel2D, newaxes)
%
% function kernel3D = makeKernel3D(kernel2D, newaxes)
% 
% map a 2D kernel in xy-plane to a 3D kernel. The <newaxes> argument
% can be 'x','y','z' for 1D row-vector kernels and
% 'xy', 'xz', 'yz', '-xy', '-xz', '-yz' for 2D kernels.
%
%

% 1996, Magnus Hemmendorff


if(newaxes(1)=='-');
  if(length(newaxes)~=3); error(['invalid parameter: newaxes=' newaxes]);end;
  kernel2D = fliplr(kernel2D);
  newaxes = newaxes(2:3);
end;



if(strcmp(newaxes,'x'))
  if(size(kernel2D,1)~=1); error('The kernel2D must be a row vector');end;
  kernel3D = kernel2D(:);
  innerSize = size(kernel2D);
elseif(strcmp(newaxes,'y'))
  if(size(kernel2D,1)~=1); error('The kernel2D must be a row vector');end;
  kernel3D = kernel2D(:);
  innerSize = [size(kernel2D,2) 1];
elseif(strcmp(newaxes,'z'))
  if(size(kernel2D,1)~=1); error('The kernel2D must be a row vector');end;
  kernel3D = kernel2D;
  innerSize = [1 1];
elseif(strcmp(newaxes,'xy'))
  kernel3D = kernel2D(:);
  innerSize = size(kernel2D);
elseif(strcmp(newaxes,'xz'))
  kernel3D = kernel2D.';
  innerSize = [1  size(kernel2D,2)];
elseif(strcmp(newaxes,'yz'))
  kernel3D = kernel2D.';
  innerSize = [size(kernel2D,2)  1];
else
  error(['invalid value of newaxes: ' newaxes]);
end;

kernel3D = reshape(kernel3D, [innerSize size(kernel3D,2)] );