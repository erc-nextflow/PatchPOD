clear variables
close all
addpath('fnc')
clc 

%% Load points

% axis_cam2tool = [-3 -1 2];
axis_cam2tool = [-3 -1 2];  

%% Reference  ---> Cal_Rot_1
    Trasf_Data(1,:) = [-222.3 -213.2 -226.3 180 0 -135];

    Folder_Path1 = 'D:\MyProjects\2017_07_24_OJFF_W2_Edo\Cal_Rot_1_02\MaskCreateGeometric\3D-Part thr=20 (-150-250,-150-150,-150-50)mm E=1\CSV';

    [ Full_Data1 ] = PD_3D_FileLoader_V2( Folder_Path1 );

%     figure()
%     scatter3(Full_Data1.x,Full_Data1.y,Full_Data1.z,'filled')
%      hold on

% Find position of the points
% x-y position of the 6 points

Points_in_plane = [23 -36 ; 22 -14 ; 22 8 ; -1 9  ; -22 7;  44 34];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    
    particles_index  = find(abs(Full_Data1.x - Points_in_plane(i,1)) < 3 & abs(Full_Data1.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data1.x(particles_index) Full_Data1.y(particles_index) Full_Data1.z(particles_index)];      
    Pos_Part_Average{1}(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
end




%% Pitching 5 deg towards the ground ----> Cal_Rot_2
Trasf_Data(2,:) = [-222.3 -213.2 -226.3 180 -5 -135];
Folder_Path2 = 'D:\MyProjects\2017_07_24_OJFF_W2_Edo\Cal_Rot_2\MaskCreateGeometric\3D-Part thr=20 (-150-250,-150-150,-150-50)mm E=1\CSV';
[ Full_Data2 ] = PD_3D_FileLoader_V2( Folder_Path2 );

% figure()
% scatter3(Full_Data2.x,Full_Data2.y,Full_Data2.z,'filled')
%  hold on
 
% Find position of the points
% x-y position of the 6 points

Points_in_plane = [23 11; 22 33 ; 22 56 ; 1 57 ; -22 55 ; 45 82];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    
    particles_index  = find(abs(Full_Data2.x - Points_in_plane(i,1)) < 3 & abs(Full_Data2.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data2.x(particles_index) Full_Data2.y(particles_index) Full_Data2.z(particles_index)];      
        Pos_Part_Average{2}(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
end


%% Cal_Rot_3
Trasf_Data(3,:) = [-222.3 -213.2 -226.3 180 0 -140];

Folder_Path3 = 'D:\MyProjects\2017_07_24_OJFF_W2_Edo\Cal_Rot_3\MaskCreateGeometric\3D-Part thr=20 (-150-250,-150-150,-150-50)mm E=1\CSV';
[ Full_Data3 ] = PD_3D_FileLoader_V2( Folder_Path3 );

% figure()
% scatter3(Full_Data3.x,Full_Data3.y,Full_Data3.z,'filled')
% xlabel('x')
% ylabel('y')
% zlabel('z')
%  
% Find position of the points
% x-y position of the 6 points
Points_in_plane = [72 -36; 71 -14 ; 71 8 ; 47 9 ; 26 7 ; 93 33];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    particles_index  = find(abs(Full_Data3.x - Points_in_plane(i,1)) < 3 & abs(Full_Data3.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data3.x(particles_index) Full_Data3.y(particles_index) Full_Data3.z(particles_index)];      
    Pos_Part_Average{3}(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
    
end

%% Cal_Rot_4
Trasf_Data(4,:) = [-222.3 -213.2 -226.3 180 2 -130];

Folder_Path4 = 'D:\MyProjects\2017_07_24_OJFF_W2_Edo\Cal_Rot_4\MaskCreateGeometric\3D-Part thr=20 (-150-250,-150-150,-150-50)mm E=1\CSV';
[ Full_Data4 ] = PD_3D_FileLoader_V2( Folder_Path4 );

% figure()
% scatter3(Full_Data4.x,Full_Data4.y,Full_Data4.z,'filled')
% xlabel('x')
% ylabel('y')
% zlabel('z')
 
% Find position of the points
% x-y position of the 6 points
Points_in_plane = [-24 -55; -25 -33 ; -25 -10 ; -49 -9 ; -70 -11 ; -3 14];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    particles_index  = find(abs(Full_Data4.x - Points_in_plane(i,1)) < 3 & abs(Full_Data4.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data4.x(particles_index) Full_Data4.y(particles_index) Full_Data4.z(particles_index)];      
    Pos_Part_Average{4}(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
    
end


%% Cal_Rot_5
Trasf_Data(5,:) = [-222.3 -213.2 -226.3 175 7 -140];

Folder_Path5 = 'D:\MyProjects\2017_07_24_OJFF_W2_Edo\Cal_Rot_5\MaskCreateGeometric\3D-Part thr=20 (-150-250,-150-150,-150-50)mm E=1\CSV';
[ Full_Data5 ] = PD_3D_FileLoader_V2( Folder_Path5 );

% figure()
% scatter3(Full_Data5.x,Full_Data5.y,Full_Data5.z,'filled')
% xlabel('x')
% ylabel('y')
% zlabel('z')
 
% Find position of the points
% x-y position of the 6 points
Points_in_plane = [68 -109; 69 -87  ; 72 -64 ; 48 -61 ; 27 -61 ; 95 -41];
Part_No = length(Points_in_plane);

for i = 1:Part_No
    
    pos_part_in_plane = [Points_in_plane(i,1) Points_in_plane(i,2) ];
    particles_index  = find(abs(Full_Data5.x - Points_in_plane(i,1)) < 3 & abs(Full_Data5.y - Points_in_plane(i,2)) < 3);
    Particles_matrix = [Full_Data5.x(particles_index) Full_Data5.y(particles_index) Full_Data5.z(particles_index)];      
    Pos_Part_Average{5}(i,:) = [mean(Particles_matrix(:,1)) mean(Particles_matrix(:,2)) mean(Particles_matrix(:,3))];
    
end

%% Images
% 
% figure()
% scatter3(Pos_Part_Average1(:,1),Pos_Part_Average1(:,2),Pos_Part_Average1(:,3),'r','filled')
% hold on 
% scatter3(Pos_Part_Average2(:,1),Pos_Part_Average2(:,2),Pos_Part_Average2(:,3),'b','filled')
% scatter3(Pos_Part_Average3(:,1),Pos_Part_Average3(:,2),Pos_Part_Average3(:,3),'g','filled')
% xlabel('x')
% ylabel('y')
% zlabel('z')
% axis equal



%% FIND THE CENTER OF ROTATION

% xcor_dx = -100:100:100;
% xcor_dx = -100:10:100;
% xcor_dx = -10:1:10;
% xcor_dx = -3:.1:-1;

xcor_dx = -2.3;
n_x = length(xcor_dx);

% xcor_dy =   -1000:100:1000;
% xcor_dy =   -200: 10:0;
% xcor_dy =   -70: 1:-50;
% xcor_dy =   -57:.1 :-55;

xcor_dy   = -56.1;

n_y = length(xcor_dy);  

% xcor_dz =  -1000: 100 :1000;
% xcor_dz =  400:10:600;
% xcor_dz =  520: 1: 540;
% xcor_dz =  526:.1:528;

xcor_dz = 526.7;


n_z = length(xcor_dz);

    
for i = 1:n_x
    for j = 1:n_y
        for k = 1:n_z
          
            cal_center = [xcor_dx(i) xcor_dy(j) xcor_dz(k)];
            
            for g = 1:5
                
                Coord(g).cam = Pos_Part_Average{g};
                [Coord] = cam2tool( Coord, cal_center, axis_cam2tool, g);
                angles = [Trasf_Data(g,6) Trasf_Data(g,5) Trasf_Data(g,4)]/180*pi;
                M = eul2rotm(angles);
                Coord(g).rotated = (M*Coord(g).tool')';

%                 Coord(2).cam = Pos_Part_Average2;
%                 [Coord] = cam2tool( Coord(2), cal_center, axis_cam2tool);
%                 angles = [0 -5 0]/180*pi;
%                 M = eul2rotm(angles);
%                 Coord(2).rotated = (M*Coord(2).tool')';
% 
%                  Coord3.cam = Pos_Part_Average3;
% 
%                 [Coord(3)] = cam2tool( Coord3, cal_center, axis_cam2tool);
%                 angles = [-5 -5 0]/180*pi;
%                 M = eul2rotm(angles);
%                 Coord3.rotated = (M*Coord3.tool')';
            end
            

            for g = 1:5
                for point = 1:6
                    p{point}(g,:) = Coord(g).rotated(point,:);

                end
            end
            for point = 1:6
                
                stand_dev(point,:) = [std(p{point}(:,1)) std(p{point}(:,2)) std(p{point}(:,3))];
            
            end
            
            mean_vector = [mean(stand_dev(:,1)) mean(stand_dev(:,2)) mean(stand_dev(:,3))];
                
            Matrix_dist(i,j,k) = norm(mean_vector);
    %             Matrix_dist(i,j,k) = sum(sqrt((Coord1.tool(:,1)-Coord2.rotated(:,1)).^2 + (Coord1.tool(:,2)-Coord2.rotated(:,2)).^2 + (Coord1.tool(:,3)-Coord2.rotated(:,3)).^2));
           

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
points = 1:6;
figure()
scatter3(Coord(1).rotated(points,1),Coord(1).rotated(points,2),Coord(1).rotated(points,3) , 'filled', 'b');
hold on
scatter3(Coord(2).rotated(points,1),Coord(2).rotated(points,2),Coord(2).rotated(points,3) , 'filled', 'g');
scatter3(Coord(3).rotated(points,1),Coord(3).rotated(points,2),Coord(3).rotated(points,3) , 'filled', 'p');
scatter3(Coord(4).rotated(points,1),Coord(4).rotated(points,2),Coord(4).rotated(points,3) , 'filled', 'k');
scatter3(Coord(5).rotated(points,1),Coord(5).rotated(points,2),Coord(5).rotated(points,3) , 'filled', 'r');
axis equal
legend('coord1 rotated','coord2 rotated','coord 3 rotated', 'coord 4 rotated','coord 5 rotated')
xlabel('x')
ylabel('y')
zlabel('z')


% axh = gca; % use current axes
% color = 'k'; % black, or [0 0 0]
% linestyle = ':'; % dotted
% line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
% line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle); 


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
% 
% [X,Y] = meshgrid(xcor_dy,xcor_dz);
% figure()
% surf(X',Y',squeeze(Matrix_dist))
% xlabel('dy')
% ylabel('dz')
