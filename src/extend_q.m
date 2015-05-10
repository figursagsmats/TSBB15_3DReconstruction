function [ Q ] = extend_q( Rt,K,Q )
%EXTEND_Q Extends Q-struct with another Rt. If no Q is given as input, a
%new Q will be created.

if(nargin<3)
    Q = struct();
    Q(1).Rt = Rt;
    Q(1).K = K;
else
    Q(end+1).Rt = Rt;
    Q(end).K = K;
end

end

