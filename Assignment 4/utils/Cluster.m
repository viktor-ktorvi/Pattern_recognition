classdef Cluster < handle
    %cluSTER Summary of this objass goes here
    %   Detailed explanation goes here
    
    properties
        all_samples
        labels
        L
        M
        S
        P
    end
    
    methods
        function obj = Cluster(all_samples, L, initialization_name, centers)
            my_shuffle = @(v)v(:, randperm(length(v)));
            obj.all_samples = my_shuffle(all_samples);
            obj.L = L;

            obj.labels = zeros(length(all_samples), 1);
            
            if strcmp(initialization_name, 'stochastic')
                for i = 1:length(all_samples)
                    obj.labels(i) = randi(L);
                end
            elseif strcmp(initialization_name, 'mountain')
                for i = 1:length(all_samples)
                    
                    [~, argmin] = min(sum((centers - obj.all_samples(:, i)).^2, 1));
                    obj.labels(i) = argmin;
                end
            end
            
            obj.M = cell(L, 1);
            obj.S = cell(L, 1);
            obj.P = cell(L, 1);
            
            
            obj.calc_params();
        end
        
        function plot(obj, markers)
            hold on;
            for i = 1:obj.L
                plot(obj.all_samples(1, obj.labels == i), obj.all_samples(2, obj.labels == i), markers{i});
            end
            hold off;
        end
        
        function calc_params(obj)
            for i = 1:obj.L
                obj.M{i} = mean(obj.all_samples(:, obj.labels == i), 2);
                obj.S{i} = cov(obj.all_samples(:, obj.labels == i)');
                obj.P{i} = length(obj.labels(obj.labels == i)) / length(obj.labels);
            end
        end
        
        function  obj = quadratic_decomposition(obj, J, max_iter)
            for l = 1:max_iter
                prev_cluster = obj.labels;
                for i = 1:length(obj.all_samples)
                    X = obj.all_samples(:, i);
                    J_vals = zeros(obj.L, 1);
                    for j = 1:obj.L
                        J_vals(j) = J(X, obj.P{j}, obj.M{j}, obj.S{j});
                    end
                    [~, arg_minimum] = min(J_vals);
                    obj.labels(i) = arg_minimum;
                end
                obj.calc_params();

                if obj.labels == prev_cluster
                    disp('Zavrsio')
                    break;
                end
            end
        end
    end
end

