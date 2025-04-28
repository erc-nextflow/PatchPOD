function [ Data_Out ] = Sorting_structdata_nthcolumn_V1( Data, th_col)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[~,order]   = sort(Data.coord_abs(:,th_col));

        Data_Out = struct;
%         Data_Out.coord        = Data.coord(order,:);
        Data_Out.timestep     = Data.timestep(order,:);
        Data_Out.num          = Data.num;
%         Data_Out.coord_tool   = Data.coord_tool(order,:);
%         Data_Out.coord_base   = Data.coord_base(order,:);
        Data_Out.coord_abs    = Data.coord_abs(order,:);
end

