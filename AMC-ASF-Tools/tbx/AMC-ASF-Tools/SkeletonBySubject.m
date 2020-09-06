function skeleton = SkeletonBySubject(subject, skeletons)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% TODO check array okay
[x,y] = size(subject);
if x == 1 && y ~= 1
    subject = subject';
end

fun = @(x) skeletons(x).subject == subject;
tf2 = arrayfun(fun, 1:numel(skeletons),'UniformOutput',false);
tf2 = cell2mat(tf2);
tf2 = any(tf2(1:end,:));
skeleton = skeletons(tf2);
end

