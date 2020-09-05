function test_suite=test_LoadSubjectData %#ok<STOUT>
% initialize unit tets
try
    test_functions=localfunctions(); %#ok<NASGU>
catch
end
initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%

function test_LoadSubjectData_0
% test if fac(0)==1
[a,b] = LoadSubjectData('','');
assertEqual(a,1);
assertEqual(b,1);