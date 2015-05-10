%**************************************************************
% Sequential filters for 3D adaptive enhancement
% 
%    q1 = g1 * f1 * h1   x
%    q2 = g1 * f2 * h2   x,y
%    q3 = g3 * f2 * h3   y
%    q4 = g4 * f4 * h4   x,z
%    q5 = g5 * f5 * h5   y,z
%    q6 = g6 * f6 * h6   z
%    q7 = g7 * f7 * h7   -x,y
%    q8 = g8 * f8 * h8   -x,z
%    q9 = g9 * f9 * h9   -y,z
%
%  f,g and h are `more or less' 1-d filters, g and h are real while 
%  and f are complex
%
%   by matsa 9808
%**************************************************************
%clear all;
fsz = 19;
sz_F = [fsz,fsz,fsz,1];            

u0 = pi/sqrt(2);            % centerfreq of lognorm filter

bw = 2.2;                   % bandwidth of lognorm filter

n1   = [ 0  1  0  0];       % filter directions 
n2   = [ 1  1  0  0];      
n3   = [ 1  0  0  0];      
n4   = [ 0  1  1  0];        
n5   = [ 1  0  1  0];        
n6   = [ 0  0  1  0];        
n7   = [ 1 -1  0  0];        
n8   = [ 0 -1  1  0];        
n9   = [-1  0  1  0];        

sz_f1 =  15;            % spatial size of filter
sz_f2 =  11;

sz_g1 =  7;
sz_g2 =  9;

sz_h1 =  7;
sz_h2 =  9;

sz_lp = 11;

itcnt = 8;             % number of iterations in seq opt


%**************************************************************
% ideal filters
%**************************************************************
disp('Setting up ideal filters...');
Fi1 = quadlogcos(sz_F,u0,bw,n1);
Fi1 = dft(real(idft(Fi1)));              % Extract real part of spatial filter
Fig1=getdata(Fi1);
figure(1);wamesh(Fig1(:,:,floor(sz_F(1)/2)),'Ideal axial filter'),drawnow

Fi2 = quadlogcos(sz_F,u0,bw,n2);
Fi2 = dft(real(idft(Fi2)));              % Extract real part of spatial filter
Fig2=getdata(Fi2);
figure(2);wamesh(Fig2(:,:,floor(sz_F(1)/2)),'Ideal diagonal filter'),drawnow


Fsum=Fi1+permute(Fi1,[2 1 3])+permute(Fi1,[1 3 2]);
Fsum=Fsum+Fi2+permute(Fi2,[3 2 1])+permute(Fi2,[1 3 2]);
Fsum=Fsum+flipdim(Fi2,2)+flipdim(permute(Fi2,[3 2 ...
	1]),2)+flipdim(permute(Fi2,[1 3 2]),1);
figure(5), rotate3d on
Fig3=getdata(Fsum);
wamesh(Fig3(:,:,floor(sz_F(1)/2))) %show middle xy section

s = sprintf('Ideal frequency responce');
my_title(s);

clear Fig1 Fig2 Fig3
%**************************************************************
% Frequency weight
%**************************************************************
disp('Setting up weight function and spatial masks...');
rexp    =  -1;
cosexp  =  2;
epsilon = 0.2;
alpha = 0.2/sz_F(1);
Fw = powrbook(sz_F,1,rexp,cosexp,alpha,epsilon);

%**************************************************************
% spatial masks
%**************************************************************

msk_h1 = ones(wa([1,1,sz_h1],0));
msk_g1 = ones(wa([1,sz_g1,1],0));
msk_f1 = ones(wa([sz_f1,1,1],0));

msk_h2 = pole([sz_h2,sz_h2,sz_h2],n7,sz_h2*1.42,0.5);
msk_g2 = pole([sz_g2,sz_g2,sz_g2],n6,sz_g2*1.42,0.5);
msk_f2 = pole([sz_f2,sz_f2,sz_f2],n2,sz_f2*1.42,2.13);

%**************************************************************
% optimize
%**************************************************************
disp('Starting optimization.');
F1 = ones(wa(sz_F,1));
H1 = ones(wa(sz_F,1));

figure(1), rotate3d on
for k = 1:itcnt
    g1 = optimize(Fi1,Fw,msk_g1,F1.*H1);
    G1 = dft(g1,sz_F);

    h1 = optimize(Fi1,Fw,msk_h1,F1.*G1);
    H1 = dft(h1,sz_F);
    
    f1 = optimize(Fi1,Fw,msk_f1,G1.*H1);
    F1 = dft(f1,sz_F);
    Q1 = F1.*G1.*H1;
    Qe=getdata(Q1);

    [Edis, Sdis] = distortion(Q1,Fi1,Fw);  %distortion
    s1 = sprintf(' Q1  wdist = %2.1f%%',Sdis{7});
    s2 = sprintf(' uwdist = %2.1f%% \n', Sdis{6});
    s=[s1,s2;];
    wamesh(Qe(:,:,floor(sz_F(1)/2)),s),drawnow
%    my_title(s),drawnow
end


F2 = ones(wa(sz_F,1));
H2 = ones(wa(sz_F,1));
figure(2), rotate3d on
for k = 1:itcnt
    g2 = optimize(Fi2,Fw,msk_g2,F2.*H2);
    G2 = dft(g2,sz_F);

    h2 = optimize(Fi2,Fw,msk_h2,F2.*G2);
    H2 = dft(h2,sz_F);
    
    f2 = optimize(Fi2,Fw,msk_f2,G2.*H2);
    F2 = dft(f2,sz_F);

    Q2 = F2.*G2.*H2;
    Qe=getdata(Q2);
    [Edis, Sdis] = distortion(Q2,Fi2,Fw);  %distortion
    s1 = sprintf(' Q2  wdist = %2.1f%%',Sdis{7});
    s2 = sprintf(' uwdist = %2.1f%% \n', Sdis{6});
    s=[s1,s2;];
    wamesh(Qe(:,:,floor(sz_F(1)/2)),s),drawnow %show middle xy section
%    my_title(s),drawnow
end

%**************************************************************
% normalize filters
% (keep the total norm, while making the individual
% filters more similar in size)
%**************************************************************
mf1 = max(max(abs(getdata(f1))));
mg1 = max(max(abs(getdata(g1))));
mh1 = max(max(abs(getdata(h1))));
norm1 = (mf1*mg1*mh1)^(2/3);
f1 = f1.*(mg1*mh1/norm1);
g1 = g1.*(mf1*mh1/norm1);
h1 = h1.*(mf1*mg1/norm1);
F1 = dft(real(f1),sz_F);
G1 = dft(real(g1),sz_F);
H1 = dft(real(h1),sz_F);
Q1 = G1.*F1.*H1;


mf2 = max(max(max(abs(getdata(f2)))));
mg2 = max(max(max(abs(getdata(g2)))));
mh2 = max(max(max(abs(getdata(h2)))));
norm2 = (mf2*mg2*mh2)^(2/3);
f2 = f2.*(mg2*mh2/norm2);
g2 = g2.*(mf2*mh2/norm2);
h2 = h2.*(mf2*mg2/norm2);
F2 = dft(real(f2),sz_F);
G2 = dft(real(g2),sz_F);
H2 = dft(real(h2),sz_F);
Q2 = G2.*F2.*H2;

%**************************************************************
% compute q3 through q9 by transposing and mirroring
%**************************************************************
clear G1 G2 F1 F2 H1 H2

ex = permute(f1,[2 1 3 4]);   % x
ey = permute(f1,[1 2 3 4]);   % y
ez = permute(f1,[3 2 1 4]);   % z
px = permute(g2,[2 3 1 4]);   % x
py = permute(g2,[3 1 2 4]);   % y
pz = permute(g2,[1 2 3 4]);   % z

px2 = permute(g1,[1 2 3 4]);
py2 = permute(g1,[2 1 3 4]);
pz2 = permute(h1,[1 2 3 4]);

exy = permute(f2,[1 2 3 4]);  % xy
exz = permute(f2,[3 2 1 4]);  % xz
eyz = permute(f2,[1 3 2 4]);  % yz
pxy = flipdim(h2,1);          % xy
pxz = flipdim(permute(h2,[3 2 1 4]),2); % xz
pyz = flipdim(permute(h2,[2 3 1 4]),1); % yz

e_xy = flipdim(exy,2);      % -xy
e_xz = flipdim(exz,2);      % -xz
e_yz = flipdim(eyz,1);      % -yz
p_xy = flipdim(pxy,1);      % -xy
p_xz = flipdim(pxz,2);      % -xz
p_yz = flipdim(pyz,1);      % -yz

%**************************************************************
% Visualize sum of filters
%**************************************************************

EX = real(dft(real(ex),sz_F));
EY = real(dft(real(ey),sz_F));
EZ = real(dft(real(ez),sz_F));
PX = real(dft(real(px),sz_F));
PY = real(dft(real(py),sz_F));
PZ = real(dft(real(pz),sz_F));

PX2 = real(dft(real(px2),sz_F));
PY2 = real(dft(real(py2),sz_F));
PZ2 = real(dft(real(pz2),sz_F));

EXY = real(dft(real(exy),sz_F));
EXZ = real(dft(real(exz),sz_F));
EYZ = real(dft(real(eyz),sz_F));
PXY = real(dft(real(pxy),sz_F));
PXZ = real(dft(real(pxz),sz_F));
PYZ = real(dft(real(pyz),sz_F));

E_XY = real(dft(real(e_xy),sz_F));
E_XZ = real(dft(real(e_xz),sz_F));
E_YZ = real(dft(real(e_yz),sz_F));
P_XY = real(dft(real(p_xy),sz_F));
P_XZ = real(dft(real(p_xz),sz_F));
P_YZ = real(dft(real(p_yz),sz_F));

Q1 = PZ2.*PY2.*EX;    %
Q2 = PZ.*P_XY.*EXY;
Q3 = PX2.*PZ2.*EY;    %
Q4 = PY.*P_XZ.*EXZ;
Q5 = PX.*P_YZ.*EYZ;
Q6 = PY2.*PX2.*EZ;    %
Q7 = PZ.*PXY.*E_XY;
Q8 = PY.*PXZ.*E_XZ;
Q9 = PX.*PYZ.*E_YZ;

% tmp = Q1+Q2+Q3+Q7;
tmp = Q1+Q2+Q3+Q4+Q5+Q6+Q7+Q8+Q9;
clear Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 PX PY PZ PXY P_XY PXZ P_XZ PYZ P_YZ
clear EX EY EZ EXY E_XY EXZ E_XZ EYZ E_YZ
tmpv=getdata(tmp);
figure(3), rotate3d on
wamesh(tmpv(:,:,floor(sz_F(1)/2))) %show middle xy section

coeffs = 3*(sum(sum(msk_g1)) + 2*sum(sum(msk_f1)));
coeffs = coeffs + 6*(sum(sum(sum(msk_g2))) + 2*sum(sum(sum(msk_f2))));
specs = [u0 bw coeffs];

s = sprintf('Frequency responce using  %d real coeffs',coeffs)
my_title(s)

%**************************************************************
% compute low pass filters
%**************************************************************

figure(4), rotate3d on

idlp = (radius(wa(sz_F,1)) <= u0); % ideal low-pass filter 

%Optimize low-pass with respect to the optimized high-pass
Filp=(1.5-Fsum).*idlp;
Filp=putdata(Filp,getdata(Filp)/1.5); % Divide by 1.5
%Optimize low-pass with respect to the ideal high-pass in 2D only
%FiSum=Fi1+Fi2;
%Temp=getdata(FiSum);
%Temp=Temp(:,:,floor(sz_F(1)/2));
%Temp=Temp+rot90(Temp);
%FiSum=putdata(wa([sz_F(1) sz_F(2)],1),Temp);
%idlp = (radius(wa([sz_F(1) sz_F(2)],1)) <= u0); % ideal low-pass filter
%Filp=(1-FiSum).*idlp;

%Fiv5=getdata(Filp);
%wamesh(Fiv5,-12)
%my_title('Desired low-pass');

Ft=getdata(Filp);
subplot(1,1,1);
tit='Slices of ideal LP kernel in Fourier space';
fs=12; %fontsize
colormap('default');

for i=1:fsz
    F=putdata(wa(size(Ft(:,:,i)),1),Ft(:,:,i));
    sz_F = size(F);
    [y x z t] = getcoord(F);
	
    mesh(x,y,real(getdata(F)));
    axis([-pi,pi,-pi,pi,-.1,2])
    set(gca, 'xtick', [-pi:pi/2:pi])	
    set(gca, 'ytick', [-pi:pi/2:pi])
    set(gca, 'fontsize', fs)
    set(gca, 'fontname', 'symbol')
    set(gca, 'xticklabel',['-p|-p/2|0|p/2|p'])
    set(gca, 'yticklabel',['-p|-p/2|0|p/2|p'])
    axis vis3d; 
    xlabel('u-axis','fontname','times','fontsize',fs)
    ylabel('v-axis','fontname','times','fontsize',fs)
    title(['\bf ' tit],'fontname','times','fontsize',fs)

    rotate3d on;
    pause(0.3);
end;

%**************************************************************
% Spatial masks
%**************************************************************
disp('Setting up weight function and spatial masks...');
itcnt=7;
msk_g1 = ones(wa([1,sz_lp],0));
msk_f1 = ones(wa([sz_lp,1],0));
msk_h1 = ones(wa([1,1,sz_lp],0));
%**************************************************************
% Frequency weight
%**************************************************************
sz_F = [fsz,fsz,fsz,1];            
rexp    =  -1;
cosexp  =  2;
epsilon = 0.2;
alpha = 0.2/sz_F(1);
Fw = powrbook(sz_F,1,rexp,cosexp,alpha,epsilon);

F1 = ones(wa(sz_F,1));
H1 = ones(wa(sz_F,1));
%**************************************************************
% optimize
%**************************************************************

disp('Starting optimization.');

figure(1), rotate3d on
for k = 1:itcnt
    g1 = optimize(Filp,Fw,msk_g1,F1.*H1);
    G1 = dft(g1,sz_F);

    h1 = optimize(Filp,Fw,msk_h1,F1.*G1);
    H1 = dft(h1,sz_F);
    
    f1 = optimize(Filp,Fw,msk_f1,G1.*H1);
    F1 = dft(f1,sz_F);
    Q1 = F1.*G1.*H1;
    Qe=getdata(Q1);

    [Edis, Sdis] = distortion(Q1,Filp,Fw);  %distortion
    s1 = sprintf(' Q1  wdist = %2.1f%%',Sdis{7});
    s2 = sprintf(' uwdist = %2.1f%% \n', Sdis{6});
    s=[s1,s2;];
    wamesh(Qe(:,:,floor(sz_F(1)/2)),s),drawnow
%    my_title(s),drawnow
end


%**************************************************************
% Extract kernels from wa objects
%**************************************************************
lpy=real(getdata(f1));
lpx=real(getdata(g1));
lpz=real(getdata(h1));

clp = lpy/sum(lpy);
px = real(getdata(px));
py = real(getdata(py));
pz = real(getdata(pz));
px2 = real(getdata(px2));
py2 = real(getdata(py2));
pz2 = real(getdata(pz2));
pxy = real(getdata(pxy));
pxz = real(getdata(pxz));
pyz = real(getdata(pyz));
p_xy = real(getdata(p_xy));
p_xz = real(getdata(p_xz));
p_yz = real(getdata(p_yz));
ex = real(getdata(ex));
ey = real(getdata(ey));
ez = real(getdata(ez));
exy = real(getdata(exy));
exz = real(getdata(exz));
eyz = real(getdata(eyz));
e_xy = real(getdata(e_xy));
e_xz = real(getdata(e_xz));
e_yz = real(getdata(e_yz));

coeffs = coeffs + 3*sz_lp;
specs = [u0 bw coeffs];

% save enh3D_tst lpx lpy lpz px py pz px2 py2 pz2 pxy pxz pyz p_xy p_xz
% p_yz ex ey ez exy exz eyz e_xy e_xz e_yz specs
