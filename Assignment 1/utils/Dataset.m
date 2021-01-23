classdef Dataset
    %DATASET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        labels
    end
    
    methods
        function obj = Dataset()
            %DATASET Construct an instance of this class
            %   Detailed explanation goes here
            obj.labels = [];
        end
        
        function obj = addLabel(obj, label)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.labels = [obj.labels, label];
        end
    end
end

