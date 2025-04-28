function [ Data_Out ] = Sorting_nth_column( Data, Nth_dir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[~,order]   = sort(Data(:,Nth_dir));
        Data_Out = Data(order,:);

end

