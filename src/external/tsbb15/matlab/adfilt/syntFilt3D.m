%function sigOut = syntFilt3D(S,C,ahp);
%
%  This routine will combine a set of fixed filter responses
%  into an adaptive filter response using the control tensor C.
%  C should contain tensors in T6 format.
%
%  S       should contain the precomputed fixed filter responses.
%  AHP     is the amplification factor for the high-pass content
%          of the signal
%
% See "Signal Processing For Computer Vision" section 10.4
%
%Per-Erik Forssen, 1998
%
function sigOut = syntFilt3D(S,C,ahp);

[v1 v2 v3 dummy]=size(S);
[ysz xsz zsz dummy]=size(C);

if((ysz~=v1)|(xsz~=v2)|(zsz~=v3))
    s=sprintf('Usage:<sigOut> = syntFilt3D(<S>,<C>,<ahp>)\n\nthe supplied parameters S and C are not compatible.');
    error(s);
end;

%
% Set up filter directions and compute dual tensors
%

disp('Building dual tensors...');

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
% Projection Tensors (symmetric case)
%**************************************************************
I=eye(3);
M1=5/4*n1*n1'-I/4;
M2=5/4*n2*n2'-I/4;
M3=5/4*n3*n3'-I/4;
M4=5/4*n4*n4'-I/4;
M5=5/4*n5*n5'-I/4;
M6=5/4*n6*n6'-I/4;
    
ndc=[1 5 9 4 7 8];   % indices to use in compact representation
iwt=[1 1 1 2 2 2];   % index wheights (no of occurences in full tensor)
Md=[M1(ndc); M2(ndc); M3(ndc); M4(ndc); M5(ndc); M6(ndc)]*diag(iwt);
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
disp('Performing filter synthesis...');

slp=reshape(S(:,:,:,1),[xsz*ysz*zsz,1]);

S=reshape(S(:,:,:,2:7),[xsz*ysz*zsz,6]);

Cr=reshape(C,[xsz*ysz*zsz 6]);

ck=Cr*Md;

s=uint8(max(0,min(255,slp+ahp*sum((ck.*S)')')));
sigOut=reshape(s,[ysz,xsz,zsz]);
