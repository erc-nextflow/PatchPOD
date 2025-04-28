function [ Data ] = cam2tool_v2( Data , cal_center, axis_cam2tool )
%CAM2TOOL Summary of this function goes here
%   Detailed explanation goes here


Data.coord_tool = [Data.coord(:,1) -  cal_center(1) , Data.coord(:,2) -  cal_center(2) ,Data.coord(:,3) -  cal_center(3)];
Data.coord_tool = [sign(axis_cam2tool(1))* Data.coord_tool(:,abs(axis_cam2tool(1))), sign(axis_cam2tool(2))* Data.coord_tool(:,abs(axis_cam2tool(2))) ,sign(axis_cam2tool(3))* Data.coord_tool(:,abs(axis_cam2tool(3)))];
Data.vel_tool = [sign(axis_cam2tool(1))* Data.vel(:,abs(axis_cam2tool(1))), sign(axis_cam2tool(2))* Data.vel(:,abs(axis_cam2tool(2))) ,sign(axis_cam2tool(3))* Data.vel(:,abs(axis_cam2tool(3)))];
Data.acc_tool = [sign(axis_cam2tool(1))* Data.acc(:,abs(axis_cam2tool(1))), sign(axis_cam2tool(2))* Data.acc(:,abs(axis_cam2tool(2))) ,sign(axis_cam2tool(3))* Data.acc(:,abs(axis_cam2tool(3)))];
end