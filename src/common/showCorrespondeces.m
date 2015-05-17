function [ h ] = showCorrespondeces(I1,I2,idxs1,idxs2,inlierIndexes)
% Visualise a list of correspondences by
% drawing a line between the points in I1 and I2.
% inspired by Per-Erik Forssen's function show_corresp.
%
% Author: Gustav Lagnström

if(nargin<5)
    inlierIndexes = zeros(size(idxs1,2));
end

if(size(I1)~=size(I2))
    disp('error: images not same size');
else
    width = size(I1,2);
    x1 = idxs1(1,:);
    y1 = idxs1(2,:);
    x2 = idxs2(1,:);
    y2 = idxs2(2,:);
   
    x2 = x2+width;
    
    h = figure('Position', [100, 100, 1049, 895],'Name', 'Correspondences')    
    imshow([I1 I2], []);
    hold on
    for i = 1:size(idxs1,2)
        markerType = 'ro-';
        if(sum(ismember(inlierIndexes,i))>0)
            markerType = 'go-';
        end
                  
        x = [x1(i) , x2(i)];
        y = [y1(i) , y2(i)];
        plot(x,y,markerType);
    end
    
    plot(x2,y2,'x');      
end
end