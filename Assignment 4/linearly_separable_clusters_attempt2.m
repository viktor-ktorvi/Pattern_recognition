clc;
close all;
clear all;


set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%%
L = 4;
N = 500;
%%
M = [-5, -7, 3, 8;
     -5,  7,-6, 8];
  
% rho = rand(1, L) * 2 - 1;
rho = [0.2, 0, 0.3, -0.4];
% sigma = randn(2, L)*0.18 + 1;
sigma = [2, 1, 1, 4;
         2.5, 1, 1.5, 1];
%%
samples = Samples.empty(L, 0);
all_samples = zeros(2, L*N);
for i = 1:L
    samples(i) = Samples(M(:, i), sigma(:, i), rho(i), N);
    all_samples(:, (i - 1)*N + 1:i*N) = samples(i).samples;
end
%%
figure; hold on; grid on; axis equal;
for i = 1:L
    samples(i).plot('bx')
end

title("Odbirci")
xlabel("$x_1$")
ylabel("$x_2$")
%%
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

figure; hold on; grid on; axis equal;
for i = 1:L
    samples(i).plot('bx')
end
contour(X, Y, mountain_function)
title("Mountain funkcija")
xlabel("$x_1$")
ylabel("$x_2$")
%%
initialization_name = 'mountain';
cl = Cluster(all_samples, L, initialization_name, centers);
markers = {'bx', 'rx', 'yx', 'gx'};
figure
cl.plot(markers)
title("Inicijalizacija")
xlabel("$x_1$")
ylabel("$x_2$")
%%
% J = @(X, P, M, S) ((X - M)' * (X - M));
J = @(X, P, M, S) (0.5 * (-log(P) + log(det(S)) + (X - M)' * S^(-1) * (X - M)));
max_iter = 100;
for l = 1:max_iter
    prev_cluster = cl.labels;
    for i = 1:length(cl.all_samples)
        X = cl.all_samples(:, i);
        J_vals = zeros(cl.L, 1);
        for j = 1:cl.L
            J_vals(j) = J(X, cl.P{j}, cl.M{j}, cl.S{j});
        end
        [~, arg_minimum] = min(J_vals);
        cl.labels(i) = arg_minimum;
    end
    cl.calc_params();
    
    if cl.labels == prev_cluster
        disp('Zavrsio normalno')
        break;
    end
end
%%
disp('ovde')
figure
cl.plot(markers)
title("Klasterizacija")
xlabel("$x_1$")
ylabel("$x_2$")

