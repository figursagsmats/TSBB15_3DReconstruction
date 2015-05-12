function [ result ] = images_equal( I1,I2 )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

bw = (I1 ==I2);
if( sum(sum(sum(bw))) == numel(bw))
    result = true;
else
    result = false;
end
    
end

