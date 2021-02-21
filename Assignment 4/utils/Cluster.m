classdef Cluster < handle
    %CLUSTER Summary of this class goes here
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
    end
end

