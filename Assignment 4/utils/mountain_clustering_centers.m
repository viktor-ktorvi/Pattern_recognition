function [C, mountain_function, X, Y, mountain_foo] = mountain_clustering_centers(all_samples, L, sigma, beta, axis_scale, step)
    %%
    xmin = min(all_samples(1, :)) * axis_scale;
    xmax = max(all_samples(1, :)) * axis_scale;

    ymin = min(all_samples(2, :)) * axis_scale;
    ymax = max(all_samples(2, :)) * axis_scale;

    xx = xmin:step:xmax;
    yy = ymin:step:ymax;
    [X, Y] = meshgrid(xx, yy);
    %% Mountain function
    mountain_foo = zeros('like', X);

    for i = 1:length(all_samples)
        peak = exp(- ((X - all_samples(1, i)).^2 + (Y - all_samples(2, i)).^2 )/ 2 / sigma^2);
        mountain_foo = mountain_foo + peak / max(peak(:));
    end
    mountain_foo = mountain_foo / max(mountain_foo(:));
    
    mountain_function = mountain_foo;
    
    C = zeros(size(all_samples, 1), L);
    for i=1:L
        [~, argmaximum] = max(mountain_foo(:));
        [y_subscript, x_subscript] = ind2sub(size(mountain_foo), argmaximum);

        C(1, i) = xx(x_subscript);
        C(2, i) = yy(y_subscript);

        peak = exp(- ((X - C(1, i)).^2 + (Y - C(2, i)).^2) / 2 / beta^2);
        peak = peak / max(peak(:));

        mountain_foo = mountain_foo - mountain_foo(y_subscript, x_subscript) * peak;
    end
end

