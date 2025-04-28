function [ Struct_Light_Data ] = STB_full2struct_v2( Full_Data )
%STB_FULL2STRUCT Summary of this function goes here
%   Detailed explanation goes here
Struct_Light_Data = struct;
Struct_Light_Data.coord = [single(Full_Data.x),single(Full_Data.y),single(Full_Data.z)];
Struct_Light_Data.vel   = [single(Full_Data.u),single(Full_Data.v),single(Full_Data.w)];
Struct_Light_Data.acc   = [single(Full_Data.ax), single(Full_Data.ay), single(Full_Data.az)];
Struct_Light_Data.timestep = single(Full_Data.timestep);
Struct_Light_Data.trackID = single(Full_Data.trackID);

end

