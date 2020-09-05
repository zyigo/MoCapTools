function skel = LoadSkeleton(asfFile)
%LOADSKELETON Creates a skeleton struct from an ASF file.

checkFileCorrect(asfFile);

asfFile = string(asfFile);
fn = split(asfFile,'/');
fn = fn(end);
fn = split(fn(end),'.');
skel.subject = str2double(fn(1));

[~,file] = ImportFile(asfFile);

index = find(file(:,1) == ':');
groups = extractBefore(string(file(index,2:end)),repmat(" ",size(index)));
for g = 1:length(groups)
    switch groups(g)
        case "version"
            skel.version = GetGenericString(g, index, file);
        case "name"
            skel.name = GetGenericString(g, index, file);
        case "units"
            [skel.mass,skel.length,skel.angle] = GetUnits(g, index, file);
        case "documentation"
            skel.documentation = GetDocumentation(g, index, file);
        case "root"
            [skel.order,skel.axis,skel.position,skel.orientation] = GetRoot(g, index, file);
        case "bonedata"
            skel.bonedata = GetBoneData(g, index, file);
        case "hierarchy"
            % Hierarchy not recorded as it is not required for mapping to
            % the AMC file
        otherwise
            error('Additional section defined in the ASF that is not loadable by the LoadSkeleton function.');
    end
    
end
end

function data = GetBoneData(n, index, file)
%GETROOT Returns the root details for skeleton held in the ASF file.
%   n is current row
%   index is the index array of the asf ":" section headers
%   file is the string array constructed using IMPORTFILE.
if n >= length(index)
    error('Indexing error when loading bone data section.');
end

a = index(n)+1;

if n+1 <= length(index)
    b = index(n+1)-1;
else
    b = length(file);
end

bd = string(file(a:b,:));
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
    
    for b = 1:length(strs)
        sw = btok(b);
        switch sw
            case "id"
                data.bones(i).id = str2double(bdata(b));
            case "name"
                data.bones(i).name = bdata(b);
            case "direction"
                data.bones(i).direction = str2double(split(bdata(b)))';
            case "length"
                data.bones(i).length = str2double(bdata(b));
            case "axis"
                at = split(bdata(b));
                data.bones(i).axisType = at(end);
                data.bones(i).axis = str2double(at(1:end-1))';
            case "limits"
                lt = bdata(b);
                lt = strrep(lt,"(","");
                lt = strrep(lt,")","");
                lt = split(lt,' ');
                data.bones(i).limits = str2double(lt)';
            case "dof"
                data.bones(i).dof = split(bdata(b));
            otherwise
                test = char(sw);
                if test(1) == '('
                else
                    error('Bone Data section not defined correctly.');
                end
        end
    end
end
end
function [ord,ax,pos,ori] = GetRoot(n, index, file)
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

root = string(file(a:b,:));
rd = extractAfter(root,repmat(" ",size(root)));
for r = 1:length(root)
    switch strtok(root(r))
        case "order"
            ord = split(strtrim(rd(r)),' ')';
        case "axis"
            ax = strtrim(rd(r));
        case "position"
            pos = str2double(split(strtrim(rd(r)),' '))';
        case "orientation"
            ori = str2double(split(strtrim(rd(r)),' '))';
        otherwise
            error('root section not defined correctly.');
    end
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

function [mass,len,angle] = GetUnits(n, index, file)
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
            mass = str2double(ud(u));
        case "length"
            len = str2double(ud(u));
        case "angle"
            angle = ud(u);
            angle = strtrim(angle);
        otherwise
            error('Units not defined correctly.');
    end
end
end

function documentation = GetDocumentation(n, index, file)
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

documentation = string(file(a:b,:));
documentation = strtrim(documentation);
documentation = join(documentation');
end

function checkFileCorrect(path)
%path = string(path);
fn = split(path,'/');
fn = fn(end);
fn = split(fn(end),'.');

if ~(fn(end) == "asf")
    error('The skeleton file must be an ASF file.')
end

if ~(length(fn(1)) == 2 || ~isnan(str2double(fn(1))))
    error('ASF File must be named IAW the format: "NN.asf", where NN is the subject number.');
end
end