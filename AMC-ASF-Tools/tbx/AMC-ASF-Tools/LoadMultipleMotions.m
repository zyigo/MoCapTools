function motions = LoadMultipleMotions(folder)
%LOADMULTIPLEMOTIONS Loads multiple motions from a folder.
%   TODO Detailed explanation goes here
%   See also LOADMOTION, LOADSKELETON & LOADMULTIPLESKELETONS

files = struct2table(dir(folder));
files = files(3:end,:);
extension = split(files.name,".");
amcFiles = extension(:,2) == "amc";
amcFiles = files.name(amcFiles);
amcFiles = strcat(folder,amcFiles);

motions(1:length(amcFiles)) = LoadMotion(amcFiles(1));
for i = 2:length(amcFiles)
    motions(i) = LoadMotion(amcFiles(i));
end
end

