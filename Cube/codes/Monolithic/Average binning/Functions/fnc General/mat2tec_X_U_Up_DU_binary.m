function [] = mat2tec_X_U_Up_DU_binary(X, U, U_std, DU, varargin)
	x = X{1}(:); %lenx = length(unique(x));
	y = X{2}(:); %leny = length(unique(y));
	z = X{3}(:); %lenz = length(unique(z));
	u = U{1}(:);
	v = U{2}(:);
	w = U{3}(:);
    
    umag = (U{1}.^2+U{2}.^2+U{3}.^2).^(0.5);
    
    %     u_std = U_std{1}(:);
    %     v_std = U_std{2}(:);
    %     w_std = U_std{3}(:);

    du_dx = DU(:,:,:,1,1);% du_dx = du_dx(:);
    du_dy = DU(:,:,:,1,2);% du_dy = du_dy(:);
    du_dz = DU(:,:,:,1,3);% du_dz = du_dz(:);

    dv_dx = DU(:,:,:,2,1);% dv_dx = dv_dx(:);
    dv_dy = DU(:,:,:,2,2);% dv_dy = dv_dy(:);
    dv_dz = DU(:,:,:,2,3);% dv_dz = dv_dz(:);

    dw_dx = DU(:,:,:,3,1);% dw_dx = dw_dx(:);
    dw_dy = DU(:,:,:,3,2);% dw_dy = dw_dy(:);
    dw_dz = DU(:,:,:,3,3);% dw_dz = dw_dz(:);
    
    hx = (X{1}(1,2,1)-X{1}(1,1,1))*1e-3;
    hy = (X{2}(2,1,1)-X{2}(1,1,1))*1e-3;
    hz = (X{3}(1,1,2)-X{3}(1,1,1))*1e-3;

    umat(:,:,:,1) = U{1};
    umat(:,:,:,2) = U{2};
    umat(:,:,:,3) = U{3};

    XI = xicalc3d(hx,hy,hz,umat,200);
    Q  = qcritcalc(hx,hy,hz,umat);
    
    omega_x = XI(:,:,:,1);%      omega_x = omega_x(:);
    omega_y = XI(:,:,:,2);%      omega_y = omega_y(:);
    omega_z = XI(:,:,:,3);%      omega_z = omega_z(:);

    OMEGA = sqrt(sum(XI.^2,4));% OMEGA = OMEGA(:);

    %Q = Q(:);
    
	%No_Part = U{4}(:);
    
	if isempty(varargin)
		filename = 'output.plt';
    else
        % Check filetype
        filename = strrep(varargin{1},'.dat','.plt');
	end
	
	nanmask = isnan(u) | isnan(v) | isnan(w);
	isValid = ~nanmask;
    % 	u(nanmask) = 0; v(nanmask) = 0; w(nanmask) = 0; u_std(nanmask) = 0; v_std(nanmask) = 0; w_std(nanmask) = 0;  umag(nanmask) = 0;
    %     du_dx(nanmask) = 0; du_dy(nanmask) = 0; du_dz(nanmask) = 0; dv_dx(nanmask) = 0; dv_dy(nanmask) = 0; dv_dz(nanmask) = 0; dw_dx(nanmask) = 0; dw_dy(nanmask) = 0; dw_dz(nanmask) = 0;
    %     omega_x(isnan(omega_x)) = 0;
    %     omega_y(isnan(omega_y)) = 0;
    %     omega_z(isnan(omega_z)) = 0;
    %     OMEGA(isnan(OMEGA))     = 0;
    %     Q(isnan(Q)) = 0;
    
    
    %     savematrix = [x, y, z, u, v, w, umag, u_std, v_std, w_std, du_dx, du_dy, du_dz, ...
    %         dv_dx, dv_dy, dv_dz,dw_dx, dw_dy, dw_dz, omega_x, omega_y, omega_z, OMEGA, Q, No_Part, isValid];
    %
    %     savematrix = single(savematrix);
    %     fid = fopen(filename, 'w');
    %
    % 	fprintf(fid, '%s\n', ['TITLE = "' filename '"']);
    % 	fprintf(fid, '%s\n', 'VARIABLES = "X", "Y", "Z", "U [m/s]", "V [m/s]", "W [m/s]", "|U| [m/s]", "U_std [m/s]", "V_std [m/s]", "W_std [m/s]", "du/dx [1/s]", "du/dy [1/s]", "du/dz [1/s]", "dv/dx [1/s]", "dv/dy [1/s]", "dv/dz [1/s]", "dw/dx [1/s]", "dw/dy [1/s]", "dw/dz [1/s]"  "OmX [Hz]", "OmY [Hz]", "OmZ [Hz]", "|Om| [Hz]", "Q", "No_Part", "isValid" ');
    % 	fprintf(fid, '%s\n', ['ZONE T="' filename '", J=' num2str(lenx) ', I=' num2str(leny) ', K=' num2str(lenz)]);

	%   fprintf(fid, '%.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %d %d\n', savematrix');
    %   fwrite(fid, savematrix', 'single');
    % 	fclose(fid);
    
    isvalid2 = reshape(isValid,size(X{1}));
    %%  Updated filewriting
    %   Restructure Data
    tdata=[];
    tdata.Nvar=26; %number of variables
    tdata.vformat = 2*ones(1,tdata.Nvar); %Double precision for each variable (optional)
    tdata.varnames={'X','Y','Z',...                                         % 3
                    'u [m/s]','v  [m/s]','w  [m/s]','|u|  [m/s]',...        % 4 (1-4)
                    'u_std [m/s]','v_std  [m/s]','w_std  [m/s]',...         % 3 (5-7)
                    'du/dx [1/s]','du/dy [1/s]','du/dz [1/s]',...           % 3 (8-10)
                    'dv/dx [1/s]','dv/dy [1/s]','dv/dz [1/s]',...           % 3 (11-13)
                    'dw/dx [1/s]','dw/dy [1/s]','dw/dz [1/s]',...           % 3 (14-16)
                    'Om_x [1/s]','Om_y [1/s]','Om_z [1/s]','|Om| [1/s]',... % 4 (17-20)
                    'Q','np','isvalid'};                                    % 3 (21-23)   
    tdata.cubes(1).zonename=strrep(filename,'.plt',' '); %any name
    % Grid
    tdata.cubes(1).x=X{1};%x
    tdata.cubes(1).y=X{2};%y
    tdata.cubes(1).z=X{3};%z
    % Mean Velocity
    tdata.cubes(1).v(1,:,:,: )=U{1};%u
    tdata.cubes(1).v(2,:,:,: )=U{2};%v
    tdata.cubes(1).v(3,:,:,: )=U{3};%w
    tdata.cubes(1).v(4,:,:,: )=umag;%|u|
    % Velocity Fluctuations
    tdata.cubes(1).v(5,:,:,: )=U_std{1};%u_std
    tdata.cubes(1).v(6,:,:,: )=U_std{2};%v_std
    tdata.cubes(1).v(7,:,:,: )=U_std{3};%w_std
    % Velocity gradients, u
    tdata.cubes(1).v(8,:,:,: )=du_dx;
    tdata.cubes(1).v(9,:,:,: )=du_dy;
    tdata.cubes(1).v(10,:,:,: )=du_dz;
    % Velocity gradients, v
    tdata.cubes(1).v(11,:,:,: )=dv_dx;
    tdata.cubes(1).v(12,:,:,: )=dv_dy;
    tdata.cubes(1).v(13,:,:,: )=dv_dz;
    % Velocity gradients, w
    tdata.cubes(1).v(14,:,:,: )=dw_dx;
    tdata.cubes(1).v(15,:,:,: )=dw_dy;
    tdata.cubes(1).v(16,:,:,: )=dw_dz;
    % Vorticity, Omega
    tdata.cubes(1).v(17,:,:,: )=omega_x;
    tdata.cubes(1).v(18,:,:,: )=omega_y;
    tdata.cubes(1).v(19,:,:,: )=omega_z;
    tdata.cubes(1).v(20,:,:,: )=OMEGA;
    % Q-criterion + flag variables
    tdata.cubes(1).v(21,:,:,: )=Q;
    tdata.cubes(1).v(22,:,:,: )=U{4};%np
    tdata.cubes(1).v(23,:,:,: )=isvalid2;%np
    mat2tecplot(tdata,filename)
end

% function [] = mat2tec(X, U, U_std, varargin)
% 	x = X{1}(:); lenx = length(unique(x));
% 	y = X{2}(:); leny = length(unique(y));
% 	z = X{3}(:); lenz = length(unique(z));
% 	u = U{1}(:);
% 	v = U{2}(:);
% 	w = U{3}(:);
%     u_std = U_std{1}(:);
%     v_std = U_std{2}(:);
%     w_std = U_std{3}(:);
%     
% 	No_Part = U{4}(:);
%     
% 	if isempty(varargin)
% 		filename = 'output.dat';
% 	else
% 		filename = varargin{1};
% 	end
% 	
% 	nanmask = isnan(u) | isnan(v) | isnan(w);
% 	isValid = ~nanmask;
% 	u(nanmask) = 0; v(nanmask) = 0; w(nanmask) = 0; u_std(nanmask) = 0; v_std(nanmask) = 0; w_std(nanmask) = 0; 
% 	savematrix = [x, y, z, u, v, w,u_std,v_std,w_std, No_Part, isValid];
% 	fid = fopen(filename, 'w');
% 
% 	fprintf(fid, '%s\n', ['TITLE = "' filename '"']);
% 	fprintf(fid, '%s\n', 'VARIABLES = "X [mm]", "Y [mm]", "Z [mm]", "U [m/s]", "V [m/s]", "W [m/s]", "U_std [m/s]", "V_std [m/s]", "W_std [m/s]","No_Part", "isValid" ');
% 	fprintf(fid, '%s\n', ['ZONE T="' filename '", J=' num2str(lenx) ', I=' num2str(leny) ', K=' num2str(lenz)]);
% 
% 	fprintf(fid, '%.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %d %d\n', savematrix');
% 	fclose(fid);
% end