function [ index, value] = findNN( Point_coord , Cloud_Points )
%FINDNN Summary of this function goes here
%   Detailed explanation goes here

for i=1:Cloud_Points.num
    
    dist(i,1) = sqrt((Point_coord(1)-Cloud_Points.coord_abs(i,1))^2+(Point_coord(2)-Cloud_Points.coord_abs(i,2))^2+(Point_coord(3)-Cloud_Points.coord_abs(i,3))^2);
    % dist in x
    dist_x(i,1) = (Cloud_Points.coord_abs(i,1) - Point_coord(1) );
    % dist in y
    dist_y(i,1) = (Cloud_Points.coord_abs(i,2) - Point_coord(2) );
    % dist in z
    dist_z(i,1) = (Cloud_Points.coord_abs(i,3) - Point_coord(3) );

end


[value,index] = min(dist(:,1));
value_x    = dist_x(index,1);
value(1,2) = dist_x(index,1);
value_y    = dist_y(index,1);
value(1,3) = dist_y(index,1);
value_z    = dist_z(index,1);
value(1,4) = dist_z(index,1);

