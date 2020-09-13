function test_suite=test_Skeleton %#ok<STOUT>
% initialize unit tets
try
    test_functions=localfunctions(); %#ok<NASGU>
catch
end
initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%

function test_Skeleton_0
% TODO Develop test using TestFile.txt
assertEqual(1,1);