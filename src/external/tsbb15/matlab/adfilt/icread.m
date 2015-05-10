%function A = icread(fname,zs)
%
% Reads an .ic image sequence into a Matlab matrix.
% 
% FNAME is the name of the directory containing the sequence
%       
% ZS is the number of images in the sequence
%
%Per-Erik Forssen, 1998

function A = icread(fname,zs)

% First extract name of sequence
% i.e. '/site/bb/testim/demo.ic' becomes 'demo'

sls = findstr(fname,'/');
[dummy lel] = size(sls);
if lel>0
    name_start = sls(lel)+1;
else
    name_start = 1;
end;
sls = findstr(fname,'.');
[dummy lel] = size(sls);
if lel>0
    name_end = sls(lel)-1;
else
    [dummy name_end] = size(fname);
end;

lname = fname(name_start:name_end);

% First find the size of the images:

[xs,ys]=size(imfread(sprintf('%s/%s_%d.imf',fname,lname,0)));

A=uint8(zeros(xs,ys,zs));
for i=0:zs-1,
   name = sprintf('%s/%s_%d.imf',fname,lname,i);
   A(:,:,i+1)=uint8(255*imfread(name));
end;