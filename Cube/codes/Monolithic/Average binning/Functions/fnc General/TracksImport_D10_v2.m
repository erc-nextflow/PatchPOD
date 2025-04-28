function [data_sorted] = convertTracks_Davis10to8(data,options)

filename = data.pathIn;
file_out = data.pathOut;

delimiter = ' ';
startRow = 7;
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
try
    fileID = fopen(filename,'r');
catch
    fileID = fopen(filename{1},'r');
end
tmp = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

P=tmp{1,1}=='ZONE';
k=find(P);

kp1=k+1;
kp2=k+2;
kp3=k+3;
dele=cat(1,k,kp1,kp2,kp3);
dele=sort(dele);

x             = tmp{1,1};           % [mm]
y             = tmp{1,2};           % [mm]
z             = tmp{1,3};           % [mm]
u             = tmp{1,5};           % [m/s]
v             = tmp{1,6};           % [m/s]
w             = tmp{1,7};           % [m/s]
vmag          = tmp{1,8};           % [m/s]
I             = tmp{1,4};           % [-]
%Data.timestep(:,1)      = [];      % [-]
trackID       = tmp{1,9};           % [-]

x(dele)=[];
y(dele)=[];
z(dele)=[];
u(dele)=[];
v(dele)=[];
w(dele)=[];
vmag(dele)=[];
I(dele)=[];
trackID(dele)=[];
Tracks=[x y z u v w];

data_sorted = str2double(Tracks);
data_sorted = single(data_sorted);
Tracks=array2table(Tracks,'VariableNames',{'x' 'y' 'z' 'u' 'v' 'w'});

%%%%%%%%%%%%%%%%%%%%%%%
%%Replace the '....' after Tracks with the path where you want to save the file including name and '.dat'%%%%
%%%%%%%%%%%%%%%%%%%%%%%
if (options.save == 1)
    writetable(Tracks,file_out,'Delimiter',' ');
end

end