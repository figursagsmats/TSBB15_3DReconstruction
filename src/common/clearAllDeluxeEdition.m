function clearAllDeluxeEdition()
% Closes all figures, clears console and clears all variables but 
% preserves breakpoints. 
%
% If you want to remove all breakpoints just type clear all in console.

close all;
clc
s=dbstatus;
save('myBreakpoints.mat', 's');
clear all
load('myBreakpoints.mat');
dbstop(s);

end

