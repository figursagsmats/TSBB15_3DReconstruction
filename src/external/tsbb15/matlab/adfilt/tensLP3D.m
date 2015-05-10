%function Tlp = tensLP3D(T,sigma)
%
%  Low pass filtering of a 3D orientation tensor.
%  First step in producing a control tensor for
%  adaptive filtering.
%
%  T is the orientation tensor field.
%  sigma is the standard deviation of the gaussian
%  smoothening filter.
%
%Per-Erik Forssen, 1998
%
function Tlp = tensLP3D(T,sigma);

if nargin < 2
 help tensLP3D
 return
end

tensz = size(T);
if tensz(4) ~= 6 error('T should be a T6 tensor-field'); end;
[dummy,nd] = size(tensz);
volsz = tensz(1:3);

hlp = gausskernel(sigma,0.0005)';
[dummy filtersize] = size(hlp);
fprintf('Coefficients in LP filter :3x%d\n',filtersize);

% Low pass filter each component

t1 = tensConv3(tensConv3(tensConv3(T(:,:,:,1),permute(hlp,[1 3 2])),hlp'),hlp);
t2 = tensConv3(tensConv3(tensConv3(T(:,:,:,2),permute(hlp,[1 3 2])),hlp'),hlp);
t3 = tensConv3(tensConv3(tensConv3(T(:,:,:,3),permute(hlp,[1 3 2])),hlp'),hlp);
t4 = tensConv3(tensConv3(tensConv3(T(:,:,:,4),permute(hlp,[1 3 2])),hlp'),hlp);
t5 = tensConv3(tensConv3(tensConv3(T(:,:,:,5),permute(hlp,[1 3 2])),hlp'),hlp);
t6 = tensConv3(tensConv3(tensConv3(T(:,:,:,6),permute(hlp,[1 3 2])),hlp'),hlp);

% Create a new tensor in T6 form

Tlp = reshape([t1(:) t2(:) t3(:) t4(:) t5(:) t6(:)],tensz);