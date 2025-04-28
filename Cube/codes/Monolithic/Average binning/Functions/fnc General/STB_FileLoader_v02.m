function [ Data ] = STB_FileLoader_v02( filename )
%READER Summary of this function goes here
%   Detailed explanation goes here

tmp = importdata(filename);
[Particle_Num, ~]       = size(tmp.data);
Data.x(:,1)             = single(tmp.data(:,1));           % [mm]
Data.y(:,1)             = single(tmp.data(:,2));           % [mm]
Data.z(:,1)             = single(tmp.data(:,3));           % [mm]
Data.u(:,1)             = single(tmp.data(:,4));           % [m/s]
Data.v(:,1)             = single(tmp.data(:,5));           % [m/s]
Data.w(:,1)             = single(tmp.data(:,6));           % [m/s]
Data.vmag(:,1)          = single(tmp.data(:,7));         % [m/s]
Data.I(:,1)             = single(tmp.data(:,8));           % [-]
Data.timestep(:,1)      = single(tmp.data(:,9));    % [-]
Data.trackID(:,1)       = single(tmp.data(:,10));    % [-]

% 
% % fileID = fopen(filename);
% % Data.rows = textscan(fileID, '%s','delimiter', '\n');
% % fclose(fileID);
% 
% [Particle_Num, ~] = size(Data.rows{1,1});
% Particle_Num = Particle_Num-2;
% 
% for i = 1 : Particle_Num
%     if (mod(i/Particle_Num*100,5)<0.0000005)
%         disp(sprintf('Loaded %02.2f % of the data',i/Particle_Num*100));
%     end
%     fileSpec = '%f %f %f %f %f %f %f %f %f %f %f %f ';
% %     [Data.x{i},Data.y{i},Data.z{i},Data.u{i},Data.v{i},Data.w{i},Data.vmag{i},Data.I{i},Data.timestep{i},Data.trackID{i},A,B,C,D] = sscanf(Data.rows{i+2}, fileSpec)
%     Res  = sscanf(Data.rows{1,1}{i+2,1}, fileSpec);
%     
%     Data.x(i,1) = single(Res(1));           % [mm]
%     Data.y(i,1) = single(Res(2));           % [mm]
%     Data.z(i,1) = single(Res(3));           % [mm]
%     Data.u(i,1) = single(Res(4));           % [m/s]
%     Data.v(i,1) = single(Res(5));           % [m/s]
%     Data.w(i,1) = single(Res(6));           % [m/s]
%     Data.vmag(i,1)= single(Res(7));         % [m/s]
%     Data.I(i,1) = single(Res(8));           % [-]
%     Data.timestep(i,1) = single(Res(9));    % [-]
%     Data.trackID(i,1) = single(Res(10));    % [-]
%     
% end

end

