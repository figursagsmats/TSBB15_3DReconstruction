function [T6array,T6size] = tensOrient3D(sequence, kern_no);
%
% function [T6array,T6size] = tensOrient3D(sequence, kern_no);
%
% SEQUENCE input image sequence (either double or uint8)
% KERN_NO  number of filterset to use [1-8]
%
% Creates a 3D local orientation tensor field for IMG
%
% 

% 1996, Magnus Hemmendorff
% 1998, Per-Erik Forssen, added selection of filter set

if(nargin~=2),
 s=sprintf('Wrong number of input arguments\nUsage: [T6array,T6size] = tensOrient3D(sequence, kern_no)');
 error(s);
 exit(1);
end;

isuint=isa(sequence,'uint8');

disp('Loading and setting up filter');

if (kern_no>=1)&(kern_no<9)&(kern_no-floor(kern_no)==0)
  name=sprintf('ori3D_%d.mat',kern_no);
  load(name);
else
  error('Valid kernel numbers are 1-8');
  exit(1);
end;

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

% ------------- Create Whitening Matrix --------------

n{1}=1/sqrt(2)*[0 -1 1]';         % -yz
n{2}=1/sqrt(2)*[0 1 1]';          % yz
n{3}=[0 1 0]';                    % y
n{4}=1/sqrt(2)*[-1 0 1]';         % -xz
n{5}=1/sqrt(2)*[1 0 1]';          % xz
n{6}=[0 0 1]';                    % z
n{7}=1/sqrt(2)*[1 1 0]';          % xy
n{8}=1/sqrt(2)*[1 -1 0]';         % -xy
n{9}=[1 0 0]';                    % x

NN=zeros(9,9);

for k=1:9,
    N{k}=reshape(n{k}*n{k}',[9 1]);
    NN=NN+N{k}*N{k}';
end;
MM=pinv(NN);

for k=1:9,
    M{k}=MM*N{k};
end;

m9f=[M{1} M{2} M{3} M{4} M{5} M{6} M{7} M{8} M{9}];
matrix9=[m9f(1,:); m9f(4,:); m9f(5,:); m9f(7,:); m9f(8,:); m9f(9,:)];
% ---------------- Convolutions  ---------------------

disp('Branch: px');

if isuint
    tmp1 = tensConv3(double(sequence), pxKer);
else
    tmp1 = tensConv3(sequence, pxKer); 
end;
% The inner size of tmp1 is the same as for the input sequence

disp('   Compute q1');

tmp2 = tensConv3(tmp1, pyzKer);
Q1 = abs(tensConv3(tmp2, f_yzKer)); 

disp('   Compute q2');
tmp2 = tensConv3(tmp1,  p_yzKer);
Q2 = abs(tensConv3(tmp2, fyzKer)); 

disp('   Compute q3');
tmp2 = tensConv3(tmp1, pzKer);
Q3 = abs(tensConv3(tmp2, fyKer)); 


% --
disp('Branch: py');
if isuint
  tmp1 = tensConv3(double(sequence), pyKer); 
else
  tmp1 = tensConv3(sequence, pyKer); 
end;
disp('   Compute q4');
tmp2 = tensConv3(tmp1,  pxzKer);
Q4 = abs(tensConv3(tmp2, f_xzKer)); 

disp('   Compute q5');
tmp2 = tensConv3(tmp1,  p_xzKer);
Q5 = abs(tensConv3(tmp2, fxzKer)); 

disp('   Compute q6');
tmp2 = tensConv3(tmp1,  pxKer);
Q6 = abs(tensConv3(tmp2,  fzKer)); 


% ---
disp('Branch: pz');

if isuint
    tmp1 = tensConv3(double(sequence), pzKer); 
else
    tmp1 = tensConv3(sequence, pzKer); 
end;

disp('   Compute q7');
tmp2 = tensConv3(tmp1, p_xyKer);
Q7 = abs(tensConv3(tmp2, fxyKer));

disp('   Compute q8');
tmp2 = tensConv3(tmp1,  pxyKer);
Q8 = abs(tensConv3(tmp2, f_xyKer)); 

disp('   Compute q9');
tmp2 = tensConv3(tmp1,  pyKer);
Q9 = abs(tensConv3(tmp2, fxKer)); 

% Tensor whitening
%
% T9:[1 4 7;2 5 8;3 6 9] T6:[1 4 5 7 8 9]'
%
disp('Tensor Whitening');
T6array = [Q1(:) Q2(:) Q3(:) Q4(:) Q5(:) Q6(:) Q7(:) Q8(:) Q9(:)] ...
    *matrix9';
T6array = reshape(T6array, [size(Q1) 6]);
