%function sigOut = fixFilt2D3(imv,kern_no)
%
% THIS FUNCTION IS THE SAME AS AS fixFilt2D BUT WITH VERBOSITY TURNED OFF
%
% Modified by Klas Nordberg Dec 2006
%
%  This routine will compute a set of fixed filter responses, and
%  place the result in a YxXxN matrix, where N is the number of
%  fixed filters.
%
%  IMV     is the input image volume.
%  KERN_NO is the number of the filter set to be used. Valid
%          numbers are 1-4.
%
% See "Signal Processing For Computer Vision" section 10.4
%
%Per-Erik Forssen, 1998
%
function sigOut = fixFilt2D3(imv,kern_no);

[ysz,xsz] = size(imv);

%
% Read fixed filter kernels
% 
if (kern_no>=1)&(kern_no<5)&(kern_no-floor(kern_no)==0)
  name=sprintf('kernels/enh2D_%d.mat',kern_no);
  load(name);
else
  error('Valid filter set numbers are 1-4');
end;
%
% Perform the actual convolutions
%
%disp('Performing fixed filter convolutions...');
slp=conv2(slp,slp2,imv,'same');
s1=conv2(g1,f1,imv,'same');
s2=conv2(conv2(imv,f2,'same'),g2,'same');
s3=conv2(f3,g3,imv,'same');
s4=conv2(conv2(imv,f4,'same'),g4,'same');

sigOut=reshape([slp(:) s1(:) s2(:) s3(:) s4(:)],[ysz,xsz,5]);

