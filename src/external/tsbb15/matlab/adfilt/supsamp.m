%function Im=supsamp(Im0,pads)
%
% Super sample a Matlab array along dimensions 1 and 2.
% 
% PADS is the number of interpolations to make.
%      ie pads=1 means double the amount of samples
%         along each dimension.
%
%Per-Erik Forssen, 1998

function Im=supsamp(Im0,pads)

[ys,xs,cs]=size(Im0);

if (cs~=1)&(cs~=3)
    error('Im0 should be either a BW or an RGB image.');
end

if (cs==1)
    Im=interp2(Im0,pads,'linear');
    Im=[Im Im(:,end)];
    Im=[Im; Im(end,:)];
end

if (cs==3)
    Im_R=interp2(Im0(:,:,1),pads,'linear');
    Im_R=[Im_R Im_R(:,end)];
    Im_R=[Im_R; Im_R(end,:)];
    Im_G=interp2(Im0(:,:,2),pads,'linear');
    Im_G=[Im_G Im_G(:,end)];
    Im_G=[Im_G; Im_G(end,:)];
    Im_B=interp2(Im0(:,:,3),pads,'linear');
    Im_B=[Im_B Im_B(:,end)];
    Im_B=[Im_B; Im_B(end,:)];
    Im=reshape([Im_R Im_G Im_B],[size(Im_R) 3]);
end
