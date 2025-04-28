function U = kd_cut_binning(X, xm, um, bin_size, n_slices,min_np_found)

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
np_found_out  = [];

parfor i = 1 : n_slices
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
    
    u_binmean_vec = zeros(numel(xmesh), 3);
    np_found_vec = cellfun(@length, idx);
    
    for k = 1 : numel(xmesh)  % cycle on each centroid position
        % 			progressbar([], k / numel(xmesh));
        xm_sel = xmum_slice(idx{k}, 1:3);
        um_sel = xmum_slice(idx{k}, 4:6);
            
        % if size(um_sel, 1) >= min_np_found
        if np_found_vec(k) >= min_np_found         
            % Calculating statistics
            u_binmean_vec(k, :) = mean(um_sel,1);
        else
            u_binmean_vec(k, :) = NaN;
        end
        
    end
    
    u_binmean_vec = reshape(u_binmean_vec, [size(xmesh), 3]);
    np_found_vec  = reshape(np_found_vec, size(xmesh));
    
    u_binmean_out = [u_binmean_out, u_binmean_vec];
    np_found_out  = [np_found_out, np_found_vec];
end

U{1} = u_binmean_out(:, :, :, 1);
U{2} = u_binmean_out(:, :, :, 2);
U{3} = u_binmean_out(:, :, :, 3);
U{4} = np_found_out;
end
