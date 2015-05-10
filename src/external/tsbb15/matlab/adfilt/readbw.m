%function IM=readbw(fname)
%
% Reads an imf file into a Matlab
% variable, scales it and converts
% it to uint8.
%
%Per-Erik Forssen, 1998

function IM=readbw(fname)

IM=uint8(max(0,min(255,255*imfread(fname))));