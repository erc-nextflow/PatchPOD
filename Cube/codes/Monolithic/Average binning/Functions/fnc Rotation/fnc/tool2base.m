function [ Coord ] = tool2base( Coord , Trasf_Data)
%CAM2TOOL Summary of this function goes here
%   Detailed explanation goes here
%% Reading from an excel sheet

%%
% The rotation 
angles = -[Trasf_Data(6) Trasf_Data(5) Trasf_Data(4)] /180*pi;
% The sign of the rotation Rz must be the same of the one given by the
% robot if you want to use Eul2rotm

M = eul2rotm(angles);
% Mx = [1 0 0; 0 cos(angles(3)) sin(angles(3)); 0 -sin(angles(3)) cos(angles(3))];
% My = [ cos(angles(2)) 0 -sin(angles(2)); 0 1 0; sin(angles(2)) 0 cos(angles(2))];
% Mz = [cos(angles(1)) sin(angles(1)) 0; -sin(angles(1)) cos(angles(1)) 0;0 0 1];
% M2 = Mx*My*Mz

[Part_no,~] = size(Coord.tool);

for i =1:Part_no
    Coord.base(i,:) = Coord.tool(i,:)*M ;
    Coord.base(i,:) = Coord.base(i,:) - [Trasf_Data(1) Trasf_Data(2) Trasf_Data(3)];
end
% 
% figure()
% scatter3(Coord.tool(:,1),Coord.tool(:,2),Coord.tool(:,3) , 'filled', 'b');
% hold on
% scatter3(Coord.base(:,1),Coord.base(:,2),Coord.base(:,3) , 'filled', 'r');
% axis equal
% legend('coord tool','coord base')
% xlabel('x')
% ylabel('y')
% zlabel('z')

end

