% Particle ensemble averaging (binning)
% Jan Schneiders - 2017
%
% v1. 'slow' implementation (sorting one direction only)
% v2. 'fast' implementation using binary search in 3 directions
%
% Requires the 'binarySearch' package!!
%
% INPUT
% xm = measured particle positions
% um = measured particle velocities
% ‘opts’ contains the desired bin size (opts.WS) and the overlap (opts.overlap)

function [x, X, umean, ustd, ppb] = particlemean_v2(xm,um,opts)

if opts.gridgiven == 0
    % create the grid
    hx = opts.WS*(1-opts.overlap/100);
    hy = opts.WS*(1-opts.overlap/100);
    hz = opts.WS*(1-opts.overlap/100);
    
    cr = opts.particle_options.cropper;
    
    x{1} = cr(1):hx:cr(2);
    x{2} = cr(3):hy:cr(4);
    x{3} = cr(5):hz:cr(6);
    
    [X{1},X{2},X{3}] = meshgrid(x{1},x{2},x{3});
else
    X = opts.X;
    x = opts.x;
end

% preload and calculate
u_mean_vec = zeros(numel(X{1}),3);
u_std_vec  = zeros(numel(X{1}),3);
ppb        = zeros(numel(X{1}),1);

xmum = [xm; um]';
xm1  = xmum(:,1);

% do some sorting
[xm1, sortind] = sortrows(xm1,1);
xmum = xmum(sortind,:);

fprintf('%i / %i (%3.0f %%)\n',1,numel(X{1}),1/numel(X{1})*100);

xmum_sel_Xsel_Zsorted = [];
xmum_sel_Xsel_Zsel_Ysorted = [];

Xsel = NaN;
for k = 1:numel(X{1})
    
    if mod(k,1000) == 0
        fprintf('%i / %i (%3.0f %%)\n',k,numel(X{1}),k/numel(X{1})*100);
    end
    
    xxi = find(x{1}==X{1}(k));
    zzi = find(x{3}==X{3}(k));
    
    if numel(xmum_sel_Xsel_Zsorted) ~= numel(x{1})
        if k == 1 || X{1}(k) ~= Xsel
            Xsel = X{1}(k);
            Zsel = NaN;
            
            % Binary search for the x-coordinate (because sorted)
            li = binarySearch(xm1, X{1}(k) - opts.WS/2);
            ui = binarySearch(xm1, X{1}(k) + opts.WS/2);
            
            xmum_sel_Xsel = xmum(li:ui,:);
            
            xm3{xxi} = xmum_sel_Xsel(:,3);
            [xm3{xxi}, sortind] = sortrows(xm3{xxi},1);
            xmum_sel_Xsel_Zsorted{xxi} = xmum_sel_Xsel(sortind,:);
        end
    else
        if k == 1 || X{1}(k) ~= Xsel
            Xsel = X{1}(k);
            Zsel = NaN;
        end
    end
    
    if numel(xmum_sel_Xsel_Zsel_Ysorted(:)) ~= numel(x{1})*numel(x{3}) || numel(xmum_sel_Xsel_Zsel_Ysorted{xxi,zzi}) == 0
        if k == 1 || X{3}(k) ~= Zsel
            Zsel = X{3}(k);
            
            % Binary search for the z-coordinate (because now also sorted)
            li = binarySearch(xm3{xxi}, X{3}(k) - opts.WS/2);
            ui = binarySearch(xm3{xxi}, X{3}(k) + opts.WS/2);
            xmum_sel_Xsel_Zsel = xmum_sel_Xsel_Zsorted{xxi}(li:ui,:);
            
            xm2{xxi,zzi} = xmum_sel_Xsel_Zsel(:,2);
            [xm2{xxi,zzi}, sortind] = sortrows(xm2{xxi,zzi},1);
            xmum_sel_Xsel_Zsel_Ysorted{xxi,zzi} = xmum_sel_Xsel_Zsel(sortind,:);
        end
    end
    
    % Binary search for the y-coordinate (because now also sorted)
    li = binarySearch(xm2{xxi,zzi}, X{2}(k) - opts.WS/2);
    ui = binarySearch(xm2{xxi,zzi}, X{2}(k) + opts.WS/2);
    
    xmum_sel = xmum_sel_Xsel_Zsel_Ysorted{xxi,zzi}(li:ui,:);
    
    if numel(xmum_sel) > 0
        
        xmum_sel_flt = xmum_sel;
        um_sel_flt   = xmum_sel(:,4:6);
        
        % Outlier removal
        for flti = 1:1
            u_mean_vec(k,:) = mean(um_sel_flt,1);
            u_std_vec(k,:)  = std(um_sel_flt,0,1);
            for cc = 1:3
                up = bsxfun(@minus, um_sel_flt, u_mean_vec(k,:));
                flt = abs(up(:,cc)) > 3*u_std_vec(k,cc);
                um_sel_flt(flt,:) = [];
                xmum_sel_flt(flt,:) = [];
            end
            u_mean_vec(k,:) = mean(um_sel_flt,1);
            u_std_vec(k,:)  = std(um_sel_flt,0,1);
        end
        
        ppb(k,:) = size(um_sel_flt,1);
    end
    
end

ppb   = reshape(ppb,[size(X{1}) 1]);
umean = reshape(u_mean_vec,[size(X{1}) 3]);
ustd  = reshape(u_std_vec,[size(X{1}) 3]);

flt = repmat(ppb,[1 1 1 3]) == 0;
umean(flt) = NaN;
ustd(flt)  = NaN;



