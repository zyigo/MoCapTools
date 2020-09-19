classdef MotionData
    %MOTIONDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Trial(1,1) double {mustBeNonnegative, mustBeInteger}
        Frames(1,1) double {mustBeReal, mustBeFinite,mustBeNonnegative}
        Data(:,1) containers.Map
    end
    
    methods
        function [obj,trial] = MotionData(amcFile)
            %MOTIONDATA Construct an instance of this class
            %   Detailed explanation goes here
            file = ImportAMCFile(amcFile);
            trial = GetTrialID(amcFile);
            obj = ParseAMCFile(obj, file, trial);
        end
    end
    
    methods (Access = private)
        
    end
end

