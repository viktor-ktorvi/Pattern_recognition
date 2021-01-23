classdef Dataset < handle
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
        images
        image_size
        hog_cell_size
        hog_nbins
        data
        class_labels
    end
    
    methods
        function obj = Dataset(input_files, image_size, cell_size, N, nbins)
            obj.class_labels = ['A', 'E', 'I', 'O', 'U'];
            
            obj.image_size = image_size;
            obj.hog_cell_size = cell_size;
            obj.hog_nbins = nbins;
            
            obj.labels = zeros(length(input_files), 1);
            obj.images = zeros(length(input_files), image_size(1), image_size(2), 'uint8');
            obj.data = zeros(N, length(input_files), 'single');
            
            for i = 1:length(input_files)
                % label from filename
                label = input_files(i).name(5);
                obj.labels(i) = label;
                
                % image
                input_file_path = input_files(i).folder + "\" + input_files(i).name;
                img = imread(input_file_path);
                obj.images(i, :, :) = img;
                
                % HOG features
                [featureVector, ~] = extractHOGFeatures(img, 'CellSize',[cell_size cell_size], 'NumBins', nbins);
                obj.data(:, i) = featureVector';
                
            end
            
            
        end
        
        function img = getImage(obj, i)
            img = reshape(obj.images(i, :, :), obj.image_size(1), obj.image_size(2));
        end
        
        function cov_matrix = cov(obj)
            cov_matrix = cov(obj.data');
        end
        
        function obj = extractFeatures(obj)
            
            [featureVector, ~] = extractHOGFeatures(obj.getImage(1), 'CellSize',[obj.hog_cell_size obj.hog_cell_size], 'NumBins', obj.hog_nbins);
            N = length(featureVector);
            obj.data = zeros(N, size(obj.images, 1), 'single');
            for i=1:size(obj.images, 1) 
                [featureVector, ~] = extractHOGFeatures(obj.getImage(i), 'CellSize',[obj.hog_cell_size obj.hog_cell_size], 'NumBins', obj.hog_nbins);
                obj.data(:, i) = featureVector';
            end
        end
        
        function obj = resizeImages(obj, new_img_size, new_cell_size, nbins)
            obj.hog_cell_size = new_cell_size;
            obj.hog_nbins = nbins;
            
            new_images = zeros(size(obj.images, 1), new_img_size(1), new_img_size(2), 'uint8');
            
            for i=1:size(obj.images, 1)
                new_images(i, :, :) = imresize(obj.getImage(i), [new_img_size(1) new_img_size(2)]);
            end
            
            obj.images = new_images;
            obj.image_size = new_img_size;
            obj.extractFeatures();
        end
        
        function visualization = getHOGVisualization(obj, i)
           [~, visualization] = extractHOGFeatures(obj.getImage(i), 'CellSize',[obj.hog_cell_size obj.hog_cell_size]); 
        end
        
        function apriori = getApriori(obj)
            apriori = zeros(length(obj.class_labels), 1, 'double');
            for i = 1:length(apriori)
                apriori(i) = length(obj.labels(obj.labels == obj.class_labels(i))) / length(obj.labels);
            end
        end
    end
end

