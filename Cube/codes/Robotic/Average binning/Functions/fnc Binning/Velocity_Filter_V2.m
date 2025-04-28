function [ Pos_Filtered, Vel_Filtered , No_Part_Deleted, Final_Indeces] = Velocity_Filter_V2( Pos_Matrix, Vel_Matrix,mode )
%VELOCITY_FILTER Summary of this function goes here
%   Detailed explanation goes here
% The velocity matrix is structered as: |u|v|w|
[No_part,~] = size(Vel_Matrix);
No_Part_Filtered = 0;

Indeces = zeros(No_part,1);

Vel_Matrix_Mean = mean (Vel_Matrix);
Vel_Matrix_Std  = std  (Vel_Matrix);
    
for i = 1 : No_part
    
    var = sum(abs(Vel_Matrix(i,:)-Vel_Matrix_Mean(1,:))<(3*Vel_Matrix_Std(1,:)));
    
    if var==3
        No_Part_Filtered = No_Part_Filtered+1;
        Indeces(No_Part_Filtered,1) = i;
    end
end

Final_Indeces = Indeces(Indeces~=0);
No_Part_Deleted = No_part - No_Part_Filtered;
Vel_Filtered = Vel_Matrix(Final_Indeces,:);
Pos_Filtered = Pos_Matrix(Final_Indeces,:);

end

