classdef (Sealed) Skeleton
    %SKELETON Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Mass(1,1) double {mustBeReal, mustBeFinite}
        Length(1,1) double {mustBeReal, mustBeFinite}
        AngleType(1,:) char {mustBeMember(AngleType,{'deg','rad'})} = 'deg'
        Version(1,1) double {mustBeReal, mustBeFinite,mustBeNonnegative}
        Name(1,1) string
        Subject(1,1) double {mustBeNonnegative, mustBeInteger}
        Documentation(1,1) string
        TranslationOrder(1,3) char {mustBeMember(TranslationOrder,{'xyz','xzy','yzx','yxz','zxy','zyx'})} = 'xyz'
        RotationOrder(1,3) char {mustBeMember(RotationOrder,{'xyz','xzy','yzx','yxz','zxy','zyx'})} = 'xyz'
        AxisOrder(1,3) char {mustBeMember(AxisOrder,{'xyz','xzy','yzx','yxz','zxy','zyx'})} = 'xyz'
        Position(1,3) double {mustBeReal, mustBeFinite}
        Orientation(1,3) double {mustBeReal, mustBeFinite}
        Children(1,:) string
        Joints(:,1) containers.Map
    end
    
    properties (Access = private)
        
    end
    
    properties (Dependent)
        JointNames
    end
    
    methods
        function obj = Skeleton(asfFile)
            %SKELETON Construct a skeleton from an ASF file.
            file = ImportASFFile(asfFile);
            obj = SetSubjectID(obj, asfFile);
            obj = ParseASFFile(obj, file);
        end
        
        function names = get.JointNames(obj)
            names = keys(obj.Joints);
            names = sort(names);
            names = string(names)';
        end
        
        function children = JointChildren(obj,joint)
            if isKey(obj.Joints,char(joint))
                error('%s is not a joint in the skeleton',joint);
            end
            children = obj.Joints(joint);
        end
    end
    
    methods (Access = private)
        file = ImportASFFile(filepath);
        obj = ParseASFFile(obj, file);
        obj = SetSubjectID(obj, filepath);
    end
end

