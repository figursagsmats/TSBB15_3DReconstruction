%function Im=imclamp(Im0,lim)
%
% Clamp the intensity values of an image to
% fit the range [0,lim]
%
%Per-Erik Forssen, 1998

function Im=imclamp(Im0,lim)

[ys,xs,cs]=size(Im0);

if (cs~=1)&(cs~=3)
    error('Im0 should be a BW or an RGB image');
end

Im=Im0.*(Im0>=0).*(Im0<=lim)+(Im0>lim).*lim;
    
