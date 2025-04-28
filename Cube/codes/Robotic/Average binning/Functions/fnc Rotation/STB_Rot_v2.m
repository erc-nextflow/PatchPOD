function [ Data_STB_Light ] = STB_Rot_v2( Data_STB_Light,cal_center,axis_cam2tool,Position_Matrix, angles_Base2Abs )
%STB_ROT Summary of this function goes here
%   Detailed explanation goes here


%% Rotation of the Data
        
[Data_STB_Light] = cam2tool_v2( Data_STB_Light, cal_center, axis_cam2tool);
angles = [Position_Matrix(6) Position_Matrix(5) Position_Matrix(4)]/180*pi;
M = eul2rotm(angles);
Data_STB_Light.coord_base = (M*Data_STB_Light.coord_tool')';
Data_STB_Light.vel_base = (M*Data_STB_Light.vel_tool')';
Data_STB_Light.acc_base = (M*Data_STB_Light.acc_tool')';

angles_base_abs = [angles_Base2Abs(1,3) angles_Base2Abs(1,2) angles_Base2Abs(1,1)]/180*pi;
M2 = eul2rotm(angles_base_abs );
translationoffset = (M2*Position_Matrix(1,1:3)')';
No_Part = length(Data_STB_Light.coord_base);

Data_STB_Light.coord_abs = (M2*Data_STB_Light.coord_base')' + repmat(translationoffset,[No_Part,1]);
Data_STB_Light.vel_abs = (M2*Data_STB_Light.vel_base')';
Data_STB_Light.acc_abs = (M2*Data_STB_Light.acc_base')';

end

