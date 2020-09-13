function obj = SetSubjectID(obj, filepath)
%SETSUBJECTID Gets and sets the subject ID from the file name.
filepath = string(filepath);
fn = split(filepath,'/');
fn = fn(end);
fn = split(fn(end),'.');
obj.Subject = str2double(fn(1));
end
