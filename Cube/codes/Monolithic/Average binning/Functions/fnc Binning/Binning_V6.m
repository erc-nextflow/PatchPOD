function [ output_args ] = Binning_V6(binsize, Data_Output, options)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Dimension of the edge of the cube
dx = binsize; dy = binsize; dz = binsize;  %[mm]

% Number of slices in which the domain is subdivided
No_Slices = 15;

if exist('options','var')
    % vector spacing
    if isfield(options,'vecspacing')
        vecspacing = options.vecspacing;
    end
    % Domain boundaries
    if isfield(options,'domain_crop')
        domain_crop = options.domain_crop;
    end
    % Minimum number of particle per bin
    if isfield(options,'min_np')
        Min_np_found = options.min_np;
    else
        Min_np_found = 21;
    end
end

% Search for the boundaries
if (exist('domain_crop','var'))
    min_x_res = domain_crop(1);
    min_y_res = domain_crop(3);
    min_z_res = domain_crop(5); 
    max_x_res = domain_crop(2); 
    max_y_res = domain_crop(4); 
    max_z_res = domain_crop(6); 
else
    min_x_res = min(Data_Output(:,1));      %[mm]
    max_x_res = max(Data_Output(:,1));      %[mm]
    min_y_res = min(Data_Output(:,2));      %[mm]
    max_y_res = max(Data_Output(:,2));      %[mm]
    min_z_res = min(Data_Output(:,3));      %[mm]
    max_z_res = max(Data_Output(:,3));      %[mm]
end
%   Overlap percentage
overlap = 0.75;

%   Define grid volume centers
if (exist('vecspacing','var'))
    xoc     = min_x_res:vecspacing(1):max_x_res;
    yoc     = min_y_res:vecspacing(2):max_y_res;
    zoc     = min_z_res:vecspacing(3):max_z_res;
else
    xoc     = min_x_res:dx*(1-overlap):max_x_res+dx;
    yoc     = min_y_res:dy*(1-overlap):max_y_res+dy;
    zoc     = min_z_res:dz*(1-overlap):max_z_res+dz;
end

% Amount of grid volume elements 
nx  = length(xoc); ny = length(yoc); nz = length(zoc); nt = nx * ny * nz;

% Creation of the meshgrid
[XOC,YOC,ZOC] = meshgrid(xoc,yoc,zoc);

A{1} = XOC; a{1} = xoc;
A{2} = YOC; a{2} = yoc; 
A{3} = ZOC; a{3} = zoc; 

% Function that calculates the velocity in each bin
tic
if strcmp(options.mode,'tophat')
    fprintf('Binning in ''top-hat'' mode\n');
    [U , Ustd, RS] = kd_cut_binning_V5_tophat(A, Data_Output(:,1:3)', Data_Output(:,4:6)', dx, No_Slices , Min_np_found);
elseif strcmp(options.mode,'gauss')
    fprintf('Binning with Gaussian weights\n');
    [U , Ustd, RS] = kd_cut_binning_V5_gauss(A, Data_Output(:,1:3)', Data_Output(:,4:6)', dx, No_Slices , Min_np_found);
elseif strcmp(options.mode,'linear')
    fprintf('Binning with linear polyfitting model\n');
    [U , Ustd, RS] = kd_cut_binning_V5_linear(A, Data_Output(:,1:3)', Data_Output(:,4:6)', dx, No_Slices , Min_np_found);
elseif strcmp(options.mode,'quadratic')
    fprintf('Binning with 2nd-order polyfit model\n');
    [U , Ustd, RS] = kd_cut_binning_V5_quadratic(A, Data_Output(:,1:3)', Data_Output(:,4:6)', dx, No_Slices , Min_np_found);
else
    warning('Mode not recognized. Now chosing linear fitting model for ensemble averaging')
    [U , Ustd, RS] = kd_cut_binning_V5_linear(A, Data_Output(:,1:3)', Data_Output(:,4:6)', dx, No_Slices , Min_np_found);
end
bintime = toc;

fprintf('Binning v3 time: %2.2f [min] \n',bintime/60)

% Write data to output variable/struct

output_args.grid.x    = A{1,1}; 
output_args.grid.y    = A{1,2}; 
output_args.grid.z    = A{1,3}; 
output_args.velocity.u    = U{1,1}; 
output_args.velocity.v    = U{1,2}; 
output_args.velocity.w    = U{1,3}; 
output_args.np    = U{1,4}; 
output_args.RS   = RS; 
output_args.std.u = Ustd{1,1};
output_args.std.v = Ustd{1,2};
output_args.std.w = Ustd{1,3};

end %function

