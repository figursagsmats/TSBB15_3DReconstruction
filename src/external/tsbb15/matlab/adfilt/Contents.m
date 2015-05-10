% Adaptive filtering for the Computer Vision course.
% Version 1.2  01-Jul-1999
%
% Author: Per-Erik Forssen, perfo@isy.liu.se
%         Computer Vision Laboratory
%         Linköping University
%
% The adaptive filtering toolbox contains commands to perform 2D and 3D
% adaptive filtering (as described in the book "Signal Processing for 
% Computer Vision") and some additional commands for basic image and
% image sequence manipulation.
%
%
% Image and sequence operations.
%    readbw       - Read a IMF file into an uint8 variable.
%    showbw       - Display an uint8 array as a black and white image.
%    showcol      - Display a MxNx3 double array as a colour image.
%    icread       - Read a sequcence of IMF files into an uint8 variable.
%    showseq      - Display an uint8 sequcence in black and white.
%    imclamp      - restrict values in a Matlab array to [0,N].
%
% Eigensystem mapping functions.
%    msetup       - Set up the m-map function.
%    mysetup      - Set up the my-map function.
%    mapplot      - Plot the map functions.
%
% 2D adaptive filtering.
%   fixFilt2D     - Perform fixed filter convolutions.
%   tensOrient2D  - Compute a local orientation tensor field.
%   tensLP2D      - Low pass filter a tensor field.
%   tensMap2D     - Remap a tensor field according to the map functions.
%   syntFilt2D    - Synthesize the output of an adaptive filter.
%
% 2D tensor visualization.
%   tens2RGB      - Convert a 2D tensor field to an RGB image.
%   tensShow2D    - Visualize a 2D tensor.
%   tensorshape2D - Visualize the eigensystem of a 2D tensor.
%
% 3D adaptive filtering.
%   fixFilt3D     - Perform fixed filter convolutions.
%   tensOrient3D  - Compute a local orientation tensor field.
%   makeKernel3D  - Convert a 1D kernel to 3D.
%   tensLP3D      - Low pass filter a tensor field.
%   tensMap3D     - Remap a tensor field according to the map functions.
%   syntFilt3D    - Synthesize the output of an adaptive filter.
%   syntSlice3D   - Synthesize the output of the filter in one frame.
%
% 3D tensor visualization.
%   tensShow3D    - Visualize a 3D tensor.
%   tensorshape3D - Visualize the eigensystem of a 3D tensor.
%
% Other functions.
%   tensConv3     - 3D convolution that discards zeroes in the kernel.
%   gausskernel   - Creates a 1D gaussian kernel.
%   tens2eig      - Compute the eigensystem of a 2D or 3D tensor.
%   subsamp       - subsample a Matlab array.
%   supsamp       - super sample a Matlab array.
%   tensNorm2D    - Compute Frobenius norm of a set of 2D tensors.
%   syntFilt2D2   - as syntFilt2D, but returns double instead of uint8.
%   makeKernel3D  - used by tensOrient3D.
%

