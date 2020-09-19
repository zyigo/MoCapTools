function trial = GetTrialID(filepath)
%SETSUBJECTID Gets and sets the subject ID from the file name.
filepath = string(filepath);
fn = split(filepath,'/');
fn = fn(end);
fn = split(fn(end),'.');
fn = split(fn(1),'_');
trial = str2double(fn(2));
end
