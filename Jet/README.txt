This folder contains the data and code for the free jet test case. The scripts are designed to process full-domain snapshots by splitting them into smaller patches. While the framework can be adapted to other datasets, this demo is primarily intended for validation purposes. It provides a controlled environment with known ground truth, allowing for thorough evaluation and analysis of the algorithm’s performance.

Here you have two subfolder:
- code:
	- main_jet -> main file to run
	- randomized_svd -> the callable function to perform randomized SVD
- data:
	- Jet_data -> dataset of the free jet described in the paper, containing the           dimensionless spatial coordinates in a matrix form X_jet and Y_jet [D] and           the velocity component U and V [m/s].

For all the details about the experimantal setup, processing and algorithms the readers is referred to the paper.