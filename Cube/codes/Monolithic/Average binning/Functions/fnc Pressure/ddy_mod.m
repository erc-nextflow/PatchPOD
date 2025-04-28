% function: ddy
% cite: Schneiders, J.F.G. & Scarano, F. Exp Fluids (2016) 57:139. doi:10.1007/s00348-016-2225-6
% http://link.springer.com/article/10.1007/s00348-016-2225-6

function dudy = ddy_mod(dy,u,mask)

if nargin == 2
    dudy = zeros(size(u));
    
    % 1st order Upwind on boundaries
    
    dudy(1,:,:)  = 1/1/dy * (u(2,:,:) - u(1,:,:));
    dudy(end,:,:) = 1/1/dy * (u(end,:,:) - u(end-1,:,:));
    
    % 2nd order Central difference on 2nd cells
    
    dudy(2:end-1,:,:) = 1/2/dy * ( - u(1:end-2,:,:) + u(3:end,:,:) );
    
    
else
    dudy = zeros(size(u));
    
    dudy_cd = zeros(size(u));
    dudy_fd = zeros(size(u));
    dudy_bd = zeros(size(u));
    
    % 1st order FWD differences
    dudy_fd(1:end-1,:,:) = 1/1/dy * (u(2:end,:,:) - u(1:end-1,:,:)); 
    
    % 1st order BWD differences
    dudy_bd(2:end,:,:) = 1/1/dy * (u(2:end,:,:) - u(1:end-1,:,:));
    
    % 2nd order central differences
    dudy_cd(2:end-1,:,:) = 1/2/dy * ( - u(1:end-2,:,:) + u(3:end,:,:) );

    % Define specific masks
    sizeU = size(mask); sizeU(1) = sizeU(1) + 2;
    MASK = zeros(sizeU);               % padded mask array
    MASK(2:end-1,:,:) = mask;                   
    
    MASK_fd = MASK(3:end,:,:) - MASK(2:end-1,:,:);      % FWD difference mask (-1 = not applicable; 0 = possible (if MASK == 0); 1 = applicable)
    MASK_fd(MASK_fd == 0 & mask == 1) = 1; MASK_fd(MASK_fd == -1) = 0;
    
    MASK_bd = MASK(2:end-1,:,:) - MASK(1:end-2,:,:);    % BWD difference mask (-1 = applicable; 0 = possible (if MASK == 1); 1 = not applicable) 
    MASK_bd = -MASK_bd;
    MASK_bd(MASK_bd == 0 & mask == 1) = 1; MASK_bd(MASK_bd == -1) = 0;
    
    MASK_cd = zeros(size(mask)); 
    MASK_cd(MASK_bd == 1 & MASK_fd == 1 & mask == 1) = 1; 
    
    % Stretch mask for all velocity components
    if (size(u,4) > 1)
        
        for ii = 2:size(u,4)
            MASK_bd(:,:,:,ii) = MASK_bd(:,:,:,1);
            MASK_fd(:,:,:,ii) = MASK_fd(:,:,:,1);
            MASK_cd(:,:,:,ii) = MASK_cd(:,:,:,1);
            mask(:,:,:,ii)    = mask(:,:,:,1);
        end
        
    end
    
    % Assemble results based on masks
    dudy(MASK_fd == 1) = dudy_fd(MASK_fd == 1);
    dudy(MASK_bd == 1) = dudy_bd(MASK_bd == 1);
    dudy(MASK_cd == 1) = dudy_cd(MASK_cd == 1);
    dudy(mask == 0) = nan; 
    dudy(MASK_fd == 0 & MASK_bd == 0) = nan; 
    
%     [u; mask; dudy; dudy_cd; dudy_fd; dudy_bd];
end