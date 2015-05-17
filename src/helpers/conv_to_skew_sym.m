function [ skew_sym_mat ] = conv_to_skew_sym( vec )
%CONV_TO_SKEW_SYMs Convert vector to skew-symmetric matrix

skew_sym_mat = [0     -vec(3)   vec(2); 
               vec(3)    0     -vec(1); 
              -vec(2)  vec(1)     0];
end