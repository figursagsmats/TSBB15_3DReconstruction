function [ images ] = load_dataset( directory, fileExtension )
%LOAD_DATASET Loads all images of a specific type in a dirctory into a
%struct
myDir = '../datasets/dino/images/';
%and extension of all images are jpg

ext_img = '*.ppm';
%now load images in a;

%List contents of the specified directory (of specific extenstion)
a = dir([myDir ext_img]);

% number of image files
nfiles = max(size(a)) ; 

%initialize struct for performace
images(nfiles) = struct();
%now loop to read the images
for i=1:nfiles
  images(i).img = imread([directory a(i).name]);
end

end

