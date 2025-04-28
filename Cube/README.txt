Welcome to the dataset of flow around a wall-mounted cube. 
Cube side is L = 120 mm and flow velocity 10 m/s. The experiment has been carried out at TUDelft facility, all the information about the setup are available in the paper.
This README file will guide you through the data and processing scripts I have prepared for you.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
The project is divided in two main folders: Monolithic (reference data 3DLPT, DOI: 10.4121/a2e5b234-cd95- 4749-84b2-0f96937ae3cf)
and Robotic (the RoboPIV aquisition).

Each folder contains a similar structure:
-Data: contains the scattered velocity information already in .mat binary format to save some storage space.
-Instantaneous binning: contains the scripts to bin the scattered data onto a Cartesian grid, returning one vector field per snapshot.
-Average binning: contains the scripts to bin the scattered data in a time-averaged sense by ensemble-averaging all tracks together.
-Plotting folders contain the scripts  to visualize the data.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
System of reference

Both cases (monolithic and robotic) are in the same system of reference. 
The origin is at the center of the cube face in contact with the floor.
x points towards the direction of the flow.
z points normal to the wall (up).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Measurement volume 

Please note that the measurement volume of the monolithic system contains a shorter wake (up to x = 200 mm approx).
Since this is a region of strong fluctuations, you might have to crop the robotic data for comparison of POD modes.

The measurement volume of the robotic case (all cones together) is:
x: -180 mm to 300 mm (4L)
y: -180 mm to 180 mm (3L)
z: 0 mm to 240 mm (2L)

Data quality is reasonably good across the volume, but certain regions are void of particles,
mainly for (x>200, z>100) and also (y<-60, z>100). You may inspect these from the STB plotting folder scripts.

If you want to replicate the data of the paper keep the parameters that I put.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Data format

-Monolithic case: we have two sequences of 5000 frames each, acquired at 3kHz. 
The columns of the .mat file contain: x,y,z locations (in mm), u,v,w velocities (in m/s), frame number and Track ID.

-Robotic case: we have 35 cones in total, with 5000 frames each, acquired at 200 Hz.
(I discarded 4 views from the positive y side due to strong reflections).
The order is as shown in the gif file: first the 13 cones from the negative y side, ordered in terms of increasing x; 
then the 13 central ones, also ordered in terms of increasing x; finally the 9 cones from the positive y side, ordered similarly.
The columns of the .mat file contain: x,y,z locations (in mm), u,v,w velocities (in m/s) and frame number 
(since these are two-pulse tracks).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Binning scripts

Every binning folder (instantaneous and average) contains a Main script that manages the entire process.
At the beginning of the script, you may change the following parameters:
Bin size, specified in mm.
Overlap factor, specified between 0 and 1.
Minimum number of particles: if less particles are found in a bin, the resulting velocities are NaN.
Domain crop: allows you to set the grid limits, specified in mm (x,y,z).

For average binning, there is an additional setting that allows you to change the type of averaging performed:
top-hat (raw mean), gaussian-weighted mean and also first and second order polynomials (as in the Aguera paper).

You can always choose the number of sequences (or cones) you want to consider for the binning process.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Results format

The average binning creates one .mat file containing the results (binned_data structure) and binning options.
Inside binned_data, you may find the x,y,x grid in meshgrid format, the u,v,w velocities, standard deviations,
Reynolds stresses (RS structure) and number of particles found in each bin (np variable).
I have performed one binning as an example (for both cases) using 10 mm as bin size with 75% overlap and Gaussian weighting.

The instantaneous binning creates one .mat file per sequence/cone. Inside, you will find the x,y,z grid in meshgrid format
and the u,v,w velocities for every snapshot.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Enjoy!