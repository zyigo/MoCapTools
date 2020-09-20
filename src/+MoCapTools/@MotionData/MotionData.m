classdef MotionData
    %MOTIONDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        Trial(1,1) double {mustBeNonnegative, mustBeInteger}
        Frames(1,1) double {mustBeReal, mustBeFinite,mustBeNonnegative}
        Data(:,1) containers.Map
    end
    
    methods
        function [obj,trial] = MotionData(amcFile, skeleton)
            %MOTIONDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj = PrepDataMap(obj,skeleton);
            data = ImportAMCFile(amcFile);
            trial = GetTrialID(amcFile);
            obj = ParseAMCFile(obj, data, trial);
        end
    end
    
    methods (Access = private)
        trial = GetTrialID(filepath);
        data = ImportAMCFile(filepath);
        obj = ParseAMCFile(obj, data, trial)
        obj = PrepDataMap(obj, skeleton);
    end
end

