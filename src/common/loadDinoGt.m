function [ BK, Ps ] = loadDinoGt(version)

if(nargin > 0)
    if( version == 1)
        ver = 'original';

    elseif( version == 2)
        ver = 'liu';
    end
    
else
    ver = 'liu';
end
if(strcmp(ver,'original'))


end

if(strcmp(ver,'liu'))
    gt = load('../datasets/dino/dino_gt.mat');
    %switch so that views are rows and points are cols.
    BK = permute(gt.points2DMatrix,[2 1 3]);
    Ps = gt.newPs; 
    
else
    pwd
    Ps = load('../datasets/dino2/dino_Ps.mat');
    addpath('../datasets/dino2/') %loader functions
    load viff.xy;
    Ps = Ps.P;
    x = viff(1:end,1:2:72)';  % pull out x coord of all tracks
    y = viff(1:end,2:2:72)';  % pull out y coord of all tracks
    
    BK(:,:,1) = y;
    BK(:,:,2) = x;
    
end
end
