clear variables
addpath('fnc')

%% Load points


% points_cam1 = [-3.55 87.1 132.6; -2.6 64.4 132.5; -2.65 41 132.5; 21.6 44 133; 43.1 42 133; -25.2 15.2 133.3];
% points_cam2 = [-41.5 86.8 135.8; -40.5 64.1 135.8; -40.6 40.8 135.8; -16.3 40.25 134; 5 41.8 132.25; -62.9 14.9 138.5];
%  points_cam1 = [-37.6 87.7 135; -36.5 65 135; -36.7 41.5 134.8; -12.3 41 135; 9.15 42.7 135; -59 15.7 135.5];
 points_cam1 = [30.5 67.2 68.4 ; 28.33 45.25 74.1 ; 25 22.76 80.2 ; 48.2 17.46 75 ; 69 14.9 70.2 ; 0 2.55 91.3];
 points_cam2 = [-31.3 58.8 95 ; -34.2 36.3 97.4 ; -38.3 13.2 99.4 ; -14.7 8.95 103.5 ; 6.4 7.32 107 ; -64.5 -8.52 98];

[Point_No,~] = size(points_cam1);

Trasf_Data1 = [404 322.3 -151 172.1 15.3 -148.32];
Trasf_Data2 = [570 500 -250 170 5 -125];

% figure(1)
% scatter3(points_cam1(:,1),points_cam1(:,2),points_cam1(:,3),'filled')
% hold on 
% scatter3(points_cam2(:,1),points_cam2(:,2),points_cam2(:,3),'filled')



% xcor_dx = 15.265;
xcor_dx = 15.265;
% xcor_dx = 12 : 1 : 16;
n_x = length(xcor_dx);

xcor_dy = -53.2333;
% xcor_dy =   -55:1:-55;
n_y = length(xcor_dy);

xcor_dz =  570.0333;
% xcor_dz =   560:1:575;
n_z = length(xcor_dz);

for part = 1: Point_No


for i = 1:n_x
    for j = 1:n_y
        for k = 1:n_z
        
        cal_center = [xcor_dx(i) xcor_dy(j) xcor_dz(k)];
        
        % x tool = z cam
        % y tool = x cam
        % z tool = y cam 
        
        axis_cam2tool = [3 1 2];

        Coord1.cam = points_cam1;
        [Coord1] = cam2tool( Coord1, cal_center, axis_cam2tool);
        [Coord1] = tool2base( Coord1,Trasf_Data1);
        
        Coord2.cam = points_cam2;
        [Coord2] = cam2tool( Coord2, cal_center, axis_cam2tool);
        [Coord2] = tool2base( Coord2,Trasf_Data2);
        
        Matrix_dist(i,j,k) = norm((Coord2.base(part,:)+ Trasf_Data2(1:3)) - (Coord1.base(part,:)+ Trasf_Data1(1:3)));
        
        end
    end
end

 [val, index] = min(Matrix_dist(:));
 [row,col,kiu] = ind2sub(size(Matrix_dist),index);
 result(part,1) = xcor_dx(row);
 result(part,2) =xcor_dy(col);
 result(part,3) =xcor_dz(kiu);
 
end
%  
result;

Coord1.base_t(:,1) = Coord1.base(:,1) + Trasf_Data1(1);
Coord1.base_t(:,2) = Coord1.base(:,2) + Trasf_Data1(2); 
Coord1.base_t(:,3) = Coord1.base(:,3) + Trasf_Data1(3); 

Coord2.base_t(:,1) = Coord2.base(:,1) + Trasf_Data2(1);
Coord2.base_t(:,2) = Coord2.base(:,2) + Trasf_Data2(2); 
Coord2.base_t(:,3) = Coord2.base(:,3) + Trasf_Data2(3); 

M = eul2rotm([+135/180*pi,0,0]);
Coord1.abs = (M * Coord1.base_t')';
Coord2.abs = (M * Coord2.base_t')';
Coord1.abs - Coord2.abs

% [X,Y] = meshgrid(xcor_dx,xcor_dz);
% figure(2)
% surf(X',Y',squeeze(Matrix_dist))
