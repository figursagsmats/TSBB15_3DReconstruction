function [I J dTrue]=getCameraman();
%function [I J dTrue]=getCameraman();
%
%This function returns the cropped cameraman image,
%a cropped and displaced version, and the displacement vector.
%
% --- Output ---
%   'I'     : original cropped image
%   'J'     : displaced image
%   'dTrue' : used displacement
%

nBorder=10;

dTrue=[-2 1];
%rStart=1;%Uncomment to use a random dTrue
%dTrue=round((rand(1,2)-0.5)*2*rStart); 


%Get full cameraman
imgFull=double(imread('cameraman.tif'));

%Extract part of camerman
I=imgFull(nBorder+1:end-nBorder,nBorder+1:end-nBorder);        

%Extract shifted version of cameraman
J=imgFull(nBorder-dTrue(1)+1:end-nBorder-dTrue(1),nBorder-dTrue(2)+1:end-nBorder-dTrue(2));
