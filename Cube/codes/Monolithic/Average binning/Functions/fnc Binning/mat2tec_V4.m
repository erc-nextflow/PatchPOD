function [] = mat2tec_V4(X, U, U_std, p, varargin)
	x = X{1}(:); lenx = length(unique(x));
	y = X{2}(:); leny = length(unique(y));
	z = X{3}(:); lenz = length(unique(z));
	u = U{1}(:);
	v = U{2}(:);
	w = U{3}(:);
    
    umag = sqrt(u.^2+v.^2+w.^2);
    
    u_std = U_std{1}(:);
    v_std = U_std{2}(:);
    w_std = U_std{3}(:);
    
    hx = (X{1}(1,2,1)-X{1}(1,1,1))*1e-3;
    hy = (X{2}(2,1,1)-X{2}(1,1,1))*1e-3;
    hz = (X{3}(1,1,2)-X{3}(1,1,1))*1e-3;
    umat(:,:,:,1) = U{1};
    umat(:,:,:,2) = U{2};
    umat(:,:,:,3) = U{3};
    XI = xicalc3d(hx,hy,hz,umat,200);
    Q  = qcritcalc(hx,hy,hz,umat);
    
    omega_x = XI(:,:,:,1);      omega_x = omega_x(:);
    omega_y = XI(:,:,:,2);      omega_y = omega_y(:);
    omega_z = XI(:,:,:,3);      omega_z = omega_z(:);
    OMEGA = sqrt(sum(XI.^2,4)); OMEGA = OMEGA(:);
    Q = Q(:);
    
    P = p(:);
    
	No_Part = U{4}(:);
      
	if isempty(varargin)
		filename = 'output.dat';
	else
		filename = varargin{1};
	end
	
	nanmask = isnan(u) | isnan(v) | isnan(w);
	isValid = ~nanmask;
	u(nanmask) = 0; v(nanmask) = 0; w(nanmask) = 0; u_std(nanmask) = 0; v_std(nanmask) = 0; w_std(nanmask) = 0;  umag(nanmask) = 0; 
    pmask = isnan(P); P(pmask) = 0;
    
    omega_x(isnan(omega_x)) = 0;
    omega_y(isnan(omega_y)) = 0;
    omega_z(isnan(omega_z)) = 0;
    OMEGA(isnan(OMEGA))     = 0;
    Q(isnan(Q)) = 0;
    
    
	savematrix = [x, y, z, u, v, w, umag, u_std, v_std, w_std, omega_x, omega_y, omega_z, OMEGA, Q, P, No_Part, isValid];
	fid = fopen(filename, 'w');

	fprintf(fid, '%s\n', ['TITLE = "' filename '"']);
	fprintf(fid, '%s\n', 'VARIABLES = "X", "Y", "Z", "U [m/s]", "V [m/s]", "W [m/s]", "|U| [m/s]", "U_std [m/s]", "V_std [m/s]", "W_std [m/s]", "OmX [Hz]", "OmY [Hz]", "OmZ [Hz]", "|Om| [Hz]", "Q", "P", "No_Part", "isValid" ');
	fprintf(fid, '%s\n', ['ZONE T="' filename '", J=' num2str(lenx) ', I=' num2str(leny) ', K=' num2str(lenz)]);

	fprintf(fid, '%.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %d %d\n', savematrix');
	fclose(fid);
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