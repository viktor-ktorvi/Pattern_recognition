function [V, v0_min_error, min_error] = optimal_linear_procedure(s, training_data, training_labels)
M1 = mean(training_data(:, training_labels == 1), 2);
M2 = mean(training_data(:, training_labels == 2), 2);

S1 = cov(training_data(:, training_labels == 1)');
S2 = cov(training_data(:, training_labels == 2)');

V = (s * S1 + (1 - s) * S2)^(-1) * (M2 - M1);
y1 = V' * training_data(:, training_labels == 1);
y2 = V' * training_data(:, training_labels == 2);

low = -max(max(y1), max(y2));
high = -min(min(y1), min(y2));
v0_min_error = low;
min_error = length(training_data);
for v0 = low:0.1:high
%     figure; grid on; hold on; axis equal;
%     labels = {};
%     plot(training_data(1, training_labels == 1), training_data(2, training_labels == 1), 'b*'); labels{end+1} = 'A';
%     plot(training_data(1, training_labels == 2), training_data(2, training_labels == 2), 'r*'); labels{end+1} = 'B';
%     title("Obucavajuci skup")
%     xlabel("$x_1$")
%     ylabel("$x_2$")
%     
%     syms x1 x2
%     X = [x1;x2];
%     fimplicit(V' * X + v0); labels{end + 1} = "$h(x) = V^T X + v_0$";
    errors1 = sum(double(y1 > -v0));
    errors2 = sum(double(y2 < -v0));

    if (errors1 + errors2) < min_error
        min_error = errors1 + errors2;
        v0_min_error = v0;
    end
end


end

