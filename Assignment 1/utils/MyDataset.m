classdef MyDataset < handle
    %MYDATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
        data
        file_names
    end
    
    methods
        function obj = MyDataset()
            obj.labels = {};
            obj.data = [];
            obj.file_names = {};
        end
        
        function obj = addLabels(obj, new_labels)
            obj.labels = [obj.labels, new_labels{:}];
        end
        
        function obj = addData(obj, new_data)
            obj.data = [obj.data; new_data];
        end
        
        function obj = addFilenames(obj, new_filenames)
            obj.file_names = [obj.file_names, new_filenames{:}];
        end
        
    end
end

