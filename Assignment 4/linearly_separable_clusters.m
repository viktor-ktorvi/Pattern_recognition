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
step = 0.5;
%%
do_search = false;

if do_search
    search_step = 0.1;
    sigma = 0.2:search_step:3;
    beta = 0.2:search_step:3;

    mse = zeros(length(sigma), length(beta));
    tic
    for i = 1:length(sigma)
        for j = 1:length(beta)
            [centers, ~, ~, ~, ~] = mountain_clustering_centers(all_samples, L, sigma(i), beta(j), axis_scale, step);
            mses = zeros(L, 1);
            for k = 1:L
                M_array = circshift(M, k, 2);
                mses(k) = sum(abs(centers - M_array), 'all');
            end

            mse(i, j) = min(mses);
        end
    end
    toc
    %%

    [X, Y] = meshgrid(beta, sigma);
    figure;
    s = surf(X, Y, mse);
    s.EdgeColor = 'none';
    title("MSE")
    xlabel("$\beta$")
    ylabel("$\sigma$")
    zlabel("$mse$")
    %%
    [minimum_mse, argminimum] = min(mse(:));
    [sigma_subscript, beta_subscript] = ind2sub(size(mse), argminimum);

    minimum_mse
    beta = beta(beta_subscript)
    sigma = sigma(sigma_subscript)
else
    beta = 2;
    sigma = 1.1;
end
step = 0.1;
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
initialization_name = 'stochastic';
cl = Cluster(all_samples, L, initialization_name, centers);
markers = {'bx', 'rx', 'yx', 'gx'};
figure
cl.plot(markers)
title("Inicijalizacija")
xlabel("$x_1$")
ylabel("$x_2$")
%
J_cmean = @(X, P, M, S) ((X - M)' * (X - M));
J_quad = @(X, P, M, S) (0.5 * (-log(P) + log(det(S)) + (X - M)' * S^(-1) * (X - M)));
max_iter = 100;
l = cl.quadratic_decomposition(J_cmean, max_iter)
%%
figure
cl.plot(markers)
title("Klasterizacija - cmean")
xlabel("$x_1$")
ylabel("$x_2$")
%%
cl_q = Cluster(all_samples, L, initialization_name, centers);

figure
cl_q.plot(markers)
title("Inicijalizacija")
xlabel("$x_1$")
ylabel("$x_2$")
%

max_iter = 100;
l = cl_q.quadratic_decomposition(J_quad, max_iter)
%%
figure
cl_q.plot(markers)
title("Klasterizacija - kvadratna dekompozicija")
xlabel("$x_1$")
ylabel("$x_2$")
