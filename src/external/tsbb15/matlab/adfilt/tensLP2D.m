%function Tlp = tensLP2D(T,sigma)
%
%  Low pass filtering of a 2D orientation tensor.
%  First step in producing a control tensor for
%  adaptive filtering.
%
%  T is the orientation tensor field.
%  sigma is the standard deviation of the gaussian
%  smoothening filter.
%
%Per-Erik Forssen, 1998
%
function Tlp = tensLP2D(T,sigma);

if nargin < 2
 help tensLP2D
 return
end

tensz = size(T);
if tensz(3) ~= 3 error('T should be a T3 tensor-field'); end;
[dummy,nd] = size(tensz);
scenesz = tensz(1:2);

hlp = gausskernel(sigma,0.0005)';
[dummy filtersize] = size(hlp);
fprintf('Coefficients in LP filter :2x%d\n',filtersize);

% Low pass filter each component

t1 = conv2(hlp',hlp,T(:,:,1),'same');
t2 = conv2(hlp',hlp,T(:,:,2),'same');
t3 = conv2(hlp',hlp,T(:,:,3),'same');

% Create a new tensor in T3 form

Tlp = reshape([t1(:) t2(:) t3(:)],tensz);

