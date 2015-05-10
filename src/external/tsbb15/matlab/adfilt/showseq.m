%function showseq(sequence,sf,ef,n)
%
% Function to show a black and white image sequence
% stored in a matrix.
%
% SEQUENCE is a YxXxF volume where F is the number of
%          frames.
% SF       is the number of the first frame to show
% EF       is the number of the last frame to show
% N        is the number of times to play the movie.
%
% If just one argument is given, the entire sequence
% will be played once.
%
% If all four arguments are supplied, the sequence will
% first be cycled once, slowly while a Matlab movie is
% generated. This will be followed by one slightly jerky
% (a Matlab feature) and N smooth cycles.
%
%See also ICREAD
%
%Per-Erik Forssen, 1998

function showseq(sequence,sf,ef,n)

subplot(1,1,1);
colormap([1:255]'/255*[1 1 1]);

if nargin==1

    [y x f]=size(sequence);

    for i=1:f,
	image(sequence(:,:,i));
	title(['Frame ' num2str(i)]);
	axis image;
	pause(0.3);
    end;
else
    if nargin==4
	M=moviein(ef-sf+1);
	for i=sf:ef
	    image(sequence(:,:,i));
	    title(['Frame ' num2str(i)]);
	    axis image;
	    M(:,i-sf+1)=getframe;
	end;
	movie(M,n);
    else error('Wrong number of input arguments');
    end;
end;