function [ output_args ] = Binning_V3(binsize, Data_Output, name , Process_Name)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Dimension of the edge of the cube
dx = binsize; dy = binsize; dz = binsize;  %[mm]

% Minimum number of particle per bin
Min_np_found = 5; 

% Number of slices in which the domain is subdivided
No_Slices = 15;

% Search for the boundaries
min_x_res = min(Data_Output(:,1));      %[mm]
max_x_res = max(Data_Output(:,1));      %[mm]
min_y_res = min(Data_Output(:,2));      %[mm]
max_y_res = max(Data_Output(:,2));      %[mm]
min_z_res = min(Data_Output(:,3));      %[mm]
max_z_res = max(Data_Output(:,3));      %[mm]

%   Overlap percentage
overlap = 0.75;

%   Define grid volume centers
xoc     = min_x_res:dx*(1-overlap):max_x_res+dx;
yoc     = min_y_res:dy*(1-overlap):max_y_res+dy;
zoc     = min_z_res:dz*(1-overlap):max_z_res+dz;

% Amount of grid volume elements 
nx  = length(xoc); ny = length(yoc); nz = length(zoc); nt = nx * ny * nz;

% Creation of the meshgrid
[XOC,YOC,ZOC] = meshgrid(xoc,yoc,zoc);

A{1} = XOC;
A{2} = YOC;
A{3} = ZOC;

% Function that calculates the velocity in each bin
tic
[U , Ustd] = kd_cut_binning_V4(A, Data_Output(:,1:3)', Data_Output(:,4:6)', dx, No_Slices , Min_np_found);
bintime = toc;

fprintf('Binning v3 time: %2.2f [min]',bintime/60)

%% Creation of the name of the OUTPUT DAT file

% Output_Path = sprintf(strcat(name,'\Binned_',Process_Name,'.dat')); 
Output_Path = strcat(name,'\Binned_',Process_Name,'.dat'); 
%% Conversion of the MAT file into DAT file
mat2tec_V3(A, U,Ustd,Output_Path)

end

