function [ featurePoints ] = find_feature_pts( I )


%FORNOW: just get the shit from GT
%images = load_dataset('../datasets/dino/images/','*.ppm');
global images;
pointsTable = load_dino_gt();

for i = 1:length(images)
    I2 = images(i).img;
    if(isequal(I2,I))
        pts = get_view_pts(pointsTable,i);
        mask = (pts(1,:) > -1); 
        featurePoints = pts(:,mask);
        break;
    end
end



end

