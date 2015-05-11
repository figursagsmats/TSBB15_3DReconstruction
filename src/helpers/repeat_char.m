function [ string ] = repeat_char(char,nTimes )
%repeat_char Repeats a character nTimes and returns a string 
if nargin < 2
    char = ' ';
end
string = '';
for i = 1:nTimes
    string = [string char];
end

end

