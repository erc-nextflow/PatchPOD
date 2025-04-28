clc
clear variables
addpath(genpath('Functions'))

%% CONFIG

%%%%%%%%%%%%%%%%%%%%%%
% BINNING PARAMETERS %
%%%%%%%%%%%%%%%%%%%%%%
binsize         = 10;                                                       % Linear binsize in  [mm]
overlap         = 0.75;                                                     % Desired overlap factor
vecspacing      = binsize*(1-overlap)*[1 1 1];                              % Equivalent vector spacing

min_np          = 10;                                                       % Min. number of particles. 
% domain_crop     = [-180 300, -180 180, 0 240];                              % Volume of interest [mm]
domain_crop     = [-180 200, -120 120, 0 200];                                                                                % [xmin xmax, ymin ymax, zmin zmax]
ea_mode         = 'gauss';                                                            % Ensemble averaging mode
                                                                            % Options are:
                                                                            % 'tophat'
                                                                            % 'gauss'
                                                                            % 'linear'
                                                                            % 'quadratic'


%%%%%%%%%%%%%%%%%%%%%
% PROJECT STRUCTURE %
%%%%%%%%%%%%%%%%%%%%%
dataDir  = '..\Data';
naming    = 'Sequence_';
n_sequences = 2; %number of available cones
output_path = '.\Output';
if exist(output_path,'dir') ~= 7
    mkdir(output_path); 
end
% Insert the name of the file Output
Res_name = sprintf('%s_%02imm',ea_mode,binsize);

%% DO NOT EDIT BELOW THIS LINE
%  Unless you know what you are doing. 

% Initializaion
Output = [];

for i = 1:n_sequences
    %load STB tracks
    Sequence = load(fullfile(dataDir,[naming num2str(i) '.mat']));
    Sequence = Sequence.Tracks;
           
    %% Appending Results 
    Output = [Output; Sequence];
end

%%  Structure Binning Options

clear binningoptions
if exist('vecspacing','var')
    binningoptions.vecspacing = vecspacing; 
end
if exist('domain_crop','var')
    binningoptions.domain_crop = domain_crop; 
end
if exist('min_np','var')
    binningoptions.min_np = min_np;
else
    binningoptions.min_np = 10;
end

if exist('ea_mode','var')
    binningoptions.mode = ea_mode;
else
    binningoptions.mode = 'gauss';
end

%%  Binning
binned_data = Binning_V6(binsize, Output, binningoptions);

%%  Save Data in Matlab Format 
save(fullfile(output_path,[Res_name '.mat']),'binned_data','binningoptions','-v7.3');
    