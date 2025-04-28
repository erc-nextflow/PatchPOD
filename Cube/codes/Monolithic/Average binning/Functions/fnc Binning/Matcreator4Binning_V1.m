function [savematrix] = Matcreator4Binning_V1(X, U, U_std, varargin)
	x = X{1}(:); lenx = length(unique(x));
	y = X{2}(:); leny = length(unique(y));
	z = X{3}(:); lenz = length(unique(z));
	u = U{1}(:);
	v = U{2}(:);
	w = U{3}(:);
    u_std = U_std{1}(:);
    v_std = U_std{2}(:);
    w_std = U_std{3}(:);
    
	No_Part = U{4}(:);
    
	if isempty(varargin)
		filename = 'output.dat';
	else
		filename = varargin{1};
	end
	
	nanmask = isnan(u) | isnan(v) | isnan(w);
	isValid = ~nanmask;
	u(nanmask) = 0; v(nanmask) = 0; w(nanmask) = 0; u_std(nanmask) = 0; v_std(nanmask) = 0; w_std(nanmask) = 0; 
	savematrix = [x, y, z, u, v, w,u_std,v_std,w_std, No_Part, isValid];
    
	fid = fopen(filename, 'w');

	fprintf(fid, '%s\n', ['TITLE = "' filename '"']);
	fprintf(fid, '%s\n', 'VARIABLES = "X [mm]", "Y [mm]", "Z [mm]", "U [m/s]", "V [m/s]", "W [m/s]", "U_std [m/s]", "V_std [m/s]", "W_std [m/s]","No_Part", "isValid" ');
	fprintf(fid, '%s\n', ['ZONE T="' filename '", J=' num2str(lenx) ', I=' num2str(leny) ', K=' num2str(lenz)]);

	fprintf(fid, '%.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %.4f %d %d\n', savematrix');
	fclose(fid);
    
end