%function sigOut = syntFilt2D3(S,C,ahp);
%
% THIS IS THE SAME FUNCTION AS syntFilt2D EXCEPT THAT NO NORMALIZATION IS
% MADE ON THE OUTPUT.  VERBOSITY IS TURNED OFF
%
% Modified by Klas Nordberg Dec 2006
%
%  This routine will combine a set of fixed filter responses
%  into an adaptive filter response using the control tensor C.
%  C should contain tensors in T3 format.
%
%  S       should contain the precomputed fixed filter responses.
%  AHP     is the amplification factor for the high-pass content
%          of the signal
%
% See "Signal Processing For Computer Vision" section 10.4
%
%Per-Erik Forssen, 1998
%
function sigOut = syntFilt2D3(S,C,ahp);

[v1 v2 v3]=size(S);
[ysz xsz dummy]=size(C);
if((ysz~=v1)|(xsz~=v2))
   s=sprintf('Usage:<sigOut> = syntFilt2D(<S>,<C>,<ahp>)\n\nthe supplied parameters S and C are not compatible.');
   error(s);
end;

%
% Set up filter directions and compute dual tensors
%

%disp('Building dual tensors...');
n1=[0 1]';
n2=1/sqrt(2)*[1 -1]';
n3=[1 0]';
n4=1/sqrt(2)*[1 1]';
I=eye(2);
% Dual tensors
M1=4/3*n1*n1'-I/3;
M2=4/3*n2*n2'-I/3;
M3=4/3*n3*n3'-I/3;
M4=4/3*n4*n4'-I/3;
matrix4=[M1(1,1) M2(1,1) M3(1,1) M4(1,1);
         M1(1,2) M2(1,2) M3(1,2) M4(1,2);
         M1(2,2) M2(2,2) M3(2,2) M4(2,2)];
Md=diag([1,2,1])*matrix4;

%
% Perform the filter synthesis
%

%disp('Performing filter synthesis...');
slp=reshape(S(:,:,1),[xsz*ysz,1]);

S=reshape(S(:,:,2:5),[xsz*ysz,4]);

%
% Convert C into a [xsz*ysz 3] matrix
% and compute the filter coefficients ck
Cr=reshape(C,[xsz*ysz 3]);
ck=Cr*Md;
s=slp+ahp*sum((ck.*S),2);
sigOut=reshape(s,[ysz,xsz]);

