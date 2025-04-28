function [ output_args ] = Binning_V5(binsize, Data_Output, name , Process_Name, Pin)
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

A{1} = XOC; a{1} = xoc;
A{2} = YOC; a{2} = yoc; 
A{3} = ZOC; a{3} = zoc; 

% Function that calculates the velocity in each bin
tic
[U , ACC, Ustd, RS] = kd_cut_binning_V6(A, Data_Output(:,1:3)', Data_Output(:,4:6)', Data_Output(:,7:9)',dx, No_Slices , Min_np_found);
bintime = toc;
keyboard
fprintf('Binning v3 time: %2.2f [min] \n',bintime/60)

% Calculate pressure
if (Pin.opt)
    fprintf('Starting pressure evaluation \n');
    
    Niter = 20;                     % Try 20 first, increase if neccessary
    mask = U{4};                    % Indicate masked regions (and objects)
    mask(mask<Min_np_found)  = 0;   % 0 = Masked
    mask(mask>=Min_np_found) = 1;   % 1 = Data available
    
    
    p = averagepressure3_mod(Pin.rho,xoc/1000,yoc/1000,zoc/1000,ACC,mask,Niter);  % Very important to use SI units! Thus, coordinates transferred from m to mm
    % Apply Dirichlet Condition if specified
%     keyboard
    if (Pin.Dirichlet)
        pshift = zeros(size(Pin.xDirichlet,1));
        for ii = 1:size(Pin.xDirichlet,1)
            ind = zeros(1,3);
            for jj = 1:3
                indtemp = find(abs(a{jj}-Pin.xDirichlet(ii,jj)) == min(abs(a{jj}-Pin.xDirichlet(ii,jj))));
                ind(jj) = indtemp(1);
            end
            pshift(ii) = Pin.pDirichlet(ii) - p(ind(2),ind(1),ind(3));
        end
        PSHIFT = mean(pshift(:));
        p = p + PSHIFT;
    end
    
    cp = p/(0.5*Pin.rho*Pin.u0*Pin.u0); 
end

%% Creation of the name of the OUTPUT DAT file

% Output_Path = sprintf(strcat(name,'\Binned_',Process_Name,'.dat')); 
Output_Path = strcat(name,'\Binned_',Process_Name,'.dat'); 
%% Conversion of the MAT file into DAT file
if (Pin.opt)
    mat2tec_V5(A, U,Ustd,p,cp,Output_Path)
else
    mat2tec_V3(A, U,Ustd,Output_Path)
end
fprintf('Written Data to Tecplot-file \n');
end

