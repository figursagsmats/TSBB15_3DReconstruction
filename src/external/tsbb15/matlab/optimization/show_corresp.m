%function h=show_corresp(imageLeft, imageRight,P1,P2,cl)
%
% Visualise a list of correspondences by
% drawing a line between the points in
% image1 and in image2.
%
% imageLeft:    Left image
% imageRight:   Right image
% P1:    List of points in image1 in a 2xN matrix.
% p1:    List of points in image2 in a 2xN matrix.
% cl:    Correspondence list in a 2xN matrix
% 
%
% i.e. points P1(cl(k,1),:) and P2(cl(k,2),:)
% correspond.
%
%Per-Erik Forssen, Nov 2004, johan hedborg, 2013, Marcus Wallenberg, 2014

function h=show_corresp(imageLeft, imageRight, P1, P2, cl)

if nargin < 5
    %transpose cl so that the external interface is the same for all matrices
    cl=([1:size(P1,2)]'*[1 1])';
end

% Check the format of P1 and P2
if (size(P1, 1) ~= 2 || size(P2, 1) ~= 2)
    error('P1 and P2 must be represented by a 2xN matrix');
end

%transpose cl so that the external interface is the same for all matrices
cl = cl';
P1 = P1';
P2 = P2';

Nc=size(cl,1);

hold off;
image([imageLeft imageRight]);axis image
xoff=size(imageLeft,2);
h=zeros(Nc,1);
hold on
for k=1:Nc,
  li=cl(k,1);
  ri=cl(k,2);
  h(k)=plot([P1(li,1) P2(ri,1)+xoff],[P1(li,2) P2(ri,2)],'ro-');
end

if nargout==0,
  clear('h');
end