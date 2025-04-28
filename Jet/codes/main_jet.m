% Code from: "Full-domain POD modes from PIV asynchronous patches"
% Authors: I.Tirelli, A.Grille Guerra, A.Ianiro, A.Sciacchitano, F.Scarano, S.Discetti.

% This is the main file, is a demo to artificially partition full-domain
% data into patches, in order to validate the algorithm with a benchmark.
% Is the same used for the jet validation of the paper. This demo works
% with the jet data available on Zenodo, feel free to edit in order to work
% with your data!


clc, clear, close all

%% STEP 1: ASYNCHRONOUS MEASUREMENTS (IN THIS CASE FAKE, WE HAVE THE FULL DOMAIN MEASUREMENTS AND WE PARTITION THEM)
load('Jet_data','Xjet','Yjet','U') % load input data, you need: velocity fields and spatial coordinates, in matrix form
nt=size(U,2); %number of snapshots
[nx,ny]=size(Xjet); %number of gridpoints

U=reshape(U,[nx,ny,nt]); %reshape into 3D matrix, needed only for the next step, in case you don't need it comment

% grid points 
[nx,ny]=size(Xjet);
np=nx*ny;

Um=mean(U,3); % mean velocity
u=U-Um; % fluctuating component
u=reshape(u,[nx ny nt]);
clear U

% PARAMETERS: OVERLAP AND PATCH SIZE

IWx=60; % patch size in x directions ( number of gridpoints )
GDx=15; % grid distance between patches to set the overlap ( i.e. Iw = 60, GD = 15 -> overlap 75%)
IWy=60;
GDy=15;
% Creation of the patch mesh, each of these points is the center of the
% patch
x=IWx/2:GDx:(nx-IWx/2);
y=IWy/2:GDy:(ny-IWy/2);
[X,Y]=meshgrid(x,y);
[ngridx,ngridy]=size(X); % number of patches along x and y
Ncells=ngridx*ngridy; 
Nsnap=min([floor(nt/Ncells) 1500]); % number of snapshot per patch, feel free to set it also manually

C=zeros(np); % inizialization of the spatial correlation matrix C (n_p x n_p)
N_occ=zeros(np); % inizialization of the number of occurences matrix N_occ (n_p x n_p)

I=randperm(nt); % index of the snapshot randomly selected to avoid time coherence, feel free to comment 

%% STEP 2-3: ASSEMBLING SNAPSHOT MATRIX + COMPUTING CORRELATION MATRIX C
cont=0;

for i=1:ngridx
    for j=1:ngridy
        cont=cont+1;
        fprintf('i=%d/%d \t j=%d/%d\n',i,ngridx,j,ngridy)
        
        udum=zeros(nx,ny,Nsnap); % initialization of the patched snapshots
        ii=max([(X(i,j)-IWx/2) 1]):min([(X(i,j)+IWx/2) nx]); % index of the data corresponding to the patch
        jj=max([(Y(i,j)-IWy/2) 1]):min([(Y(i,j)+IWy/2) ny]); % index of the data corresponding to the patch
        
        udum(ii,jj,:)=u(ii,jj,I((1+(cont-1)*Nsnap):(cont*Nsnap))); % from the full domain selected snapshots extracting patches, outside is 0
        udum=reshape(udum,[np Nsnap]);
        
        F=zeros(nx,ny,Nsnap); % flag matrix: 1-data 0-no data
        F(ii,jj,:)=1; %setting the flag for the patch location
        F=reshape(F,[np Nsnap]);
        Fdum=F*F';
        N_occ=N_occ+Fdum; % computing number of occurences (updated at each iteration)
        C=C+udum*udum'; % computing correlation matrix (updated at each iteration)
        
    end
end

clear F Fdum udum

% Scaling with N_occ
C=C./N_occ;
C(isnan(C))=0;

% Reference
u=double(reshape(u,[np nt]));
Cori=(u*u')./(nt);

%% STEP 4: SVD (randomized, for computational costs. Ref: Finding Structure with Randomness: Probabilistic Algorithms for  Constructing Approximate MatrixDecompositions. Halko et al.2011):
rank=1000;
over=40;
[Phi,Eig,~]=randomizedSVD(C,rank,over);
[PhiOri,EigOri,~]=randomizedSVD(Cori,rank,over);

%% SAVING
sout=sprintf('Phi_IW%d_GD%d',IWx,GDx);
save(sout,'Xjet','Yjet','nx','ny','np','Phi','PhiOri','Eig','EigOri','Nsnap','Ncells','Cori','C')

%% PLOTTING
figure

for i = 1:6
    % Left subplot: Phi
    subplot(6,2,2*i - 1)
    pcolor(Xjet, Yjet, reshape(Phi(:, i), [nx ny]) .* sqrt(np))
    shading interp
    axis equal
    axis([min(Xjet(:)) max(Xjet(:)) min(Yjet(:)) max(Yjet(:))])
    colormap jet(16)
    caxis([-3 3])
    set(gca, 'FontName', 'Helvetica', 'FontSize', 8)
    ylabel('Y/D', 'FontSize', 8, 'FontName', 'Helvetica')
    if i == 6
        xlabel('X/D', 'FontSize', 8, 'FontName', 'Helvetica')
    else
        set(gca, 'XTickLabel', [])
    end
    title(['\Phi_' num2str(i)], 'FontSize', 8, 'FontName', 'Helvetica')  

    % Right subplot: PhiOri
    subplot(6,2,2*i)
    pcolor(Xjet, Yjet, reshape(PhiOri(:, i), [nx ny]) .* sqrt(np))
    shading interp
    axis equal
    axis([min(Xjet(:)) max(Xjet(:)) min(Yjet(:)) max(Yjet(:))])
    colormap jet(16)
    caxis([-3 3])
    set(gca, 'FontName', 'Helvetica', 'FontSize', 8)
    ylabel('Y/D', 'FontSize', 8, 'FontName', 'Helvetica')
    if i == 6
        xlabel('X/D', 'FontSize', 8, 'FontName', 'Helvetica')
    else
        set(gca, 'XTickLabel', [])
    end
    title(['\PhiRef_' num2str(i)], 'FontSize', 8, 'FontName', 'Helvetica')  
end


