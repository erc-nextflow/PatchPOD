%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ensemble-averaged robot data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
% close all;
clc;

%% Preliminary 
% Plot parameters
width = 6;     % Width in inches 8
height = 5;    % Height in inches 4
alw = 1;       % AxesLineWidth 
fsz = 20;      % Fontsize 
lw = 2;        % LineWidth 
fsl = 24;      % Font size Label 
msz = 8;       % MarkerSize

%% Load binned data
% Open File
n_cone = 2;
b = 40;
snap = 4;
trasl = -3;
FileName = ['..\Instantaneous binning\Output\b' num2str(b) 'mm\Cone_' num2str(n_cone) '_' num2str(b) 'mm.mat'];
load(FileName);


%% 2D plots
figure
plotcube([120 120 120],[-60 -60 0],1,[0.7 0.7 0.7])
hold on
slice = round(length(Output.x(:,1,1))/2);

%binned slice at y = 0
s = surf(squeeze(Output.x(slice + trasl,:,:)),squeeze(Output.y(slice + trasl,:,:)),squeeze(Output.z(slice + trasl,:,:)),squeeze(Output.(['snapshot_' num2str(snap)]).u(slice + trasl,:,:)));
set(s,'edgecolor','none', 'FaceColor', 'interp')
c = colorbar;
caxis([-6 12])
colormap(jet(12))
c.Label.String = 'u [m/s]';
c.Location = 'east';
c.Position = [0.85 0.3 0.05 0.6];
axis equal
grid on
camlight;
lighting gouraud;
xlim([-180 300])
ylim([-180 180])
zlim([0 240])
view([-20 20])
xlabel('\it x \rm [mm]')
ylabel('\it y \rm [mm]');
zlabel('\it z \rm [mm]')
set(gca, 'FontSize', fsl, 'FontName', 'Times');
set(gcf,'color','w');
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1)-500 pos(2)-300 width*150, height*110]); %<- Set size
% saveas(gcf,'.\u.png')

% std_mag = sqrt(binned_data.std.u.^2+binned_data.std.v.^2+binned_data.std.w.^2);
% figure
% plotcube([120 120 120],[-60 -60 0],1,[0.7 0.7 0.7])
% hold on
% %binned slice at y = 0
% s = surf(squeeze(binned_data.grid.x(slice,:,:)),squeeze(binned_data.grid.y(slice,:,:)),squeeze(binned_data.grid.z(slice,:,:)),squeeze(std_mag(slice,:,:)));
% set(s,'edgecolor','none', 'FaceColor', 'interp')
% c = colorbar;
% caxis([0 6])
% colormap(jet(12))
% c.Label.String = '$\rm std(\it \sqrt{u^2+v^2+w^2}) \rm [m/s]$';
% c.Label.Interpreter = 'latex';
% c.Location = 'east';
% c.Position = [0.85 0.3 0.05 0.6];
% axis equal
% grid on
% camlight;
% lighting gouraud;
% xlim([-180 300])
% ylim([-180 180])
% zlim([0 240])
% view([-20 20])
% xlabel('\it x \rm [mm]')
% ylabel('\it y \rm [mm]');
% zlabel('\it z \rm [mm]')
% set(gca, 'FontSize', fsl, 'FontName', 'Times');
% set(gcf,'color','w');
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1)-500 pos(2)-300 width*150, height*110]); %<- Set size
% saveas(gcf,'.\std.png')

% %% lambda2
% 
% hx = (binned_data.grid.y(2,1,1)-binned_data.grid.y(1,1,1))/1000; %m
% l2 = lambda2(binned_data.velocity.u,binned_data.velocity.v,binned_data.velocity.w,hx,hx,hx);
% edges = 2;
% iso = -2000;
% s1 = isosurface(binned_data.grid.x(1+edges:end-edges,1+edges:end-edges,1+edges:end-edges),binned_data.grid.y(1+edges:end-edges,1+edges:end-edges,1+edges:end-edges),binned_data.grid.z(1+edges:end-edges,1+edges:end-edges,1+edges:end-edges),l2(1+edges:end-edges,1+edges:end-edges,1+edges:end-edges),iso);
% 
% figure
% plotcube([120 120 120],[-60 -60 0],1,[0.7 0.7 0.7])
% hold on
% %binned slice at y = 0
% p1 = patch(s1);
% set(p1,'FaceColor',[0 0 1]);  
% set(p1,'EdgeColor','none');
% axis equal
% grid on
% camlight;
% lighting gouraud;
% xlim([-180 300])
% ylim([-180 180])
% zlim([0 240])
% view([-20 20])
% xlabel('\it x \rm [mm]')
% ylabel('\it y \rm [mm]');
% zlabel('\it z \rm [mm]')
% set(gca, 'FontSize', fsl, 'FontName', 'Times');
% set(gcf,'color','w');
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1)-500 pos(2)-300 width*150, height*110]); %<- Set size