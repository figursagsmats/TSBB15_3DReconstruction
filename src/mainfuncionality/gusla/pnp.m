function [ Rt, inlierIndexes] = pnp( S )

Rt = eye(3,4);

inlierIndexes = 1:length(S.bkIndexes);
end

