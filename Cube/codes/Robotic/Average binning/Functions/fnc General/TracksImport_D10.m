function [data_sorted] = TracksImport_D10(fileIn)

filename = fileIn;

delimiter = ' ';
startRow = 6;
lineoffset = 4; 
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
try
    fileID = fopen(filename,'r');
catch
    fileID = fopen(filename{1},'r');
    filename = filename{1};
end

data_sorted  = [];
fileID = fopen(filename,'r');
tmp2 = textscan(fileID,formatSpec,'HeaderLines',startRow,'Delimiter', delimiter);
while (size(tmp2{1},1) >= 1)
    data_sorted = [data_sorted; tmp2{1} tmp2{2} tmp2{3} tmp2{5} tmp2{6} tmp2{7}];
    tmp2 = textscan(fileID,formatSpec,'HeaderLines',lineoffset,'Delimiter', delimiter);
end
data_sorted = [data_sorted; tmp2{1} tmp2{2} tmp2{3} tmp2{5} tmp2{6} tmp2{7}];
fclose(fileID);

end