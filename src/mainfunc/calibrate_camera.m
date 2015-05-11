function [ K ] = calibrate_camera( dir,fileExtenstion )
% Takes a directory of calibration images and return instrinis camera
% parameters.

% INPUTS:
%       dir: directory path
%       fileExtension : *.jpg for examplse
%
% OUTPUTS:
%       K: instrinsic camera matrix 

% images = load_dataset(dir,fileExtenstion);


%TODO: implement

%FOR NOW: fetch from ground truth

Ps = load_dino_cmats_gt();
P = cell2mat(Ps(1)); %just takes first C matrix since all have same K
[K, r, c] = DecomposeCameraMatrix(P);

end

