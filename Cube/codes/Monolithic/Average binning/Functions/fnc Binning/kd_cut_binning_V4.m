function [U,varargout] = kd_cut_binning_V4(X, xm, um, bin_size, n_slices,min_np_found)
	
% Checking whether to calculate standard deviation
	
	% Allowing for stdev calculation only if flag is positive
	stdev_fun = @(set, weights) std(set, weights, 1);


	x_vec = unique(X{1}(1, :, 1)); x_vec = x_vec(:); % The second part is make the row matrix into column matrix
	y_vec = unique(X{2}(:, 1, 1)); y_vec = y_vec(:);
	z_vec = unique(X{3}(1, 1, :)); z_vec = z_vec(:);
	
	x_slices = split_vector(x_vec, n_slices);
	n_slices = length(x_slices);
	
	xmum = transpose([xm; um]); % matrix that cointains |x|y|z|u|v|w|
	
    % Sorting xmum along the x position
    [xmum] = Sorting_nth_column(xmum,1);
	
	sigma = bin_size / 2;
	u_binmean_out = [];
	u_binstd_out  = [];
	np_found_out  = [];
	
% 	progressbar('Binning', []);
    tic
	parfor i = 1 : n_slices
        i
		[xmesh, ymesh, zmesh] = meshgrid(x_slices{i}, y_vec, z_vec);
		% Now it looks for the interval of indices for which the particle
		% are in the slice
        li = binarySearch(xmum(:,1), x_slices{i}(1) - bin_size / 2);
		ui = binarySearch(xmum(:,1), x_slices{i}(end) + bin_size / 2);
		
        % Take into consideration only the slice, save all the particle of
        % the slice in a proper matrix
		xmum_slice = unique(xmum(li:ui, :),'rows');
				
		gridpoints = [xmesh(:), ymesh(:), zmesh(:)];
        
		[idx, dist] = rangesearch(xmum_slice(:, 1:3), gridpoints, bin_size / 2, 'distance', 'euclidean');
        
        
        weights_cell = cellfun(@(x) exp(-x .^ 2 / sigma ^ 2), dist, 'uniformoutput', false);
	
		u_binmean_vec = zeros(numel(xmesh), 3);
		u_binstd_vec  = zeros(numel(xmesh), 3);
		np_found_vec = cellfun(@length, idx);
		
		for k = 1 : numel(xmesh)  % cycle on each centroid position
% 			progressbar([], k / numel(xmesh));
            xm_sel = xmum_slice(idx{k}, 1:3);
			um_sel = xmum_slice(idx{k}, 4:6);
			
            if size(um_sel, 1) >= min_np_found
				
                % FILTER: 1 mean filter
                [xm_sel,um_sel, No_Part_Deleted, Indices] = Velocity_Filter_V2(xm_sel,um_sel,1);
                
                % Calculating weights
				 weights = transpose(weights_cell{k}(Indices));
                
				% Calculating statistics
				u_binmean_vec(k, :) = sum(bsxfun(@times, um_sel, weights), 1) / sum(weights);
				u_binstd_vec(k, :) = stdev_fun(um_sel, weights);
			else
				u_binmean_vec(k, :) = NaN;
				u_binstd_vec(k, :)  = NaN;
            end
            
		end
% 		progressbar([], 1);

		u_binmean_vec = reshape(u_binmean_vec, [size(xmesh), 3]);
		u_binstd_vec  = reshape(u_binstd_vec, [size(xmesh), 3]);
		np_found_vec  = reshape(np_found_vec, size(xmesh));
	
		u_binmean_out = [u_binmean_out, u_binmean_vec];
		u_binstd_out  = [u_binstd_out, u_binstd_vec];
		np_found_out  = [np_found_out, np_found_vec];
		
% 		progressbar(i / n_slices, []);
    end
    time = toc
% 	progressbar(1, []);
	
	U{1} = u_binmean_out(:, :, :, 1);
	U{2} = u_binmean_out(:, :, :, 2);
	U{3} = u_binmean_out(:, :, :, 3);
	U{4} = np_found_out;
		stdev{1} = u_binstd_out(:, :, :, 1);
		stdev{2} = u_binstd_out(:, :,  :, 2);
		stdev{3} = u_binstd_out(:, :, :, 3);
		varargout{1} = stdev;
        
end
	