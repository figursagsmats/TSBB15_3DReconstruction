%Test setup


%% CorrectNumberOfFilesLoaded
images = load_dataset('../datasets/dino/images/','*.ppm');

% we know that the dircectory containts 37 files. let's check if that is
% true

assert(length(images)==37)

