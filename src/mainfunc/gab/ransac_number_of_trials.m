function [nIterations] = ransac_number_of_trials(p, w, s)
% RANSAC_NUMBER_OF_TRIALS  Calculates the number of iterations for RANSAC
%       
% [nIterations] = RANSAC_NUMBER_OF_TRIALS(p, w, s)
% 
% Input: p - [0 1] Should be around 0.99. Probability for success-rate 
%        w - Should be around 0.5. Probability for drawing an outlier
%        s - Number of samples. Example: 8 for 8-points algorithm
% Output: nIterations - Proposed number of iterations

nIterations = log(1-p)/log(1-w^s);

end