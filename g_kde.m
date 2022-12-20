clc;
close all;
rng default  % for reproducibility
x =[.5*randn(500,1); 10+3*randn(500,1)];
max(x)
min(x)
% x=[1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2  2 2  2 2 2 2 2  2 2 2 3 3 3 3 0 0  0 0 0  0 0 0 ]*0.5;
[f,xi,bw] = ksdensity(x,'npoints',25);
bw
f2 = ksdensity(x,[-3.230, 2.6689, 8.5699])
figure
plot(xi,f);
hold on;
histogram(x,'BinWidth',0.3,'Normalization','pdf')