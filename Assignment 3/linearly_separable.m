clc;
close all;
clear variables;

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%%
ma = [3; 4]; 
mb = [4; -4];

sigma_a = [1.7; 1.5];
sigma_b = [3; 2.4];

rho_a = 0.6;
rho_b = -0.7;

num_a = 5000;
num_b = 5000;
%%
A = Samples(ma, sigma_a, rho_a, num_a);
B = Samples(mb, sigma_b, rho_b, num_b);
%%
% plotting samples
figure; grid on; hold on; axis equal;
labels = {};

A.plot('b.'); labels{end+1} = '1';
B.plot('r.'); labels{end+1} = '2';

title("Svi odbirci");
xlabel('$x_1$')
ylabel('$x_2$')
legend(labels)
%%
all_samples = [A.samples, B.samples];
all_labels = [ones(num_a, 1); repmat(2, num_b, 1)];
%%
to_train = rand(length(all_samples), 1) < 0.7;

training_data = all_samples(:, to_train);
training_labels = all_labels(to_train);

testing_data = all_samples(:, ~to_train);
testing_labels = all_labels(~to_train);
%%
figure; grid on; hold on; axis equal;
labels = {};
plot(training_data(1, training_labels == 1), training_data(2, training_labels == 1), 'b*'); labels{end+1} = '1';
plot(training_data(1, training_labels == 2), training_data(2, training_labels == 2), 'r*'); labels{end+1} = '2';
title("Obucavajuci skup")
xlabel("$x_1$")
ylabel("$x_2$")
legend(labels)
%% Iterativni postupak
s = 0:0.01:1;
min_error = zeros(length(s), 1);
for i = 1:length(s)
    [~, ~, min_error(i)] = optimal_linear_procedure(s(i), training_data, training_labels);
end
%%
figure;
plot(s,  min_error)
title("Ukupna greska za razlicito $s$")
xlabel("s")
ylabel("greska")
%%
[~, argmin_error] = min(min_error);
[V, v0, ~] = optimal_linear_procedure(s(argmin_error), training_data, training_labels);
%%
figure; grid on; hold on; axis equal;
labels = {};
plot(testing_data(1, testing_labels == 1), testing_data(2, testing_labels == 1), 'b.'); labels{end+1} = '1';
plot(testing_data(1, testing_labels == 2), testing_data(2, testing_labels == 2), 'r.'); labels{end+1} = '2';
title("Testirajuci skup")
xlabel("$x_1$")
ylabel("$x_2$")

syms x1 x2
X = [x1;x2];
fimplicit(V' * X + v0); labels{end + 1} = "$h(x) = V^T X + v_0$";
legend(labels)
%% Metoda zeljenog izlaza
U = ones(3, length(training_data));
U(2:end, :) = training_data;
U(:, training_labels == 1) = -U(:, training_labels == 1);
G = ones(length(training_labels), 1);
W = (U * U')^(-1) * U * G;
%%
figure; grid on; hold on; axis equal;
labels = {};
plot(testing_data(1, testing_labels == 1), testing_data(2, testing_labels == 1), 'b.'); labels{end+1} = '1';
plot(testing_data(1, testing_labels == 2), testing_data(2, testing_labels == 2), 'r.'); labels{end+1} = '2';
title("Testirajuci skup - zeljeni izlazi isti")
xlabel("$x_1$")
ylabel("$x_2$")

syms x1 x2
Z = [1;x1;x2];
fimplicit(W' * Z); labels{end + 1} = "$h(Z) = W^T Z$";
legend(labels)
%%
G(training_labels == 2) = G(training_labels == 2) * 2;
W = (U * U')^(-1) * U * G;
%%
figure; grid on; hold on; axis equal;
labels = {};
plot(testing_data(1, testing_labels == 1), testing_data(2, testing_labels == 1), 'b.'); labels{end+1} = '1';
plot(testing_data(1, testing_labels == 2), testing_data(2, testing_labels == 2), 'r.'); labels{end+1} = '2';
title("Testirajuci skup - zeljeni izlazi za drugu klasu veci")
xlabel("$x_1$")
ylabel("$x_2$")

syms x1 x2
Z = [1;x1;x2];
fimplicit(W' * Z); labels{end + 1} = "$h(Z) = W^T Z$";
legend(labels)