function [ Full_Data,NameField ] = PD_3D_FileLoader_V3( Folder_Path )
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
Files_Num = length(Files); 
% Find all the files name that contain B
TS_No = 0;

for i = 1: Files_Num
    
    if findstr(Files(i).name,'B') == 1

        TS_No = TS_No+1;

    end
end
%% Reading all the files for each TS
progressbar(0);
    for t = 1 : TS_No
        progressbar(t/TS_No); 
        clear x ; clear y; clear z;
%         File_path = strcat(Folder_Path,'\',Files(t+2).name); 
        File_path = strcat(Folder_Path,'\B',sprintf('%i',t),'.dat');    
        fileID = fopen(File_path);
        Data.rows = textscan(fileID, '%s','delimiter', '\n');
        fclose(fileID);

        [Total_Num, ~]   = size(Data.rows{1,1});
%         Particle_Num        = Particle_Num - 10;
        Scaling = zeros(3,2);

        %% Reading the scaling
        for i = 4 : 6

            fileSpec = '%f %f';   
            Col_Point_Pos = strfind(Data.rows{1,1}{i,1},':');
            Scaling_Numbers  = (Data.rows{1,1}{i,1}(Col_Point_Pos+1:end));
            Scaling(i-3,:)= (sscanf(Scaling_Numbers, fileSpec))';

        end

        %% Reading the coordinates of the points
        % Find the position of the Start FRAMES
        Counter_Frame = 0;
        
        for index = 1:Total_Num
            
            Found = strfind ([Data.rows{1,1}{index,1}],'x y z Intensity Radius');
            
            if ~isempty(Found)
                Counter_Frame = Counter_Frame + 1;
                Start(Counter_Frame) = index;
            end
        end
            
        No_Part(1,1) = (Start(2)-2) - ( Start(1) + 1 )+1;
        No_Part(2,1) = Total_Num - (Start(2)+1)+1;
        
        Index_Part(1,1) = Start(1) + 1;
        Index_Part(1,2) = Start(2) - 2;
        Index_Part(2,1) = Start(2) + 1;
        Index_Part(2,2) = Total_Num;
        
        
%         x = zeros(Particle_Num,2); y = zeros(Particle_Num,2); z = zeros(Particle_Num,2);
%         I = zeros(Particle_Num,2); rad = zeros(Particle_Num,2);
        
        for frame = 1:2
            
            
            for i = 1 : (Index_Part(frame,2) - Index_Part(frame,1)+1)
                
                fileSpec = '%f';   
                Temp_Coord = (sscanf(Data.rows{1,1}{i + Index_Part(frame,1)-1 ,1}, fileSpec))';
                x{frame}(i,1) = Temp_Coord(1,1) * Scaling(1,1) + Scaling(1,2); 
                y{frame}(i,1) = Temp_Coord(1,2) * Scaling(2,1) + Scaling(2,2);
                z{frame}(i,1) = Temp_Coord(1,3) * Scaling(3,1) + Scaling(3,2);
                
            end

            Full_Data.(NameField{frame,1}).x    = [Full_Data.(NameField{frame,1}).x;x{frame}];
            Full_Data.(NameField{frame,1}).y    = [Full_Data.(NameField{frame,1}).y;y{frame}];
            Full_Data.(NameField{frame,1}).z    = [Full_Data.(NameField{frame,1}).z;z{frame}];
%             Full_Data.u    = [Full_Data.u;zeros(Particle_Num,1)];
%             Full_Data.v    = [Full_Data.v;zeros(Particle_Num,1)];
%             Full_Data.w    = [Full_Data.w;zeros(Particle_Num,1)];
            Full_Data.(NameField{frame,1}).Part_Num = [Full_Data.(NameField{frame,1}).Part_Num;No_Part(frame,1)];
            Full_Data.(NameField{frame,1}).timestep = [Full_Data.(NameField{frame,1}).timestep;(t)*ones(No_Part(frame,1),1)];
%             Full_Data.trackID = [Full_Data.trackID;zeros(Particle_Num,1)];
        end
    end
    
    
end

