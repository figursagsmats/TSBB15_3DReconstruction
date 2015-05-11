pwd
addpath('../datasets/dino2/') %loader functions
load viff.xy;

i = find(viff== -1); % find where ends of tracks marked - indicator var
viff(i) = nan;       % changes these to nan

plot(viff(1,1:2:72),viff(1,2:2:72)) % plots track for point 1
plot(viff(1:end,1:2:72)',viff(1:end,2:2:72)') % plots all tracks
axis ij  % y in -ve direction

x = viff(1:end,1:2:72)';  % pull out x coord of all tracks
y = viff(1:end,2:2:72)';  % pull out y coord of all tracks

m = finite(x);  % selects tracks apart from nans

i = sum(m) > 6; % tracks longer than 6 views
plot(x(:,i),y(:,i)) 
axis ij