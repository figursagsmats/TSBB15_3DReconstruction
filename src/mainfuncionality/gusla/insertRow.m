function BK = insertRow(BK,pts,indexes)

nPoints = size(pts,2);

if(nargin<3)
    indexes = 1:nPoints; 
end
if(isempty(BK))
    viewIndex = 1;
    BK = zeros(1,nPoints,2);
    n = nPoints;
else
    viewIndex = size(BK,1)+1;
    n = size(BK,2);
end
BK(viewIndex,:,1) = ones(1,n).*-1;
BK(viewIndex,:,2) = ones(1,n).*-1;
BK(viewIndex,indexes,1) = pts(1,:); % rows
BK(viewIndex,indexes,2) = pts(2,:); % cols

end

