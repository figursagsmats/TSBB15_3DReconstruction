%function IM=tens2RGB(T)
%
% function to convert a tensor field in T3 form to
% RGB colour representation viewable with the IMAGE command. 
%
% ie for a tensor T=[1 3;3 2] the T3 form is T3=[1 2 3]'
%
% The colour representation is obtained by projecting the
% tensors in T onto four tensors with eigenvectors pointing in
% the directions 0,pi/4,pi/2 3pi/2. The projections are then
% used as coefficients in colour space for the colours
% Green, Blue, Red and Yellow respectively.
% Finally the RGB intensities in the output scene are scaled to
% fit the range [0,1]
%
% A nice feature of this representation is that isotropic tensors
% will be displayed as brownish white.
%
% see also IMAGE,GOPIMAGE
%
%Per-Erik Forssen, 1998
%


