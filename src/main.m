loadSubfolders();
clearAllDeluxeEdition();

% images is global for now to reduce loading times because
% findFeaturePoints is temporarily loading all images.
global images; 
images = load_dataset('../datasets/dino/images/','*.ppm');
K = calibrate_camera('../datasets/dino/calibration','*.ppm');
nViews = length(images);

VISIBILITY_THRESH = 5;
%Find feature points & correspondeces
ftPts1 = findFeaturePoints(images(1).img);
ftPts2 = findFeaturePoints(images(2).img);

ftPtsIdxMap = findCorrespondences(ftPts1,ftPts2,images(1).img,images(2).img);
[corrPts1,corrPts2,rest1,rest2] = spliceConcensus(ftPts1,ftPts2,ftPtsIdxMap);
recentUnmatchedPts = rest2;

showCorrespondeces(images(1).img,images(2).img,corrPts1,corrPts2);

%Estimate E
[F,inlinersIdxMap] = fundamentalMatrixRansac(corrPts1,corrPts2);
F = fundamentalMatrixGold(F,corrPts1,corrPts2);
E = essentialMatrix(F,K);

%Estimate Rt
Rt1 = eye(3,4);
Rt2 = estimateRt(E,K,corrPts1(:,1),corrPts2(:,1));

%Slice outilers (determined when F is estimated) from corresponding points
[corrPts1,corrPts2,rest1,rest2] = spliceConcensus(corrPts1,corrPts2,inlinersIdxMap);
recentUnmatchedPts = [recentUnmatchedPts rest2]; %appending list of unmatched points

%Initiate alla data structured neede for iteration
Q(1).Rt = Rt1;
Q(2).Rt = Rt2;
Q(1).K = K;
Q(2).K = K;

P = triangulate(Q(1),Q(2),corrPts1,corrPts2);
BK = [];
BK = insertRow(BK,corrPts1);
BK = insertRow(BK,corrPts2);

oldP = P;
[newP,Q,BK] = bundleAdjustment(oldP,Q,BK);
[P,BK] = removeBad3DPoints(BK,Q,oldP,newP); 

%Iteration
for k = 3:nViews;
    %Get feature points in last view from BK and their indexes.
    [prevFtPts, tableIndexes] = getFeaturePts(k-1,BK);
    
    %Extent previous feature points with unmatched feature points. 
    prevFtPts = [prevFtPts recentUnmatchedPts];
    
    %Index array extends with -1 indicating points not in BK
    tableIndexes = [tableIndexes ones(1,length(recentUnmatchedPts))*-1];
    
    %Find features in new view and correspondeces
    newFtPts = findFeaturePoints(images(k).img);
    if(k==20)
        aj =1;
    end
    ftPtsIdxMap = findCorrespondences(prevFtPts,newFtPts,images(k-1).img,images(k).img);
    
    %Now we need to slice consencus from both orgIndexes and feature points
    [corrPts1,corrPts2,rest1,rest2] = spliceConcensus(prevFtPts,newFtPts,ftPtsIdxMap);
    recentUnmatchedPts = rest2; %is this right?
    
    tableIndexes = tableIndexes(ftPtsIdxMap(1,:));
    
    [S,remainingCorrs1,remainingCorrs2] = createS(corrPts1,corrPts2,tableIndexes,P,BK);
    
    [Rt,inlierIndexes] = pnp(S,k);
    Q(k).Rt = Rt;
    Q(k).K = K;
    
    [C,U] = splitS(inlierIndexes,S);
    
    recentUnmatchedPts = [recentUnmatchedPts U.pts2];
    
    BK = insertRow(BK,C.pts2,C.bkIndexes);
    
    E = estimateEFromViews(Q(k-1).Rt, Q(k).Rt);
    
    % Add new 3D-points
    if(~isempty(remainingCorrs1))
        [remainingCorrs1,remainingCorrs2] = checkEpipolarConstraint(remainingCorrs1,remainingCorrs2, E);
        if(~isempty(remainingCorrs1))
            new3DPoints = triangulate(Q(k-1),Q(k),remainingCorrs1,remainingCorrs2);
            newBKCols = makeBKCols(BK,remainingCorrs1,remainingCorrs2,k-1,k);
            P = [P new3DPoints];
            BK = [BK newBKCols];            
        end
    end
        
    %WASH
    for i = 1:length(U.bkIndexes)
        pointIndex = U.ind(i);
        nAppearences = getVisibility(pointIndex,BK);
        if(nAppearences < VISIBILITY_THRESH)
            [BK,P] = removePoint(pointIndex,BK,P);
        end
    end
    
    oldP = P;
    [newP,Q,BK] = bundleAdjustment(oldP,Q,BK);
    [P,BK] = removeBad3DPoints(BK,Q,oldP,newP); 
    
end


    
