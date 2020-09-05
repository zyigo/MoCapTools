function test_suite=test_ImportFile %#ok<STOUT>
% initialize unit tets
try
    test_functions=localfunctions(); %#ok<NASGU>
catch
end
initTestSuite;

%%%%%%%%%%%%%%%%%%%%%%%
%     Basic tests     %
%%%%%%%%%%%%%%%%%%%%%%%

function test_ImportFile_0
% test if fac(0)==1
%[a,b] = ImportFile(
% TODO Develop test using TestFile.txt
assertEqual(1,1);