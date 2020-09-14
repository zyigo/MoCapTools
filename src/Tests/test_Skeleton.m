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
skel = MoCapTools.Skeleton('TestData/02.asf');
assertEqual(skel.Version,1.1);