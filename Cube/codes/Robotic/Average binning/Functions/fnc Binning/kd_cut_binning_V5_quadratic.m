function [U,varargout,RS] = kd_cut_binning_V5_quadratic(X, xm, um, bin_size, n_slices,min_np_found)

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
upup = [];vpvp = []; wpwp = [];
upvp = []; upwp = []; vpwp = [];

% 	progressbar('Binning', []);
% keyboard
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
    
    upup_vec = zeros(numel(xmesh),1);
    vpvp_vec = zeros(numel(xmesh),1);
    wpwp_vec = zeros(numel(xmesh),1);
    upvp_vec = zeros(numel(xmesh),1);
    upwp_vec = zeros(numel(xmesh),1);
    vpwp_vec = zeros(numel(xmesh),1);
    
    for k = 1 : numel(xmesh)  % cycle on each centroid position
        % 			progressbar([], k / numel(xmesh));
        xm_sel = xmum_slice(idx{k}, 1:3);
        um_sel = xmum_slice(idx{k}, 4:6);
        
        % FILTER: 1 mean filter
        [xm_sel,um_sel, No_Part_Deleted, Indices] = Velocity_Filter_V2(xm_sel,um_sel,1);
        
        % update particle count
        np_found_vec(k) = np_found_vec(k) - No_Part_Deleted;
            
        % if size(um_sel, 1) >= max([min_np_found, 21])
        if np_found_vec(k) >= max([min_np_found, 21])
            
            % Calculating weights
            weights = transpose(weights_cell{k}(Indices));

            % Translate grid to origin. Important to keep system rank!         
            xm_sel = xm_sel - [xmesh(k) ymesh(k) zmesh(k)];
            
            % Assemble linear set of equations
            A  = [xm_sel(:,1).^2, xm_sel(:,1).*xm_sel(:,2), xm_sel(:,1).*xm_sel(:,3), xm_sel(:,2).^2, xm_sel(:,2).*xm_sel(:,3), xm_sel(:,3).^2, xm_sel , ones(size(xm_sel(:,1)))]; 
            um_sel_fit = zeros(size(xm_sel));
            
            for ii = 1:3
                c1 = A\um_sel(:,ii);
                u_binmean_vec(k,ii) = c1(10);
                um_sel_fit(:, ii) = ...
                    c1(1) * xm_sel(:,1).^2 + ...
                    c1(2) * xm_sel(:,1).*xm_sel(:,2) + ...
                    c1(3) * xm_sel(:,1).*xm_sel(:,3) + ...
                    c1(4) * xm_sel(:,2).^2 + ...
                    c1(5) * xm_sel(:,2).*xm_sel(:,3) + ...
                    c1(6) * xm_sel(:,3).^2 + ...
                    c1(7) * xm_sel(:,1) + ...
                    c1(8) * xm_sel(:,2) + ...
                    c1(9) * xm_sel(:,3) + ...
                    c1(10);
            end
            % Calculating statistics
            % u_binstd_vec(k, :)  = stdev_fun(um_sel, weights);
            u_binstd_vec(k, :)  = stdev_fun(um_sel - um_sel_fit, weights);
            
            % Reynolds stresses
            %up  = bsxfun(@minus, um_sel, u_binmean_vec(k, :));
            up  = bsxfun(@minus, um_sel, um_sel_fit);
            
            upup_vec(k,:) = mean(up(:,1) .* up(:,1));
            upvp_vec(k,:) = mean(up(:,1) .* up(:,2));
            upwp_vec(k,:) = mean(up(:,1) .* up(:,3));
            vpvp_vec(k,:) = mean(up(:,2) .* up(:,2));
            vpwp_vec(k,:) = mean(up(:,2) .* up(:,3));
            wpwp_vec(k,:) = mean(up(:,3) .* up(:,3));
            
            
        else
            u_binmean_vec(k, :) = NaN;
            u_binstd_vec(k, :)  = NaN;
            
            upup_vec(k,:) = NaN;
            upvp_vec(k,:) = NaN;
            upwp_vec(k,:) = NaN;
            vpvp_vec(k,:) = NaN;
            vpwp_vec(k,:) = NaN;
            wpwp_vec(k,:) = NaN;
        end
        
    end
    % 		progressbar([], 1);
    
    u_binmean_vec = reshape(u_binmean_vec, [size(xmesh), 3]);
    u_binstd_vec  = reshape(u_binstd_vec, [size(xmesh), 3]);
    np_found_vec  = reshape(np_found_vec, size(xmesh));
    
    u_binmean_out = [u_binmean_out, u_binmean_vec];
    u_binstd_out  = [u_binstd_out, u_binstd_vec];
    np_found_out  = [np_found_out, np_found_vec];
    
    upup_vec = reshape(upup_vec,[size(xmesh) 1]);
    vpvp_vec = reshape(vpvp_vec,[size(xmesh) 1]);
    wpwp_vec = reshape(wpwp_vec,[size(xmesh) 1]);
    
    upvp_vec = reshape(upvp_vec,[size(xmesh) 1]);
    upwp_vec = reshape(upwp_vec,[size(xmesh) 1]);
    vpwp_vec = reshape(vpwp_vec,[size(xmesh) 1]);
    
    upup = [upup, upup_vec];
    vpvp = [vpvp, vpvp_vec];
    wpwp = [wpwp, wpwp_vec];
    
    upvp = [upvp, upvp_vec];
    upwp = [upwp, upwp_vec];
    vpwp = [vpwp, vpwp_vec];
    
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
varargout = stdev;

RS.upup = upup;
RS.vpvp = vpvp;
RS.wpwp = wpwp;
RS.upvp = upvp; 
RS.upwp = upwp;
RS.vpwp = vpwp;
end
