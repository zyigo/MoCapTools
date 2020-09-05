function skeleton = LoadMultipleSkeletons(folder)
%LOADMULTIPLESKELETONS Loads multiple skeletons from a folder of files.
%   The asf files can be in a folder with other file types.
%   See also LOADSKELETON

files = struct2table(dir(folder));
files = files(3:end,:);
extension = split(files.name,".");
asfFiles = extension(:,2) == "asf";
asfFiles = files.name(asfFiles);
asfFiles = strcat(folder,asfFiles);

skeleton(1:length(asfFiles)) = LoadSkeleton(asfFiles(1));
for i = 2:length(asfFiles)
    skeleton(i) = LoadSkeleton(asfFiles(i));
end
end