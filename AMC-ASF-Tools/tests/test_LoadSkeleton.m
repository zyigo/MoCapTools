function test_suite=test_LoadSkeleton
% initialize unit tets
try
    test_functions=localfunctions();
catch
end
initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%

function test_LoadSkeleton_0
% test if fac(0)==1
assertEqual(1,1);