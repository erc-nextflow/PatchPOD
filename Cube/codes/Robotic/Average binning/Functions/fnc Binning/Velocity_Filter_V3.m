function [ Pos_Filtered, Vel_Filtered , Acc_Filtered, No_Part_Deleted, Final_Indeces, Final_Indeces_acc] = Velocity_Filter_V3( Pos_Matrix, Vel_Matrix, Acc_Matrix,mode )
%VELOCITY_FILTER Summary of this function goes here
%   Detailed explanation goes here
% The velocity matrix is structered as: |u|v|w|
[No_part,~] = size(Vel_Matrix);
No_Part_Filtered = 0;
No_Part_Filtered_acc = 0;

Indeces = zeros(No_part,1);
Indeces_acc = zeros(No_part,1);

Vel_Matrix_Mean = mean (Vel_Matrix);
Vel_Matrix_Std  = std  (Vel_Matrix);
Acc_Matrix_Mean = mean (Acc_Matrix);
Acc_Matrix_Std  = std  (Acc_Matrix);

for i = 1 : No_part
    
    var = sum(abs(Vel_Matrix(i,:)-Vel_Matrix_Mean(1,:))<(3*Vel_Matrix_Std(1,:)));
    var_acc = sum(abs(Acc_Matrix(i,:)-Acc_Matrix_Mean(1,:))<(3*Acc_Matrix_Std(1,:)));
    
    if var==3
        No_Part_Filtered = No_Part_Filtered+1;
        Indeces(No_Part_Filtered,1) = i;
    end
    
    if var_acc==3
        No_Part_Filtered_acc = No_Part_Filtered_acc+1;
        Indeces_acc(No_Part_Filtered_acc,1) = i;
    end
end

Final_Indeces = Indeces(Indeces~=0);
Final_Indeces_acc = Indeces_acc(Indeces_acc~=0);

No_Part_Deleted = No_part - No_Part_Filtered;
No_Part_Deleted_acc = No_part - No_Part_Filtered_acc;

Vel_Filtered = Vel_Matrix(Final_Indeces,:);
Pos_Filtered = Pos_Matrix(Final_Indeces,:);
Acc_Filtered = Acc_Matrix(Final_Indeces_acc,:);

end

