classdef (Sealed) Joint
    %JOINT Summary of this class goes here
    %   TODO Joint class documentation
    
    properties
        Parent%(1,1) string
        Children%(1,:) string
        Name%(1,1) string
        ID%(1,1) double {mustBeNonnegative, mustBeInteger}
        Direction%(1,3) double {mustBeReal, mustBeFinite}
        Length%(1,1) double {mustBeReal, mustBeFinite, mustBeNonnegative}
        Axis%(1,3) double {mustBeReal, mustBeFinite}
        AxisOrder%(1,3) char {mustBeMember(AxisOrder,...
            %{'xyz','xzy','yzx','yxz','zxy','zyx'})} = 'xyz'
        Limits%(:,:) double... 
            %{mustBeReal, mustBeFinite} %Test for 3x3 max are below
        DoF%(:,1) string
    end
    
    methods
        function obj = Joint(name, parent)
            %JOINT Construct an instance of this class
            %   Detailed explanation goes here
            obj.Name = name;
            obj.Parent = parent;
        end
        
        function obj = set.Limits(obj, value)
            sz = size(value);
            if length(sz) > 2 || sz(1) > 3 || sz(2) > 3
                error('Joint limit array to large, must maximum of 3x3.');
            end
            obj.Limits = value;
        end
    end
end

