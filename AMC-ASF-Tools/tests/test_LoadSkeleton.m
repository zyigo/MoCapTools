function test_suite=test_LoadSkeleton %#ok<STOUT>
% initialize unit tets
try
    test_functions=localfunctions(); %#ok<NASGU>
catch
end
initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%

function test_LoadSkeleton_0
% test if fac(0)==1
assertEqual(1,1);