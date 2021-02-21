clc;
close all;
clear variables;

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
%%
ma = [3; 4]; 
mb = [12; 0];
mc = [3; -4];

sigma_a = [1.7; 1.5];
sigma_b = [3; 1.4];
sigma_c = [1.7; 1.5];

rho_a = 0.6;
rho_b = 0.0;
rho_c = -0.6;

num_a = 5000;
num_b = 5000;
num_c = 5000;
%%
A = Samples(ma, sigma_a, rho_a, num_a);
B = Samples(mb, sigma_b, rho_b, num_b);
C = Samples(mc, sigma_c, rho_c, num_c);
%%
% plotting samples
figure; grid on; hold on; axis equal;
labels = {};

A.plot('b.'); labels{end+1} = '1';
B.plot('r.'); labels{end+1} = '2';
C.plot('g.'); labels{end+1} = '3';

title("Svi odbirci - 3 klase");
xlabel('$x_1$')
ylabel('$x_2$')
legend(labels)
%%
all_samples = [A.samples, C.samples, B.samples];
all_labels = [ones(num_a + num_c, 1); repmat(2, num_b, 1)];
%%
figure; grid on; hold on; axis equal;
labels = {};
plot(all_samples(1, all_labels == 1), all_samples(2, all_labels == 1), 'b.'); labels{end+1} = '1';
plot(all_samples(1, all_labels == 2), all_samples(2, all_labels == 2), 'r.'); labels{end+1} = '2';
title("Svi odbirci");
xlabel('$x_1$')
ylabel('$x_2$')
legend(labels)
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
%%
U = ones(6, length(training_data));
U(2:3, :) = training_data;
U(4, :) = training_data(1, :) .^ 2;
U(5, :) = training_data(1, :) .* training_data(2, :);
U(6, :) = training_data(2, :) .^ 2;

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
Z = [1;x1;x2;x1^2;x1*x2;x2^2];
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
Z = [1;x1;x2;x1^2;x1*x2;x2^2];
fimplicit(W' * Z); labels{end + 1} = "$h(Z) = W^T Z$";
legend(labels)