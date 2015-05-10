%
% Oil painting effect
%
% Im0   - input image
% figno - number of figure to show results in
% iter  - number of iterations
%
%Per-Erik Forssen, 1998

%A=imread('/site/bb/im/CVAB/mpfeiffer.tif');

iter=1;

Im0=double(A)./double(max(max(max(A))));
Im0=subsamp(Im0,2);
%Im1=subsamp(Im0,2);

cm=[1:255]'/255*[1 1 1]; % BW colour map

Im=imnoise(zeros(size(Im0(:,:,1))),'gaussian',0.5,0.05);

figure(1);colormap(cm);imagesc(Im);axis image;
bigTitle('Noise');

figure(2);colormap('default');imagesc(Im0);axis image;
bigTitle('Original image');
drawnow;
disp('Subsampling and orientation computation.');

T_R=tensOrient2D(Im0(:,:,1),1).*3;
T_G=tensOrient2D(Im0(:,:,2),1).*3;
T_B=tensOrient2D(Im0(:,:,3),1).*3;
msetup(0.1,0,2,1)
mysetup(.8,4,1)
T_R=tensMap2D(T_R);
T_G=tensMap2D(T_G);
T_B=tensMap2D(T_B);

Ts_R=tensSubsamp(T_R,2);
Ts_G=tensSubsamp(T_G,2);
Ts_B=tensSubsamp(T_B,2);

msetup(0,-.2,2,1)
mysetup(.5,1,1)
Ts_R=tensMap2D(Ts_R);
Ts_G=tensMap2D(Ts_G);
Ts_B=tensMap2D(Ts_B);

T2_R=tensSupsamp(Ts_R,1);
T2_G=tensSupsamp(Ts_G,1);
T2_B=tensSupsamp(Ts_B,1);

Td_R=tensNorm2D(T_R)-tensNorm2D(T2_R);
Td_G=tensNorm2D(T_G)-tensNorm2D(T2_G);
Td_B=tensNorm2D(T_B)-tensNorm2D(T2_B);

Tr_R=T2_R;
Tr_G=T2_G;
Tr_B=T2_B;

Tr_R(:,Td_R>0)=T_R(:,Td_R>0);
Tr_G(:,Td_G>0)=T_G(:,Td_G>0);
Tr_B(:,Td_B>0)=T_B(:,Td_B>0);

%msetup(0.1,0,2,1) 
%mysetup(0.5,1,1)
C_R=Tr_R;%tensMap2D(Tr_R);
C_G=Tr_G;%tensMap2D(Tr_G);
C_B=Tr_B;%tensMap2D(Tr_B);
%
% Filtrera bruset
%
S=fixFilt2D(Im,3);
Im=syntFilt2D2(S,C_G,1.5);

S=fixFilt2D(Im,3);
Im=syntFilt2D2(S,C_G,1.5);

figure(1);colormap(cm);imagesc(Im);axis image;
bigTitle('Filtered noise');
drawnow;

%
% Lägg på filtrerat brus på bilden
%
Im=(Im-.5); % Flytta brusets väntevärde till 0

Im1 = Im0+reshape([Im Im Im],[size(Im) 3]);  % Lägg till bruset i alla band
Im1 = imclamp(Im1,1);        % Trimma intensitetsvärden

figure(2);imagesc(Im1);
axis image;
bigTitle('Image + Noise');
drawnow;

Im_R=Im1(:,:,1);
Im_G=Im1(:,:,2);
Im_B=Im1(:,:,3);

for ind=1:iter,
    S_R=fixFilt2D(Im_R,3);
    S_G=fixFilt2D(Im_G,3);
    S_B=fixFilt2D(Im_B,3);
	    
    Im_R=syntFilt2D2(S_R,C_R,1);
    Im_G=syntFilt2D2(S_G,C_G,1);
    Im_B=syntFilt2D2(S_B,C_B,1);
    figure(2);imagesc(imclamp(reshape([Im_R Im_G Im_B],[size(Im_R) 3]),1));
    axis image;
    bigTitle(sprintf('Iteration %d result',ind));
    drawnow;
end
