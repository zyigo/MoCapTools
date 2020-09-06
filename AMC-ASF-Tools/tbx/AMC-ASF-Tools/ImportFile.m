function [str,chr] = ImportFile(file)
%IMPORTFILE Import textfile and return the file line-by-line.
%   This function returns both a character and string format array.
[fid,~] = fopen(file);
[file,~] = textscan(fid,'%s','delimiter','\n');
[~] = fclose(fid);


file(strcmp('',file)) = [];

str = string(file{1});
chr = char(file{1});

end