close all;clear all;clc
%Add directoried to path
if ~exist('getCameraman.m','file') %simply check if a certain functions exists...
    fprintf('Adding external dependencies to path... \n')
    addpath(genpath('external')) %external functions
    addpath(genpath('../datasets/dino')) %datasets
end
% RUN TESTS
%testResults = table(runtests())

% GET DATASET AND CALIBRATE
images = load_dataset('../datasets/dino/images/','*.ppm');
K = calibrate_camera('../datasets/dino/calibration','*.ppm');

% CREATE POINTS TABLE
% for i = 1:length(images)
%     feature_pts = find_feature_pts(images(i));
%     pointsTable = match(feature_pts);
% end

pointsTable = load_dino_2dpts_gt(); %FORNOW

% INITIATION PART
console_heading('INIT');
[pointsTable, viewImageMapping, nViews] = rearrange_views(pointsTable);

[pts1,pts2] = get_correspondces(1,2,pointsTable);

E = estimate_essential_matrix(pts1,pts2,K);

Rt = estimate_rt(E, pts1(:,1),pts2(:,1));

Q = extend_q(eye(4),K);
Q = extend_q(Rt,K,Q);

%P = triangulate_3d_pts(Q(1),Q(2),pts1,pts2);
P = zeros(2,size(pointsTable,2));
BK = [];
% ITERATION PART
console_heading('ITERATION');
for viewIndx = 3:nViews
    
    [P,Q,BK] = bundle_adjustment(P,Q,BK,pointsTable);
    BK = remove_bad_3dpts(BK);
    
    [x1,x2,X] = get_correspondces(1,2,pointsTable,P);
    
    S = estimate_tentative_pts(x1,x2,X);
    Rt = pnp(S);
    BK = add_view_to_bk(S,BK);
    Q = extend_q(Rt,K,Q);
    E = estimate_essential_matrix(x1,x2,K);
  
    [BK,P] = add_pts_to_bk(E,pointsTable,S,P,BK); 
    BK = wash_2(BK);
    
end
console_heading('EVALUATION');
% EVALUATION PART

