%function sigOut = syntSlice3D(S,C,ahp,slice);
%
%  This routine will synthetisize the output of an adaptive
%  filter in one slice of a volume. A set of fixed filter
%  responses are combined into an adaptive filter response
%  using the control tensor C.
%  C should contain tensors in T6 format as output from
%  tensMap3D with two arguments.
%
%  S       should contain the precomputed fixed filter responses.
%  AHP     is the amplification factor for the high-pass content
%          of the signal
%  SLICE   is the number of the slice to compute. Of course this
%          should be the same number as that supplied to tensMap3D
%          when C was obtained.
%
% See "Signal Processing For Computer Vision" section 10.4
%
%NOTE: This routine has NOT been debugged!!!
%
%Per-Erik Forssen, 1998
%
function sigOut = syntSlice3D(S,C,ahp,slice);

[v1 v2 v3 dummy]=size(S);
[ysz xsz zsz dummy]=size(C);

if(zsz~=1) 
    s=sprintf('Usage:<sigOut> = syntSlice3D(<S>,<C>,<ahp>,<slice>)\n\nthe supplied parameter C is not a slice.');
    error(s);
end;

if((ysz~=v1)|(xsz~=v2))
    s=sprintf('Usage:<sigOut> = syntSlice3D(<S>,<C>,<ahp>,<slice>)\n\nthe supplied parameters S and C are not compatible.');
    error(s);
end;

%
% Set up filter directions and compute dual tensors
%


a = 2;                    % see p 237 in Computer Vision book
b = (1+sqrt(5)); 
c = (a*a + b*b)^-0.5;
a = a*c; b = b*c;

n1 = [ 0  a  b]';          % filter dir [y x z]
n2 = [ 0 -a  b]';
n3 = [ a  b  0]'; 
n4 = [-a  b  0]'; 
n5 = [ b  0  a]';
n6 = [ b  0 -a]';
%**************************************************************
I=diag([1,1,1]);
ndc=[1 5 9 4 7 8]; %indices to use in compact representation
iwt=[1 1 1 2 2 2]; %index wheights (no of occurences in full tensor)
%**************************************************************
% Projection Tensors (symmetric case)
%**************************************************************
Md1=5/4*n1*n1'-I/4;
M1=Md1(ndc)'.*iwt';
Md2=5/4*n2*n2'-I/4;
M2=Md2(ndc)'.*iwt';
Md3=5/4*n3*n3'-I/4;
M3=Md3(ndc)'.*iwt';
Md4=5/4*n4*n4'-I/4;
M4=Md4(ndc)'.*iwt';
Md5=5/4*n5*n5'-I/4;
M5=Md5(ndc)'.*iwt';
Md6=5/4*n6*n6'-I/4;
M6=Md6(ndc)'.*iwt';
Md=[M1 M2 M3 M4 M5 M6];
%**************************************************************
% Projection Tensors (general case)
%**************************************************************
r2 = sqrt(2);
r_2 = 1/r2;
Nv{1} = [n1(1)^2 n1(2)^2 n1(3)^2 r2*n1(1)*n1(2) r2*n1(2)*n1(3) r2*n1(1)*n1(3)];
Nv{2} = [n2(1)^2 n2(2)^2 n2(3)^2 r2*n2(1)*n2(2) r2*n2(2)*n2(3) r2*n2(1)*n2(3)];
Nv{3} = [n3(1)^2 n3(2)^2 n3(3)^2 r2*n3(1)*n3(2) r2*n3(2)*n3(3) r2*n3(1)*n3(3)];
Nv{4} = [n4(1)^2 n4(2)^2 n4(3)^2 r2*n4(1)*n4(2) r2*n4(2)*n4(3) r2*n4(1)*n4(3)];
Nv{5} = [n5(1)^2 n5(2)^2 n5(3)^2 r2*n5(1)*n5(2) r2*n5(2)*n5(3) r2*n5(1)*n5(3)];
Nv{6} = [n6(1)^2 n6(2)^2 n6(3)^2 r2*n6(1)*n6(2) r2*n6(2)*n6(3) r2*n6(1)*n6(3)];

NN = zeros(6);
for k=1:6
    NN = NN + Nv{k}'*Nv{k};
end

MM = inv(NN);

for k=1:6
    M{k} = zeros(3);
    Mv{k} = MM*Nv{k}';
    M{k} = diag(Mv{k}(1:3),0);
    M{k} = M{k} + r_2*diag(Mv{k}(4:5), 1);
    M{k} = M{k} + r_2*diag(Mv{k}(4:5),-1);
    M{k} = M{k} + r_2*diag(Mv{k}(6),   2);
    M{k} = M{k} + r_2*diag(Mv{k}(6),  -2);
end

perm=diag([1 1 1 r2 0 0])+diag([0 0 0 0 r2],1)+diag([0 0 0 0 r2],-1);

for k=1:6
    Mv{k} = perm*(MM*Nv{k}');
end
Mdnew=[Mv{1} Mv{2} Mv{3} Mv{4} Mv{5} Mv{6}];

%**************************************************************
% Perform the filter synthesis
%**************************************************************

slp=reshape(S(:,:,slice,1),[xsz*ysz,1]);

S=reshape(S(:,:,slice,2:7),[xsz*ysz,6]);

Cr=reshape(C,[xsz*ysz 6]);
ck=Cr*Md';
s=uint8(min(255,max(0,slp+ahp*sum((ck.*S)')')));
sigOut=reshape(s,[ysz xsz]);
