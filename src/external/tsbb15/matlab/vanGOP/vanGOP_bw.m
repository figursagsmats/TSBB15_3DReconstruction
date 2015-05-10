%
% Oil painting effect
%
% Im0   - input image
% figno - number of figure to show results in
% iter  - number of iterations
%
%Per-Erik Forssen, 1998

%A=readbw('/site/bb/im/CVAB/bardot2.imf');

Im0=double(A)./double(max(max(A)));
Im0=subsamp(Im0,2);
iter=2;

cm=[1:255]'/255*[1 1 1]; % BW colour map

Im=imnoise(zeros(size(Im0)),'gaussian',0.5,0.05);

figure(1);colormap(cm);imagesc(Im);axis image;
bigTitle('Noise');

figure(2);colormap(cm);imagesc(Im0);axis image;
bigTitle('Original image');
drawnow;
disp('Subsampling and orientation computation');
T=tensOrient2D(subsamp(Im0,2),1).*3;
msetup(0.05,0.1,1,1)
mysetup(.5,1,1)
T=tensMap2D(T);

%
% Filtrera bruset
%
S=fixFilt2D(Im,1);
Tb=tensSupsamp(T,1);
Im=syntFilt2D2(S,Tb,1);


figure(1);colormap(cm);imagesc(Im);axis image;
bigTitle('Filtered noise');
drawnow;

%T=tensLP2D(T,1.5);
Ts=tensSubsamp(T,2);

%Ts=tensLP2D(Ts,2.5);
msetup(0.01,.05,1,1)
mysetup(.5,1,1)
Ts=tensMap2D(Ts)*.35;
T2=tensSupsamp(Ts,1);

Td=tensNorm2D(T)-tensNorm2D(T2);

Tr=T2;
Tr(:,Td>0)=T(:,Td>0);

%msetup(0.05,-1,1,1)
mysetup(.6,.2,1)
C=tensSupsamp(tensMap2D(Tr),1);

%
% Lägg på filtrerat brus på bilden
%
Im=Im0+(Im-.5).*2;
Im=Im.*(Im>0).*(Im<=1)+(Im>1);

figure(2);colormap(cm);imagesc(Im);axis image;
bigTitle('Image + filtered noise');
drawnow;


for ind=1:iter,
    S=fixFilt2D(Im,2);
    Im=syntFilt2D2(S,C,1);
    figure(1);colormap(cm);imagesc(Im-Im0);axis image;
    bigTitle('Noise component');
    figure(2);colormap(cm);imagesc(Im);axis image;
    bigTitle(sprintf('Iteration %d result',ind));
    drawnow;
end
