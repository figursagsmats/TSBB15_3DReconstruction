function [q,n] = makeQResponses3D(volume, kern_no)
  
% [q,n] = makeQResponses3D(volume, kern_no)
%
% Computes quadrature filter responses on a volume
%
%       q - M1/M2/M3/9 volume, q(:,:,k) = filter response k
%       n - 9/1 cell array of filter direction vectors
%
%  volume - M1/M2/M3 volume (either double or uint8)
% kern_no - Number of filterset to use [1-8]
%           See file 'kernel_data.text' for information of each
%           filter set, ori3D_1-8
%
%

% bjojo ht2004
% 1996, Magnus Hemmendorff
% 1998, Per-Erik Forssen, added selection of filter set

isuint=isa(volume,'uint8');

disp('Loading and setting up filter');

if (kern_no>=1)&(kern_no<9)&(kern_no-floor(kern_no)==0)
  load(['ori3D_' num2str(kern_no) '.mat']);
else
  error('Valid kernel numbers are 1-8');
  exit(1);
end

%
% The mirroring is to make kernels consistent with
% the ones used in Magnus H's code
%
fxy=fliplr(fxy);
pxy=fliplr(pxy);

if (size(px,1)~=1);
  error('By definition, px must be a row vector');
end

% Create 3D-versions of all kernels

% All one-dimensional filters
pxKer = makeKernel3D(px,'x');
fxKer = makeKernel3D(fx,'x');
pyKer = makeKernel3D(px,'y');
fyKer = makeKernel3D(fx,'y');
pzKer = makeKernel3D(px,'z');
fzKer = makeKernel3D(fx,'z');

% two-dimensional filters xy, xz, yz
pxyKer = makeKernel3D(pxy,'xy');
fxyKer = makeKernel3D(fxy,'xy');
pxzKer = makeKernel3D(pxy,'xz');
fxzKer = makeKernel3D(fxy,'xz');
pyzKer = makeKernel3D(pxy,'yz');
fyzKer = makeKernel3D(fxy,'yz');

% two-dimensional filters -xy, -xz, -yz
p_xyKer = makeKernel3D(pxy,'-xy');
f_xyKer = makeKernel3D(fxy,'-xy');
p_xzKer = makeKernel3D(pxy,'-xz');
f_xzKer = makeKernel3D(fxy,'-xz');
p_yzKer = makeKernel3D(pxy,'-yz');
f_yzKer = makeKernel3D(fxy,'-yz');

% ---------------- Convolutions  ---------------------

disp('Branch: px');

if isuint
  tmp1 = tensConv3(double(volume), pxKer);
else
  tmp1 = tensConv3(volume, pxKer); 
end
% The inner size of tmp1 is the same as for the input volume

disp('   Compute q1');

tmp2 = tensConv3(tmp1, pyzKer);
Q1 = tensConv3(tmp2, f_yzKer);

disp('   Compute q2');
tmp2 = tensConv3(tmp1, p_yzKer);
Q2 = tensConv3(tmp2, fyzKer);

disp('   Compute q3');
tmp2 = tensConv3(tmp1, pzKer);
Q3 = tensConv3(tmp2, fyKer);

% --
disp('Branch: py');
if isuint
  tmp1 = tensConv3(double(volume), pyKer); 
else
  tmp1 = tensConv3(volume, pyKer); 
end
disp('   Compute q4');
tmp2 = tensConv3(tmp1, pxzKer);
Q4 = tensConv3(tmp2, f_xzKer);

disp('   Compute q5');
tmp2 = tensConv3(tmp1, p_xzKer);
Q5 = tensConv3(tmp2, fxzKer);

disp('   Compute q6');
tmp2 = tensConv3(tmp1, pxKer);
Q6 = tensConv3(tmp2, fzKer);

% ---
disp('Branch: pz');

if isuint
  tmp1 = tensConv3(double(volume), pzKer); 
else
  tmp1 = tensConv3(volume, pzKer); 
end

disp('   Compute q7');
tmp2 = tensConv3(tmp1, p_xyKer);
Q7 = tensConv3(tmp2, fxyKer);

disp('   Compute q8');
tmp2 = tensConv3(tmp1, pxyKer);
Q8 = tensConv3(tmp2, f_xyKer);

disp('   Compute q9');
tmp2 = tensConv3(tmp1, pyKer);
Q9 = tensConv3(tmp2, fxKer);

%-----

q = [Q1(:) Q2(:) Q3(:) Q4(:) Q5(:) Q6(:) Q7(:) Q8(:) Q9(:)];
q = reshape(q,[size(Q1) 9]);

%----- Filter directions

n{1}=1/sqrt(2)*[0 -1 1]';         % -yz
n{2}=1/sqrt(2)*[0 1 1]';          % yz
n{3}=[0 1 0]';                    % y
n{4}=1/sqrt(2)*[-1 0 1]';         % -xz
n{5}=1/sqrt(2)*[1 0 1]';          % xz
n{6}=[0 0 1]';                    % z
n{7}=1/sqrt(2)*[1 1 0]';          % xy
n{8}=1/sqrt(2)*[1 -1 0]';         % -xy
n{9}=[1 0 0]';                    % x
