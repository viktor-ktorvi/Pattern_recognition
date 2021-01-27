classdef Samples
    % 2D random samples
    properties
        samples
        num
        M
        sigma
        cov_mat
    end
    
    methods
        function obj = Samples(M, sigma, rho,  num_samples)
            obj.num = num_samples;
            obj.M = M;
            obj.sigma = sigma;
            obj.cov_mat = (rho*(ones(2,2) - eye(2)) + eye(2)) .* (sigma*sigma');
            
            obj.samples = M + obj.cov_mat^0.5 * randn(2, obj.num);
        end
 
        function plot(obj, marker)
            plot(obj.samples(1, :), obj.samples(2, :), marker);
        end
    end
end

