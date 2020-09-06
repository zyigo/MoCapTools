function motion = LoadMotion(amcFile)
%LOADMOTION Loads motion from an AMC File.
%   TODO Detailed explanation
%   See also LOADSKELETON, LOADMULTIPLESKELETONS

%% Import File
file = ImportFile(amcFile);
motion.subject = 2; %TODO Subject Number from file name
motion.trial = 1;   %TODO Trial Number from file name



%% Import Frame Data
% Identify Frame Length
sInd = find(file(:,1) == '1',1,'first');
eInd = find(file(:,1) == '2',1,'first');
n = eInd - sInd;

% check format
if isempty(sInd) || isempty(eInd)
    error('AMC ERROR \nEach frame must be preceded by a frame number on its own line%s','.');
end

% Remove Frame Numbers
data = file(sInd:end);
data(1:n:end) = [];
motion.frameCount = length(data)/(n-1);



% Save Frame Data to Struct
for i = 1:n-1
    motion.data.(strtok(data(i))) = zeros(motion.frameCount,count(data(i),' '));
    [~,temp] = strtok(data(i:n-1:end));
    temp = strtrim(temp);
    temp = split(temp,' ');
    temp = str2double(temp);
    motion.data.(strtok(data(i))) = temp;
end
end

