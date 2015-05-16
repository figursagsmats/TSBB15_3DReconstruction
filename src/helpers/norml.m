function [ ret ] = norml( vec )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if(size(vec,1)==3)
    
ret(1,:) = vec(1,:)./vec(3,:);
ret(2,:) = vec(2,:)./vec(3,:);

elseif(size(vec,1)==4)
ret(1,:) = vec(1,:)./vec(4,:);
ret(2,:) = vec(2,:)./vec(4,:);
ret(3,:) = vec(3,:)./vec(4,:);
end


end

