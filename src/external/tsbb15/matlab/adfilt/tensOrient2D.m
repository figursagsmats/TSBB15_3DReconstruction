function [T3array,T3size] = tensOrient2D(img, kern_no,verbose);
%
% function [T3array,T3size] = tensOrient2D(img, kern_no);
%
% IMG     input image
% KERN_NO number of kernel set to use [1-14] 
% VERBOSE display progress if non zero (default 1)
%
% Creates a 2D local orientation tensor field for IMG
%

% 1998, Per-Erik Forssen

% Component order is [[1 2];[2 3]] and vectors are o=[y x]'
%
%

if(nargin~=2)
  if(nargin~=3)
      s=sprintf('Two parameters required for tensOrient2D\nUsage: [T3array,T3size] = tensOrient2D(img, kern_no)');
      error(s);
      exit(1);
  end;
else
    verbose=1;
end

if verbose disp('Loading and setting up filters...'); end;

if (kern_no>=1)&(kern_no<15)&(kern_no-floor(kern_no)==0)
  name=sprintf('ori2D_%d.mat',kern_no);
  load(name);
else
  error('Valid kernel numbers are 1-14');
  exit(1);
end;

if (size(px,1)~=1);
  error('By definition, px must be a row vector');
end

%
% fx and fxy are "1D" quadrature filters
% px and pxy are low pass filters to make fx and fxy less
%                orientation specific

fy=flipud(fx');
py=px';
fmxy=fliplr(fxy);
pmxy=fliplr(pxy);

% directions x=[0 1] y=[1 0] xy=[1 -1] mxy=[1 1]
% f - quadrature filter
% p - lowpass filter

% ----------------  Directions   ---------------------
if verbose disp('Computing dual tensors and weight matrix...');end;
n1=[0 1]';
n2=1/sqrt(2)*[1 1]';
n3=[1 0]';
n4=1/sqrt(2)*[1 -1]';
I=eye(2);
% Dual tensors
M1=4/3*n1*n1'-I/3;
M2=4/3*n2*n2'-I/3;
M3=4/3*n3*n3'-I/3;
M4=4/3*n4*n4'-I/3;
matrix4=[M1(1,1) M2(1,1) M3(1,1) M4(1,1);
         M1(1,2) M2(1,2) M3(1,2) M4(1,2);
         M1(2,2) M2(2,2) M3(2,2) M4(2,2)]';

% ---------------- Convolutions  ---------------------
if verbose disp('Performing convolutions...');end;
Q1 = abs(conv2(conv2(img,fx,'same'),py,'same'));
Q2 = abs(conv2(conv2(img,fmxy,'same'),pxy,'same'));
Q3 = abs(conv2(conv2(img,fy,'same'),px,'same'));
Q4 = abs(conv2(conv2(img,fxy,'same'),pmxy,'same'));

% Weighted summation of dual tensors
%
% T4:[1 2;2 3] T3:[1 2 3]'
%
if verbose disp('Weighted summation of dual tensors...');end;

T3array = [Q1(:) Q2(:) Q3(:) Q4(:)]*matrix4;
T3array = reshape(T3array,[size(Q1) 3]);
