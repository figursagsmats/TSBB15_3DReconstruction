%% Test for noise-function

clear
clc
p = [1:20;
     1:20];

% This is a "slow" method, but does not matter for small nPoints
% This part should be refactored.
nPoints = 100;
for i = 1:nPoints
    a = add_noise(p(:,1));
    x(i) = a(1,1);
    y(i) = a(2,1);
end

figure
plot(p(1,1), p(2,1), '*r');
hold on
plot(x, y, 'x');
axis([0 2 0 2])


