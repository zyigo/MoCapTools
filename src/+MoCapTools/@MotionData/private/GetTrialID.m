function trial = GetTrialID(filepath)
%SETSUBJECTID Gets a subject ID from the file name.
filepath = string(filepath);
fn = strsplit(filepath,'/');
fn = fn(end);
fn = strsplit(fn(end),'.');
fn = strsplit(fn(1),'_');
trial = str2double(fn(2));
end
