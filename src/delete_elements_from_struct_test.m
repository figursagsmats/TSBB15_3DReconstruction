%Test setup
clear myStruct
orgLength = 40;
elementsToDelete = [1 2];
% create structure of size 40
myStruct(orgLength) = struct();
%fill struct
for i = 1:length(myStruct)
    myStruct(i).img = i;
end

%process struct, remove first two elements
myStruct = delete_elements_from_struct(myStruct,elementsToDelete);

%% CorrectSize
newLength = length(myStruct)
diff = orgLength - newLength;
assert(diff == length(elementsToDelete));

% CorrectsElementsRemoved
assert(myStruct(1).img == 3);