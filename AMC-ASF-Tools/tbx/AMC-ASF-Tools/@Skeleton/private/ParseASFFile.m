function obj = ParseASFFile(obj,file)
%PARSEASFFILE Summary of this function goes here
%   Detailed explanation goes here
file = char(file);

index = find(file(:,1) == ':');
groups = extractBefore(string(file(index,2:end)),repmat(" ",size(index)));
for g = 1:length(groups)
    switch groups(g)
        case "version"
            obj = GetVersion(obj, g, index, file);
        case "name"
            obj.Name = GetGenericString(g, index, file);
        case "units"
            obj = GetUnits(obj, g, index, file);
        case "documentation"
            obj = GetDocumentation(obj, g, index, file);
        case "root"
            obj = GetRoot(obj, g, index, file);
            %skel.Joints('root') = GetRoot(g, index, file);
        case "bonedata"
            % store bone reference for later after processing hierarchy
            bonedataIndex = g;
            %skel.Bones = GetBoneData(g, index, file);
        case "hierarchy"
            obj = GetHierarchyData(obj, g, index, file);
        otherwise
            error('Additional section defined in the ASF that is not loadable by the LoadSkeleton function.');
    end
end

obj = GetBoneData(obj,bonedataIndex,index,file);
end

function obj = GetHierarchyData(obj, n,index, file)
if n > length(index)
    error('Indexing error when loading hierarchy data section.');
end

if n == length(index)
    hier = string(file(index(n)+1:end,:));
    hier = strtrim(hier);
    nB = find(hier == "begin");
    nE = find(hier == "end");
    hier = hier(nB+1:nE-1);
    %hier = split(hier,' ');
    
    hier = cellfun(@(x) split(x,' '),hier,'UniformOutput',false);
else
    %todo
end

obj.Joints = containers.Map;

for i = 1:length(hier)
    t = string(hier{i,1})';
    
    if i == 1
        assert(t(1) == 'root','Root must be the first identified in the hierarchy.');
        obj.Children = t(2:end);
        for j = 2:length(t)
            obj.Joints(t(j)) = Joint(t(j),"root");
        end
    else
        children = strings(1,length(t)-1);
        for j = 2:length(t)
            obj.Joints(t(j)) = Joint(t(j),t(1));
            children(j-1) = t(j);
        end
        
        temp = obj.Joints(t(1));
        temp.Children = children;
        obj.Joints(t(1)) = temp;
    end
    
end

end

function obj = GetBoneData(obj, n, index, file)
%GETROOT Returns the root details for skeleton held in the ASF file.
%   n is current row
%   index is the index array of the asf ":" section headers
%   file is the string array constructed using IMPORTFILE.
if n >= length(index)
    error('Indexing error when loading bone data section.');
end

lLim = index(n)+1;

if n+1 <= length(index)
    b = index(n+1)-1;
else
    b = length(file);
end

bd = string(file(lLim:b,:));
bd = strtrim(bd);
bdBegin = find(bd == "begin");
bdEnd = find(bd == "end");
if length(bdBegin) ~= length(bdEnd)
    error('Bone Data is missing a "begin" or an "end" string');
end



for i = 1:length(bdBegin)
    strs = bd(bdBegin(i)+1:bdEnd(i)-1);
    btok = extractBefore(strs,repmat(" ",size(strs)));
    bdata = extractAfter(strs,repmat(" ",size(strs)));
    
    % pre allocate limits
    n = size(bdata,1) - 5;
    if n > 0
        limits = zeros(n,2);
        dof = strings(n,1);
    else
        limits = 0;
        dof = "";
    end
    ltcounter = 1; %limit counter
    
    for b = 1:length(strs)
        sw = btok(b);
        switch sw
            case "id"
                % TODO Pre-Allocate for speed
                id = str2double(bdata(b));
            case "name"
                name = bdata(b);
            case "direction"
                direction = str2double(split(bdata(b)))';
            case "length"
                len = str2double(bdata(b));
            case "axis"
                at = split(bdata(b));
                axisOrder = lower(char(at(end)));
                axis = str2double(at(1:end-1))';
            case "limits"
                lt = bdata(b);
                lt = strrep(lt,"(","");
                lt = strrep(lt,")","");
                lt = split(lt,' ');
                limits = str2double(lt)';
                ltcounter = ltcounter + 1;
            case "dof"
                dof = split(bdata(b));
            otherwise
                test = char(sw);
                if test(1) == '('
                    % Get Lower Limit
                    lLim = strrep(sw,'(','');
                    lLim = str2double(lLim);
                    
                    % Get Upper Limit
                    uLim = strrep(bdata(b),')','');
                    uLim = str2double(uLim);
                    
                    limits(ltcounter,:) = [lLim,uLim];
                    ltcounter = ltcounter + 1;
                else
                    error('Bone Data section not defined correctly.');
                end
        end
    end
    
    bone = obj.Joints(name);
    bone.ID = id;
    bone.Direction = direction;
    bone.Length = len;
    bone.Axis = axis;
    bone.AxisOrder = axisOrder;
    bone.Limits = limits;
    bone.DoF = dof;
    obj.Joints(name) = bone;
end
end
function str = GetGenericString(n, index, file)
%GETGENERICSTRING Returns the second part of a string following a space.
%   n is current row
%   index is the index array of the asf ":" section headers
%   file is the string array constructed using IMPORTFILE.

if n >= length(index)
    error('Indexing error when reading generic string section (likely the version or name sections).');
end

str = extractAfter(file(index(n),2:end),' ');
str = strtrim(str);
str = string(str);
end
function obj = GetDocumentation(obj, n, index, file)
%GETDOCUMENTATION Returns the documentation string held in the ASF file.
%   n is current row
%   index is the index array of the asf ":" section headers
%   file is the string array constructed using IMPORTFILE.

if n >= length(index)
    error('Indexing error when reading documentation section.');
end

a = index(n)+1;

if n+1 < length(index)
    b = index(n+1)-1;
else
    b = length(index);
end

doc = string(file(a:b,:));
doc = strtrim(doc);
doc = join(doc');
obj.Documentation = doc;
end
function obj = GetUnits(obj, n, index, file)
%GETUNITS Returns the units (mass, length & angle) string held in the ASF file.
%   n is current row
%   index is the index array of the asf ":" section headers
%   file is the string array constructed using IMPORTFILE.

if n >= length(index)
    error('Indexing error when reading unit section.');
end

a = index(n)+1;

if n+1 < length(index)
    b = index(n+1)-1;
else
    b = length(index);
end

units = string(file(a:b,:));
ud = extractAfter(units,repmat(" ",size(units)));
for u = 1:length(units)
    switch strtok(units(u))
        case "mass"
            obj.Mass = str2double(ud(u));
        case "length"
            obj.Length = str2double(ud(u));
        case "angle"
            obj.AngleType = char(lower(strtrim(ud(u))));
        otherwise
            error('Units not defined correctly.');
    end
end
end
function obj = GetVersion(obj, n, index, file)
%GETVERSION Returns the version number
%   TODO Check function input
version = extractAfter(file(index(n),2:end),' ');
version = strtrim(version);
version = string(version);
version = str2double(version);
obj.Version = version;
end
function obj = GetRoot(obj, n, index, file)
%GETROOT Returns the root details for skeleton held in the ASF file.
%   n is current row
%   index is the index array of the asf ":" section headers
%   file is the string array constructed using IMPORTFILE.

if n >= length(index)
    error('Indexing error when root unit section.');
end

a = index(n)+1;

if n+1 < length(index)
    b = index(n+1)-1;
else
    b = length(index);
end

rt = string(file(a:b,:));
rd = extractAfter(rt,repmat(" ",size(rt)));
for r = 1:length(rt)
    switch strtok(rt(r))
        case "order"
            ord = lower(split(strtrim(rd(r)),' ')');
            if length(ord) ~= 6
                error('Order not defined correctly')
            end
            obj.TranslationOrder = strrep(char(join(ord(1:3),'')),'t','');
            obj.RotationOrder = strrep(char(join(ord(4:6),'')),'r','');
        case "axis"
            obj.AxisOrder = lower(char(strtrim(rd(r))));
        case "position"
            obj.Position = str2double(split(strtrim(rd(r)),' '))';
        case "orientation"
            obj.Orientation = str2double(split(strtrim(rd(r)),' '))';
        otherwise
            error('Root section not defined correctly.');
    end
end
end