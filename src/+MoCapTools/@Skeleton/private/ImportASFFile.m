function file = ImportASFFile(filepath)
%IMPORTASFFILE Import textfile and return the file line-by-line.
%   This function returns both a character and string format array.

%% Check File
filepath = string(filepath);
fn = split(filepath,'/');
fn = fn(end);
fn = split(fn(end),'.');

assert(fn(end) == "asf",'The skeleton file must be an ASF file.');
assert(length(fn(1)) == 2 || ~isnan(str2double(fn(1))),...
    ['ASF File must be named IAW the format: "NN.asf",', ...
    'where NN is the subject number.']);

%% Read File
[fid,~] = fopen(filepath);
[filepath,~] = textscan(fid,'%s','delimiter','\n');
[~] = fclose(fid);

file = string(filepath{1});
file(strcmp("",file)) = [];
end