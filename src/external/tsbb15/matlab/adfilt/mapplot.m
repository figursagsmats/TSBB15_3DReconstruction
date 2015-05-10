%script to plot the m and my-functions, as setup by
%the functions MSETUP and MYSETUP, in the current figure
%
%              /      b    \ 1/j
%              |     x     |
%          m = | --------- |
%              |  b+a    b |
%              \ x    + s  /
%
%
%          /              b       \ 1/j
%          |       (x(1-a))       |
%     my = | -------------------- |
%          |        b          b  |
%          \ (x(1-a))  + (a(1-x)) /
%
%
%The m and my functions are displayed in the range [0,1].
%
%   See "Signal Processing for Computer Vision", page 315.
%
%Per-Erik Forssen, 1998

%In order to make the adaptive filtering exercise run
%smoother on 8bit palette systems, all images should
%have the same palette:

colormap([1:255]'/255*[1 1 1]); 

sb = adm_sigma ^ adm_beta;
if sb==0 sb=0.00000000001;end;

ba = adm_beta + adm_alpha;
onebyj = 1 / adm_j;


mapsize = 1000;
map = [0:1/(mapsize-1):1];

subplot(2,1,1);
plot(map,(map.^adm_beta./(map.^ba + sb)).^onebyj);
s=['m-function in range [0,1]       \sigma=' sprintf('%g ',adm_sigma) ...
   '\alpha =' sprintf('%g ',adm_alpha) '\beta=' ...
   sprintf('%g j=%g',adm_beta,adm_j)];
   title(s);

ra = 1 - admy_alpha;
onebyj = 1 / admy_j;

mapsize = 1000;
map = [0:1/(mapsize-1):1];

subplot(2,1,2);
plot((1:1000)/1000,((map*ra).^admy_beta./((map*ra).^admy_beta + (admy_alpha*(1-map)).^admy_beta)).^onebyj);
s=['\mu-function in range [0,1]       \alpha=' sprintf('%g ',admy_alpha) ...
   '\beta=' sprintf('%g j=%g',admy_beta,admy_j)];
title(s);
clear sb ba onebyj s ra map mapsize