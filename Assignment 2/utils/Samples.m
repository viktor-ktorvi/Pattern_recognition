classdef Samples
    % 2D random samples
    properties
        samples
        num
        M
        sigma
        cov_mat
        mvnpdf_vals
    end
    
    methods
        function obj = Samples(M, sigma, rho,  num_samples)
            obj.num = num_samples;
            obj.M = M;
            obj.sigma = sigma;
            obj.cov_mat = (rho*(ones(2,2) - eye(2)) + eye(2)) .* (sigma*sigma');
            
            obj.samples = M + obj.cov_mat^0.5 * randn(2, obj.num);
            
            obj.mvnpdf_vals = mvnpdf(obj.samples', obj.M', obj.cov_mat)';
        end
 
        function plot(obj, marker)
            plot(obj.samples(1, :), obj.samples(2, :), marker);
        end
        
        function pdf_s = pdf_sym(obj, X)
           n = length(X);
           pdf_s = 1/(2*pi)^n/2 / det(obj.cov_mat) ^ 0.5 * exp(-0.5 * (X - obj.M)' * obj.cov_mat ^ (-1) * (X - obj.M));
        end
       
        function h = discrimination_function(obj, B, class_num)
            
            h = -log(obj.mvnpdf_vals' ./ mvnpdf(obj.samples', B.M', B.cov_mat));
            
            if class_num == 1
                return;
            else
                h = -h;
                return;
            end
        end
    end
end

