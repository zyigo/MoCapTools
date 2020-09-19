function obj = ParseAMCFile(obj, file, trial)
%PARSEAMCFILE Parses frame data from AMC file into a MotionData class.
%   Detailed explanation goes here
assert(class(obj) == "MoCapTools.MotionData", 'Must be a MotionData Object.\nInput was type: %s.', class(obj));
obj.Trial = trial;

%% Count Number of Frames
% Find Frames
f1 = find(file == "1");
frames = file(f1:end);
frames = frames(~cellfun(@isempty, frames));
f2 = find(frames == "2");

% Get & Set Frame Count
fN = (length(frames)) / (f2 - 1);
assert(mod(fN, 1) == 0, 'AMC File frames have differing number of lines.');
obj.Frames = fN;

%% Import Frame Data
fIs = 1:f2-1:length(frames); %indicies of the frames in the file

end

