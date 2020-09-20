function obj = PrepDataMap(obj,skeleton)
%PREPDATAMAP Summary of this function goes here
%   Detailed explanation goes here

%% Pre-Check Ups
str = "2nd argument must be a Skeleton Object.";
assert(class(skeleton) == "MoCapTools.Skeleton",str);
%% Load
a = string(keys(skeleton.Joints));
a = [a,"root"];
b = cell(1,length(a));
obj.Data = containers.Map(a,b);
end

