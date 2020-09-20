function obj = ParseAMCFile(obj, data, trial)
%PARSEAMCFILE Parses frame data from AMC file into a MotionData class.
%   Detailed explanation goes here

assert(class(obj) == "MoCapTools.MotionData", 'Must be a MotionData Object.\nInput was type: %s.', class(obj));
obj.Trial = trial;

%% Count Number of Frames
% Find Frames
f1 = find(data == "1");
frames = data(f1:end);
frames = frames(~cellfun(@isempty, frames));
f2 = find(frames == "2");

% Get & Set Frame Count
fN = (length(frames)) / (f2 - 1);
assert(mod(fN, 1) == 0, 'AMC File frames have differing number of lines.');
obj.Frames = fN;

%% Prep Data in object
%d = obj.Data;
%k = keys(d);
%for di = 1:count(d)
%    d(k(di)) =
%end
%obj.Data = d;
%% Import Frame Data
fIs = 1:f2-1:length(frames); %indicies of the frames in the file
fIs = [fIs,length(frames)];

% Setup Frame 1

%for di = 1:count(d)
%    d(k(di)) = zeros
%end
frame = frames(fIs(1)+1:fIs(2)-1);
[toks,leftovers] = strtok(frame);
leftovers = strtrim(leftovers);
assert(length(toks)==length(frame),'Identifier missing in Frame 1.');
for i = 1:length(frame)
    a = strsplit(frame(i),' ');
    params = length(a(2:end));
    obj.Data(toks(i,:)) = zeros(obj.Frames,params);
    a = obj.Data(toks(i,:));
    a(1,:) = str2double(split(leftovers(i,1),' '))';
    obj.Data(toks(i,:)) = a;
end



for j = 2:length(fIs)-1
    frame = frames(fIs(j)+1:fIs(j+1)-1);
    [toks,leftovers] = strtok(frame);
    leftovers = strtrim(leftovers);
    assert(length(toks)==length(frame),'Identifier missing in Frame %D.',j);
    for i = 1:length(frame)
        a = strsplit(frame(i),' ');
        params = length(a(2:end));
        a = obj.Data(toks(i,:));
        a(j,:) = str2double(split(leftovers(i,1),' '))';
        obj.Data(toks(i,:)) = a;
    end
end
