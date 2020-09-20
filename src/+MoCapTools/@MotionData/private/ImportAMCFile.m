function data = ImportAMCFile(filepath)
%IMPORTAMCFILE Import textfile and return the file line-by-line.
%   This function returns both a character and string format array.

%% Check File
filepath = string(filepath);
fn = split(filepath,'/');
fn = fn(end);
fn = split(fn(end),'.');

assert(fn(end) == "amc",'The motion file must be an AMC file.')

fn = split(fn(1),'_');

% Check
check = length(fn(1)) == 2 ...
        || length(fn(2)) == 2 || ...
        ~isnan(str2double(fn(1))) || ...
        ~isnan(str2double(fn(2)));
assert(check,['AMC Files must be named IAW the format: "NN_TT.asf",',...
          'where NN is the subject number and TT is the trial number.'])

%% Read File
[fid,~] = fopen(filepath);
[filepath,~] = textscan(fid,'%s','delimiter','\n');
[~] = fclose(fid);

data = string(filepath{1});
data(strcmp("",data)) = [];
data = strtrim(data);
end