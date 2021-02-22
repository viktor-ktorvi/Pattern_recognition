clc;
close all;
clear all;


set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%%
L = 2;
N = 5000;
%%
R  = 5;
sigma = 0.2;

all_samples = zeros(2, N);
theta = randn([N, 1])*pi/6 + pi/2;

figure;
histogram(theta)

x = R*cos(theta) + randn(N, 1) * sigma;
y = R*sin(theta) + randn(N, 1) * sigma;
all_samples(1, 1:N) = x;
all_samples(2, 1:N) = y;
%%
mb = [0; 0];
sigma_b = [R/10; R/10];
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
sigma = 0.7;
beta = 2;
[centers, mountain_function, X, Y, ~] = mountain_clustering_centers(all_samples, L, sigma, beta, axis_scale, step);

figure;
s = surf(X, Y, mountain_function);
s.EdgeColor = 'none';
title("Mountain funkcija")
xlabel("$x_1$")
ylabel("$x_2$")
zlabel("$m(v)$")
%%
initialization_name = 'stochastic';
cl = Cluster(all_samples, L, initialization_name, centers);
markers = {'bx', 'rx', 'yx', 'gx'};
figure
cl.plot(markers)
title("Inicijalizacija")
xlabel("$x_1$")
ylabel("$x_2$")
%%
J = @(X, P, M, S) (0.5 * (-log(P) + log(det(S)) + (X - M)' * S^(-1) * (X - M)));
max_iter = 100;
l = cl.quadratic_decomposition(J, max_iter)

%%
figure; axis equal; grid on;
cl.plot(markers)
title("Klasterizacija")
xlabel("$x_1$")
ylabel("$x_2$")

hold on
syms x1 x2
X = [x1;x2];
fimplicit(J(X, cl.P{1}, cl.M{1}, cl.S{1}) - J(X, cl.P{2}, cl.M{2}, cl.S{2}) == 0)
