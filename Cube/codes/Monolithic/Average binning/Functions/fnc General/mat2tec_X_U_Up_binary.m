function [] = mat2tec_X_U_Up_binary(X, U, U_std, varargin)
	x = X{1}(:); %lenx = length(unique(x));
	y = X{2}(:); %leny = length(unique(y));
	z = X{3}(:); %lenz = length(unique(z));
	u = U{1}(:);
	v = U{2}(:);
	w = U{3}(:);
    
    umag = (U{1}.^2+U{2}.^2+U{3}.^2).^(0.5);
       
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
   
    isvalid2 = reshape(isValid,size(X{1}));
    %%  Updated filewriting
    %   Restructure Data
    tdata=[];
    tdata.Nvar=17; %number of variables
    tdata.vformat = 2*ones(1,tdata.Nvar); %Double precision for each variable (optional)
    tdata.varnames={'X','Y','Z',...                                         % 3
                    'u [m/s]','v  [m/s]','w  [m/s]','|u|  [m/s]',...        % 4 (1-4)
                    'u_std [m/s]','v_std  [m/s]','w_std  [m/s]',...         % 3 (5-7)
                    'Om_x [1/s]','Om_y [1/s]','Om_z [1/s]','|Om| [1/s]',... % 4 (8-11)
                    'Q','np','isvalid'};                                    % 3 (12-14)   
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
    
    % Vorticity, Omega
    tdata.cubes(1).v(8,:,:,: )=omega_x;
    tdata.cubes(1).v(9,:,:,: )=omega_y;
    tdata.cubes(1).v(10,:,:,: )=omega_z;
    tdata.cubes(1).v(11,:,:,: )=OMEGA;
    % Q-criterion + flag variables
    tdata.cubes(1).v(12,:,:,: )=Q;
    tdata.cubes(1).v(13,:,:,: )=U{4};%np
    tdata.cubes(1).v(14,:,:,: )=isvalid2;%np
    mat2tecplot(tdata,filename)
end

