function [ input_struct ] = delete_elements_from_struct( input_struct,indexes )
%DELETE_ELEMENTS_FROM_STRUCT Deletes specified elements from a struct

    input_struct(indexes) = [];

end

