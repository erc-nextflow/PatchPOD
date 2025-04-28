function [ Data_Out ] = Sorting_nth_dir( Data, Nth_dir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[~,order]   = sort(Data.coord(:,Nth_dir),'descend');
        Data_Out = struct;
        Data_Out.coord    = Data.coord(order,:);
        Data_Out.timestep = Data.timestep(order,:);
        Data_Out.TrackID  = Data.TrackID(order,:);
        Data_Out.num      = Data.num;

end

