clc
clear variables
addpath(genpath('Functions'))

%% CONFIG

%%%%%%%%%%%%%%%%%%%%%%
% BINNING PARAMETERS %
%%%%%%%%%%%%%%%%%%%%%%
binsize         = 30;                                                       % Linear binsize in  [mm]
overlap         = 0.75;                                                     % Desired overlap factor
vecspacing      = binsize*(1-overlap)*[1 1 1];                              % Equivalent vector spacing

min_np          = 1;                                                        % Min. number of particles. 
% domain_crop     = [-180 300, -180 180, 0 240];                              % Volume of interest [mm]
domain_crop     = [-180 200, -120 120, 0 200];                              % Volume of interest [mm]
                                                                            % [xmin xmax, ymin ymax, ymin ymax]

%%%%%%%%%%%%%%%%%%%%%
% PROJECT STRUCTURE %
%%%%%%%%%%%%%%%%%%%%%
dataDir  = '..\Data';
naming    = 'Sequence_';
n_sequences = 2; %number of available sequences
output_path = '.\Output';
if exist(output_path,'dir') ~= 7
    mkdir(output_path); 
end

%% DO NOT EDIT BELOW THIS LINE
%  Unless you know what you are doing. 

% Insert the path for the output
% binary
Folder_Path_Results_bin = '.\Output';
if exist(Folder_Path_Results_bin,'dir') ~= 7
    mkdir(Folder_Path_Results_bin); 
end

%Bin for every sequence
for i = 1:n_sequences
    %define output file
    Output_file = ['Sequence_' num2str(i) '_' num2str(binsize) 'mm.mat'];
    Output_all = fullfile(output_path,Output_file);
    %load STB tracks
    Sequence = load(fullfile(dataDir,[naming num2str(i) '.mat']));
    Tracks = Sequence.Tracks;
    %perform binning
    disp(['Binning sequence ' num2str(i) ' out of ' num2str(n_sequences)])
    Binning(Tracks, Output_all, binsize, vecspacing, min_np, domain_crop);
end

