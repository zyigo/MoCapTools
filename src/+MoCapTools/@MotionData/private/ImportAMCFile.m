function file = ImportAMCFile(filepath)
%IMPORTAMCFILE Import textfile and return the file line-by-line.
%   This function returns both a character and string format array.

%% Check File
filepath = string(filepath);
fn = split(filepath,'/');
fn = fn(end);
fn = split(fn(end),'.');

if ~(fn(end) == "amc")
    error('The motion file must be an AMC file.')
end

fn = split(fn(1),'_');

if ~(length(fn(1)) == 2 || length(fn(2)) == 2 || ...
        ~isnan(str2double(fn(1))) || ~isnan(str2double(fn(2))))
    error('AMC Files must be named IAW the format: "NN_TT.asf",'+...
          'where NN is the subject number and TT is the trial number.');
end

%% Read File
[fid,~] = fopen(filepath);
[filepath,~] = textscan(fid,'%s','delimiter','\n');
[~] = fclose(fid);

file = string(filepath{1});
file(strcmp("",file)) = [];
file = strtrim(file);
end