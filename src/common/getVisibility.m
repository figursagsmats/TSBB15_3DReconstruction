function nAppearances = getVisibility(pointIndex,BK)

appearances = BK(:,4,1) ~=-1 | BK(:,4,1) ~=-1;

nAppearances(sum(appearances));
end

