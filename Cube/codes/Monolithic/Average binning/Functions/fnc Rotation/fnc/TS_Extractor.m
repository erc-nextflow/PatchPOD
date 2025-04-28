function [ Data_TS1, Data_TS2, Data_TS3 ] = TS_Extractor ( Data, TS )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


index_TS = find(Data.timestep == TS(1));
Data_TS1.coord = [Data.x(index_TS,1),Data.y(index_TS,1),Data.z(index_TS,1)];
Data_TS1.vel   = [Data.u(index_TS,1),Data.v(index_TS,1),Data.w(index_TS,1)];
% Data_TS.x = Data.x(index_TS,1);
% Data_TS.y = Data.y(index_TS,1);
% Data_TS.z = Data.z(index_TS,1);
[n_TS1,~] = size(Data_TS1.coord);
Data_TS1.timestep = ones(n_TS1,1)*TS(1);
Data_TS1.num = n_TS1;
Data_TS1.TrackID = Data.trackID(index_TS);


index_TS2 = find(Data.timestep == TS(2));
Data_TS2.coord = [Data.x(index_TS2,1),Data.y(index_TS2,1),Data.z(index_TS2,1)];
Data_TS2.vel   = [Data.u(index_TS2,1),Data.v(index_TS2,1),Data.w(index_TS2,1)];

% Data_TS2.x = Data.x(index_TS2,1);
% Data_TS2.y = Data.y(index_TS2,1);
% Data_TS2.z = Data.z(index_TS2,1);
[n_TS2,~] = size(Data_TS2.coord);
Data_TS2.timestep = ones(n_TS2,1)*TS(2);
Data_TS2.num = n_TS2;
Data_TS2.TrackID = Data.trackID(index_TS2);
% Data_TS2.timestep = TS(2);


index_TS3 = find(Data.timestep == TS(3));
Data_TS3.coord = [Data.x(index_TS3,1),Data.y(index_TS3,1),Data.z(index_TS3,1)];
Data_TS3.vel   = [Data.u(index_TS3,1),Data.v(index_TS3,1),Data.w(index_TS3,1)];

% Data_TS3.x = Data.x(index_TS3,1);
% Data_TS3.y = Data.y(index_TS3,1);
% Data_TS3.z = Data.z(index_TS3,1);
[n_TS3,~] = size(Data_TS3.coord);
Data_TS3.timestep = ones(n_TS3,1)*TS(3);
Data_TS3.num = n_TS3;
Data_TS3.TrackID = Data.trackID(index_TS3);
% Data_TS3.timestep = TS(3);


end

