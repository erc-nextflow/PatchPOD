function [ Full_Data,NameField ] = IPR_FileLoader_V2( Folder_Path, Ts_toLoad )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Full_Data= struct;

for frame = 1:2
    
    NameField{frame,1} = sprintf('Frame_%i',frame);
    Full_Data.(NameField{frame,1}).x = [];
    Full_Data.(NameField{frame,1}).y = [];
    Full_Data.(NameField{frame,1}).z = [];
    Full_Data.(NameField{frame,1}).Part_Num = [];
    Full_Data.(NameField{frame,1}).timestep = [];
    
end

Files = dir(Folder_Path);
TS_No = length(Files)-3;

%% Reading all the files for each TS
for t = [Ts_toLoad(1):Ts_toLoad(2):Ts_toLoad(3)]
    
    clear x; clear y; clear z;
    if mod((t/TS_No*100),20)==0
        display(strcat(sprintf('%0.2f',t/TS_No*100),'% done'));
    end
    File_path = strcat(Folder_Path,'\Tecplot_',sprintf('%i',t),'.dat');
%     File_path
    tmp = importdata(File_path);
    [Total_Num, ~] = size(tmp.data);
    % find the fisrt line of the second frame 
    SecondFrameLine = binarySearch(tmp.data(:,1),1);
    
    % First frame
    frame = 1;
    Total_Num_Frame1 = SecondFrameLine-1;
    Full_Data.(NameField{frame,1}).x    = [Full_Data.(NameField{frame,1}).x;tmp.data(1:SecondFrameLine-1,2)];
    Full_Data.(NameField{frame,1}).y    = [Full_Data.(NameField{frame,1}).y;tmp.data(1:SecondFrameLine-1,3)];
    Full_Data.(NameField{frame,1}).z    = [Full_Data.(NameField{frame,1}).z;tmp.data(1:SecondFrameLine-1,4)];
    Full_Data.(NameField{frame,1}).Part_Num = [Full_Data.(NameField{frame,1}).Part_Num;Total_Num_Frame1];
    Full_Data.(NameField{frame,1}).timestep = [Full_Data.(NameField{frame,1}).timestep; t*ones(Total_Num_Frame1,1)];
    
    % Second frame
    frame = 2;
    Total_Num_Frame2 = Total_Num - SecondFrameLine + 1;
    Full_Data.(NameField{frame,1}).x    = [Full_Data.(NameField{frame,1}).x;tmp.data(SecondFrameLine : end,2)];
    Full_Data.(NameField{frame,1}).y    = [Full_Data.(NameField{frame,1}).y;tmp.data(SecondFrameLine : end,3)];
    Full_Data.(NameField{frame,1}).z    = [Full_Data.(NameField{frame,1}).z;tmp.data(SecondFrameLine : end,4)];
    Full_Data.(NameField{frame,1}).Part_Num = [Full_Data.(NameField{frame,1}).Part_Num;Total_Num_Frame2];
    Full_Data.(NameField{frame,1}).timestep = [Full_Data.(NameField{frame,1}).timestep; t*ones(Total_Num_Frame2,1)];

    
end   
%{
%% Reading all the files for each TS

for t = [(Ts_toLoad(1)*2-1):2*Ts_toLoad(2):(2*Ts_toLoad(3)-1) 2*Ts_toLoad(1):2*Ts_toLoad(2):(2*Ts_toLoad(3))]
    clear x; clear y; clear z;
    
    if mod((t/TS_No*100),20)==0
        display(strcat(sprintf('%0.2f',t/TS_No*100),'% done'));
    end
    
    if (mod(t,2))
        frame = 1;
    else
        frame = 2;
    end
    
    File_path = strcat(Folder_Path,'\Tecplot_',sprintf('%i',t),'.dat');
%     File_path
    tmp = importdata(File_path);
    
    [Total_Num, ~] = size(tmp.data);
    
    Full_Data.(NameField{frame,1}).x    = [Full_Data.(NameField{frame,1}).x;tmp.data(:,2)];
    Full_Data.(NameField{frame,1}).y    = [Full_Data.(NameField{frame,1}).y;tmp.data(:,3)];
    Full_Data.(NameField{frame,1}).z    = [Full_Data.(NameField{frame,1}).z;tmp.data(:,4)];
    Full_Data.(NameField{frame,1}).Part_Num = [Full_Data.(NameField{frame,1}).Part_Num;Total_Num];
    Full_Data.(NameField{frame,1}).timestep = [Full_Data.(NameField{frame,1}).timestep; ceil(tmp.data(1,1)/2)*ones(Total_Num,1)];
    
    %         fileID = fopen(File_path);
    %         Data.rows = textscan(fileID, '%s','delimiter', '\n');
    %         fclose(fileID);
    %
    %         [Total_Num, ~]   = size(Data.rows{1,1});
    %
    %
    %         %% Reading the coordinates of the points
    %
    %             for i = 1 : Total_Num-2
    %
    %                 fileSpec = '%f';
    %
    %                 keyboard
    %
    %                 Temp_Coord = (sscanf(Data.rows{1,1}{i+2 ,1}, fileSpec))';
    %                 x(i,1) = Temp_Coord(1,2);
    %                 y(i,1) = Temp_Coord(1,3);
    %                 z(i,1) = Temp_Coord(1,4);
    %
    %             end
    %
    %             Full_Data.(NameField{frame,1}).x    = [Full_Data.(NameField{frame,1}).x;x];
    %             Full_Data.(NameField{frame,1}).y    = [Full_Data.(NameField{frame,1}).y;y];
    %             Full_Data.(NameField{frame,1}).z    = [Full_Data.(NameField{frame,1}).z;z];
    % %             Full_Data.u    = [Full_Data.u;zeros(Particle_Num,1)];
    % %             Full_Data.v    = [Full_Data.v;zeros(Particle_Num,1)];
    % %             Full_Data.w    = [Full_Data.w;zeros(Particle_Num,1)];
    %             Full_Data.(NameField{frame,1}).Part_Num = [Full_Data.(NameField{frame,1}).Part_Num;Total_Num-2];
    %             Full_Data.(NameField{frame,1}).timestep = [Full_Data.(NameField{frame,1}).timestep;(floor((t+1)/2))*ones(Total_Num-2,1)];
    % %             Full_Data.trackID = [Full_Data.trackID;zeros(Particle_Num,1)];
end
%}
end


