clear variables
close all
addpath('fnc')
clc 

%% Load points

% axis_cam2tool = [-3 -1 2];
axis_cam2tool = [-3 -1 2];  

%% Reference  ---> Cal_Rot_1
% Trasf_Data1 = [520 -367.4 -428 0 0 -45];
Trasf_Data1 = [520 -367.4 -428 0 0 0];

Folder_Path1 = 'C:\Users\Edoardo Saredi\Dropbox\Thesis\Script matlab\Rotation script\Data\Cal_Rot_1\MaskOutImage\3D-Part thr=50 (-150-250,-150-150,0-100)mm E=0.75\CSV';
[ Full_Data1 ] = PD_3D_FileLoader_V2( Folder_Path1 );

% figure(1)
% scatter3(Full_Data1.x,Full_Data1.y,Full_Data1.z,'filled')
%  hold on
% Find position of the points
% x-y position of the 6 points
Points_in_plane = [-11 13; -10 -8.44 ; -10.31 -31.25 ; 13.38 -31.86 ; 34.13 -30.28 ; -32.19 -56.22];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    
    particles_index  = find(abs(Full_Data1.x - Points_in_plane(i,1)) < 3 & abs(Full_Data1.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data1.x(particles_index) Full_Data1.y(particles_index) Full_Data1.z(particles_index)];      
    Pos_Part_Average1(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
end




%% Pitching 5 deg towards the ground ----> Cal_Rot_2
% Trasf_Data2 = [520.15 -367.39 -427.94 0 +10 -45];
Trasf_Data2 = [520.15 -367.39 -427.94 0 10 0];
Folder_Path2 = 'C:\Users\Edoardo Saredi\Dropbox\Thesis\Script matlab\Rotation script\Data\Cal_Rot_2\MaskOutImage\3D-Part thr=50 (-150-250,-150-150,0-100)mm E=0.75\CSV';
[ Full_Data2 ] = PD_3D_FileLoader_V2( Folder_Path2 );

% figure(2)
% scatter3(Full_Data2.x,Full_Data2.y,Full_Data2.z,'filled')
%  hold on
 
% Find position of the points
% x-y position of the 6 points
Points_in_plane = [-11 110; -10 88 ; -9.90 65 ; 13 65 ; 34 66 ; -31 41];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    
    particles_index  = find(abs(Full_Data2.x - Points_in_plane(i,1)) < 3 & abs(Full_Data2.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data2.x(particles_index) Full_Data2.y(particles_index) Full_Data2.z(particles_index)];      
        Pos_Part_Average2(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
end


%% Pitching 5 deg towards the ground yawed 5 deg ----> Cal_Rot_3
% Trasf_Data3 = [520.15 -367.39 -427.94 0 +10 -50];
Trasf_Data3 = [520.15 -367.39 -427.94 0 10 -5];

Folder_Path3 = 'C:\Users\Edoardo Saredi\Dropbox\Thesis\Script matlab\Rotation script\Data\Cal_rot_3\CSV';
[ Full_Data3 ] = PD_3D_FileLoader_V2( Folder_Path3 );

% figure()
% scatter3(Full_Data3.x,Full_Data3.y,Full_Data3.z,'filled')
% xlabel('x')
% ylabel('y')
% zlabel('z')
 
% Find position of the points
% x-y position of the 6 points
Points_in_plane = [-60 110; -58 88 ; -58 65 ; -35 65 ; -14 66 ; -80 41];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    particles_index  = find(abs(Full_Data3.x - Points_in_plane(i,1)) < 3 & abs(Full_Data3.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data3.x(particles_index) Full_Data3.y(particles_index) Full_Data3.z(particles_index)];      
    Pos_Part_Average3(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
    
end



%% Images
% 
figure(1)
scatter3(Pos_Part_Average1(:,1),Pos_Part_Average1(:,2),Pos_Part_Average1(:,3),'r','filled')
hold on 
scatter3(Pos_Part_Average2(:,1),Pos_Part_Average2(:,2),Pos_Part_Average2(:,3),'b','filled')
scatter3(Pos_Part_Average3(:,1),Pos_Part_Average3(:,2),Pos_Part_Average3(:,3),'g','filled')
xlabel('x')
ylabel('y')
zlabel('z')
axis equal



%% FIND THE CENTER OF ROTATION

% xcor_dx = -1000:100:1000;
% xcor_dx = -100:10:100;
% xcor_dx = -10:1:10;
% xcor_dx = 1:.1:3;
xcor_dx = 1.8;
% VERO xcor_dx = 1.8;           %[mm]
n_x = length(xcor_dx);

% xcor_dy =   -1000:10:1000;
% xcor_dy =   -10: 1:10;
% xcor_dy =   -5:.1:-3;
% xcor_dy   = -19.6;
xcor_dy   = -16.6;        %[mm]
n_y = length(xcor_dy);  

% xcor_dz =  0: 10:1000;
% xcor_dz =  510:1:530;
% xcor_dz =  551: .1: 553;
% xcor_dz =  600:.1:602;
% xcor_dz = 520;
xcor_dz = 594.50;  %[mm]

n_z = length(xcor_dz);

    
for i = 1:n_x
    for j = 1:n_y
        for k = 1:n_z
          
            cal_center = [xcor_dx(i) xcor_dy(j) xcor_dz(k)];

            Coord1.cam = Pos_Part_Average1;
            [Coord1] = cam2tool( Coord1, cal_center, axis_cam2tool);
            angles = [-45 0 0]/180*pi;
            M = eul2rotm(angles);
            Coord1.rotated = (M*Coord1.tool')';

            Coord2.cam = Pos_Part_Average2;
            [Coord2] = cam2tool( Coord2, cal_center, axis_cam2tool);
            angles = [-45 +10 0]/180*pi;
            M = eul2rotm(angles);
            Coord2.rotated = (M*Coord2.tool')';
            
             Coord3.cam = Pos_Part_Average3;
            
            [Coord3] = cam2tool( Coord3, cal_center, axis_cam2tool);
            angles = [-50 10 0]/180*pi;
            M = eul2rotm(angles);
            Coord3.rotated = (M*Coord3.tool')';
            

            Matrix_dist(i,j,k) = sum(sqrt((Coord1.tool(1:5:end,1)-Coord3.rotated(1:5:end,1)).^2 + (Coord1.tool(1:5:end,2)-Coord3.rotated(1:5:end,2)).^2 + (Coord1.tool(1:5:end,3)-Coord3.rotated(1:5:end,3)).^2));

        end
    end
end

 [val, index] = min(Matrix_dist(:));
 [row,col,kiu] = ind2sub(size(Matrix_dist),index);
 

 result(1,1) = xcor_dx(row);
 result(2,1) = xcor_dy(col);
 result(3,1) = xcor_dz(kiu);
% 
% figure()
% scatter3(Coord1.cam(:,1),Coord1.cam(:,2),Coord1.cam(:,3) , 'filled', 'b');
% hold on
% scatter3(Coord2.cam(:,1),Coord2.cam(:,2),Coord2.cam(:,3) , 'filled', 'r');
% scatter3(Coord3.cam(:,1),Coord3.cam(:,2),Coord3.cam(:,3) , 'filled', 'g');
% axis equal
% legend('coord1 cam','coord2 cam')
% xlabel('x')
% ylabel('y')
% zlabel('z') 
% axis([-300 300, -300 300, -300 300])
% axh = gca; % use current axes
% color = 'k'; % black, or [0 0 0]
% linestyle = ':'; % dotted
% line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
% line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);

% %%
figure()
scatter3(Coord1.rotated(:,1),Coord1.rotated(:,2),Coord1.rotated(:,3) , 'filled', 'b');
hold on
scatter3(Coord2.tool(:,1),Coord2.tool(:,2),Coord2.tool(:,3) , 'filled', 'r');
scatter3(Coord2.rotated(:,1),Coord2.rotated(:,2),Coord2.rotated(:,3) , 'filled', 'g');
scatter3(Coord3.tool(:,1),Coord3.tool(:,2),Coord3.tool(:,3) , 'filled', 'p');
scatter3(Coord3.rotated(:,1),Coord3.rotated(:,2),Coord3.rotated(:,3) , 'filled', 'k');
axis equal
legend('coord1 tool','coord2 tool','coord2 rotated','coord3','coord 3 rotated')
xlabel('x')
ylabel('y')
zlabel('z')
axh = gca; % use current axes
color = 'k'; % black, or [0 0 0]
linestyle = ':'; % dotted
line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle); 


% 

% 
% %% 
% % 
% figure()
% scatter3(Coord1.base(:,1),Coord1.base(:,2),Coord1.base(:,3) , 'filled', 'b');
% hold on
% scatter3(Coord2.base(:,1),Coord2.base(:,2),Coord2.base(:,3) , 'filled', 'r');
% scatter3(Coord3.base(:,1),Coord3.base(:,2),Coord3.base(:,3) , 'filled', 'g');
% axis equal
% legend('coord1 base','coord2 base')
% xlabel('x')
% ylabel('y')
% zlabel('z')

% [X,Y] = meshgrid(xcor_dy,xcor_dz);
% figure()
% surf(X',Y',squeeze(Matrix_dist))
% xlabel('dy')
% ylabel('dz')
