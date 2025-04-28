function Binning(Tracks, Output_all, binsize, vecspacing, min_np, domain_crop)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Dimension of the edge of the cube
dx = binsize; dy = binsize; dz = binsize;  %[mm]

% Number of slices in which the domain is subdivided
No_Slices = 15;

% Search for the boundaries
min_x_res = domain_crop(1);
min_y_res = domain_crop(3);
min_z_res = domain_crop(5); 
max_x_res = domain_crop(2); 
max_y_res = domain_crop(4); 
max_z_res = domain_crop(6); 

xoc     = min_x_res:vecspacing(1):max_x_res;
yoc     = min_y_res:vecspacing(2):max_y_res;
zoc     = min_z_res:vecspacing(3):max_z_res;

% Amount of grid volume elements 
nx  = length(xoc); ny = length(yoc); nz = length(zoc); nt = nx * ny * nz;

% Creation of the meshgrid
[XOC,YOC,ZOC] = meshgrid(xoc,yoc,zoc);

A{1} = XOC; a{1} = xoc;
A{2} = YOC; a{2} = yoc; 
A{3} = ZOC; a{3} = zoc; 

%Create structure for mat file
Output.x = XOC;
Output.y = YOC;
Output.z = ZOC;

% Function that calculates the velocity in each bin
tic
%loop for every snapshot
n_snapshots = Tracks(end,7);
for i = 1:n_snapshots
    Data = Tracks(Tracks(:,7)==i,1:6);
    U = kd_cut_binning(A, Data(:,1:3)', Data(:,4:6)', dx, No_Slices , min_np);
    %store info in structure
    Output.(['snapshot_' num2str(i)]).u = U{1};
    Output.(['snapshot_' num2str(i)]).v = U{2};
    Output.(['snapshot_' num2str(i)]).w = U{3};
end
bintime = toc;

fprintf('Binning time: %2.2f [min] \n',bintime/60)


%% saving data to mat file
save(Output_all,'Output',"-v7.3");

end

