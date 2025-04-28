function [ Data_TS1 ] = TS_Extractor_V2 ( Data, TS )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


index_TS = find(Data.timestep == TS(1));
Data_TS1.coord = [Data.x(index_TS,1),Data.y(index_TS,1),Data.z(index_TS,1)];
% Data_TS1.vel   = [Data.u(index_TS,1),Data.v(index_TS,1),Data.w(index_TS,1)];
% Data_TS.x = Data.x(index_TS,1);
% Data_TS.y = Data.y(index_TS,1);
% Data_TS.z = Data.z(index_TS,1);
[n_TS1,~] = size(Data_TS1.coord);
Data_TS1.timestep = ones(n_TS1,1)*TS(1);
Data_TS1.num = n_TS1;
% Data_TS1.TrackID = Data.trackID(index_TS);


end

