function H=gausskernel(stdv,maxedge)
%function H=gausskernel(stdv,maxedge)
%
% Creates a one-dimensional gaussian smoothening kernel
% with standard deviation STDV and a value less than
% MAXEDGE at the rim. The size of the kernel is adjusted
% accordingly.
%
%Per-Erik Forssen, 1998

if(maxedge>=1)
    error('MAXEDGE must be less than one.');
end;
ksize = 1+2*ceil(1.23*stdv*sqrt(-log(maxedge)));
H=zeros(ksize,1);
for i=1:ksize,
  H(i)=normpdf(i-ksize/2-.5,0,stdv);
end;
H=H/sum(H);
