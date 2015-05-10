function [output] = console_heading( str )
% CONSOLE_HEADING  prints a heading with surrounding === to console

width = 20;
nEqualSigns = width-length(str)/2;
equalSigns = repeat_char('=',nEqualSigns);
output = [equalSigns ' '  str ' ' equalSigns];
disp(output)
end

