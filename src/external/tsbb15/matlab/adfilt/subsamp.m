%function Im=subsamp(Im0,scale)
%
% Subsample a Matlab array along dimensions 1 and 2.
%
% SCALE is the downsample ratio. (integer)
%
%Per-Erik Forssen, 1998

function Im=subsamp(Im0,scale)

[nf,mf,cf] = size(Im0);

if (cf~=1)&(cf~=3)
    error('Im0 should be either a BW or an RGB image.');
end

if scale>1
    lpx=gausskernel(scale/1.5,0.05)';
    if cf==1
	Im=conv2(lpx',lpx,Im0,'same');
	Im=Im(1:scale:end,1:scale:end);
    end
    if cf==3
	Im_R=conv2(lpx',lpx,Im0(:,:,1),'same');
	Im_R=Im_R(1:scale:end,1:scale:end);
	Im_G=conv2(lpx',lpx,Im0(:,:,2),'same');
	Im_G=Im_G(1:scale:end,1:scale:end);
	Im_B=conv2(lpx',lpx,Im0(:,:,3),'same');
	Im_B=Im_B(1:scale:end,1:scale:end);
	Im=reshape([Im_R Im_G Im_B],[size(Im_R) 3]);
    end
else
	Im = Im0;
end
