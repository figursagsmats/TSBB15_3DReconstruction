%function C = tensMap(Tlp)
%
% This function remaps the eigenvalues of
% the control tensor field, according to the
% map functions set by MSETUP and MYSETUP.
%
% Tlp is a low passed orientation tensor field.
%
% see the book "Signal Processing for Computer 
% Vision" 10.3.3 - 10.3.5 for details.
%
%By Per-Erik Forssen
%
function C = tensMap(Tlp);

if nargin < 1
 help tensMap
 return
end

[dummy,xsz,ysz,zsz] = size(Tlp);

if(zsz==1) disp('2D tensor');C=tensMap2D(Tlp);
else disp('3D tensor');C=tensMap3D(Tlp);end;
