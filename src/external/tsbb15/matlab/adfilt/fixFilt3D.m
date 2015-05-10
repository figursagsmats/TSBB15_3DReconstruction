%function sigOut = fixFilt3D(imv,kern_no);
%
%  This routine will compute a set of fixed filters, and place
%  the result in a YxXxZxN matrix, where N is the number of
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
function sigOut = fixFilt3D(imv,kern_no);

[ysz xsz zsz]=size(imv);

%
% Read fixed filter kernels
%
if (kern_no>=1)&(kern_no<5)&(kern_no-floor(kern_no)==0)
  name=sprintf('kernels/enh3D_full_%d.mat',kern_no);
  load(name);
else
  error('Valid filter set numbers are 1-4');
end;
%
% Perform the actual convolutions
%
isuint = isa(imv,'uint8');

disp('Performing fixed filter convolutions...');
[lpsz dummy]=size(lpy);
fprintf('  Low pass with 3x%d coefficients\r',lpsz);
if isuint
    slp=tensConv3(tensConv3(tensConv3(double(imv),lpy),lpx),lpz);
else
    slp=tensConv3(tensConv3(tensConv3(imv,lpy),lpx),lpz);
end;
fprintf('  Filter 1(6) with %d coefficients\r',coeffs);
if isuint
    s1=tensConv3(double(imv),f1);
else
    s1=tensConv3(imv,f1);
end
fprintf('  Filter 2(6) with %d coefficients\r',coeffs);
if isuint
    s2=tensConv3(double(imv),f2);
else
    s2=tensConv3(imv,f2);
end
fprintf('  Filter 3(6) with %d coefficients\r',coeffs);
if isuint
    s3=tensConv3(double(imv),f3);
else
    s3=tensConv3(imv,f3);
end
fprintf('  Filter 4(6) with %d coefficients\r',coeffs);
if isuint
    s4=tensConv3(double(imv),f4);
else
    s4=tensConv3(imv,f4);
end
fprintf('  Filter 5(6) with %d coefficients\r',coeffs);
if isuint
    s5=tensConv3(double(imv),f5);
else
    s5=tensConv3(imv,f5);
end
fprintf('  Filter 6(6) with %d coefficients\r',coeffs);
if isuint
    s6=tensConv3(double(imv),f6);
else
    s6=tensConv3(imv,f6);
end
fprintf('Done. Reshaping result...           \n');
sigOut=reshape([slp(:) s1(:) s2(:) s3(:) s4(:) s5(:) s6(:)],[ysz,xsz,zsz,7]);
