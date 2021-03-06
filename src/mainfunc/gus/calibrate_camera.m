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

[pointsTable Ps] = load_dino_gt();
P = cell2mat(Ps(1)); %just takes first C matrix since all have same K.

% Split the projection matrix P (camera matrix C) into an internal camera
% matrix K and a rotation matrix R. Use QR-decomposition.
[K, R] = DecomposeCameraMatrix(P);

end

