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
% test if loaded skeleton matches expected data
f_skel = LoadSkeletion('data/02.asf');
saveVarsMat = load('matlab.mat');
test_skel = saveVarsMat.ans; 
assertEqual(test_skel,f_skel);