clc;
close all;
clear all;


set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%%
L = 2;
N = 500;
%%
R  = 5;
sigma = 0.2;

all_samples = zeros(2, N);
theta = rand([N, 1]) * pi;

x = R*cos(theta) + randn(N, 1) * sigma;
y = R*sin(theta) + randn(N, 1) * sigma;
all_samples(1, 1:N) = x;
all_samples(2, 1:N) = y;
%%
mb = [0; 0];
sigma_b = [R/3; R/3];
rho_b = 0;
B = Samples(mb, sigma_b, rho_b, N);
all_samples(:, N + 1:2*N) = B.samples;
%%
figure; grid on; hold on; axis equal;
plot(all_samples(1, :), all_samples(2, :), 'b.');
title("Svi odbirci")
xlabel("$x_1$")
ylabel("$x_2$")
axis_scale = 1.3;
step = 0.1;
sigma = 1;
beta = 2;
[centers, mountain_function, X, Y, ~] = mountain_clustering_centers(all_samples, L, sigma, beta, axis_scale, step);

figure;
s = surf(X, Y, mountain_function);
s.EdgeColor = 'none';
title("Mountain funkcija")
xlabel("$x_1$")
ylabel("$x_2$")
zlabel("$m(v)$")
