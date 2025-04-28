% function: ddx
% cite: Schneiders, J.F.G. & Scarano, F. Exp Fluids (2016) 57:139. doi:10.1007/s00348-016-2225-6
% http://link.springer.com/article/10.1007/s00348-016-2225-6

function dudx = ddx_mod(dx, u, mask)

if nargin == 2
    
    dudx = zeros(size(u));
    
    % 1st order Upwind on boundaries
    
    dudx(:,1,:)  = 1/1/dx * (u(:,2,:) - u(:,1,:));
    dudx(:,end,:) = 1/1/dx * (u(:,end,:) - u(:,end-1,:));
    
    % 2nd order Central difference on 2nd cells
    
    dudx(:,2:end-1,:) = 1/2/dx * ( - u(:,1:end-2,:) + u(:,3:end,:) );
    
else
    dudx = zeros(size(u));
    
    dudx_cd = zeros(size(u));
    dudx_fd = zeros(size(u));
    dudx_bd = zeros(size(u));
    
    % 1st order FWD differences
    dudx_fd(:,1:end-1,:) = 1/1/dx * (u(:,2:end,:) - u(:,1:end-1,:)); 
    
    % 1st order BWD differences
    dudx_bd(:,2:end,:) = 1/1/dx * (u(:,2:end,:) - u(:,1:end-1,:));
    
    % 2nd order central differences
    dudx_cd(:,2:end-1,:) = 1/2/dx * ( - u(:,1:end-2,:) + u(:,3:end,:) );

    % Define specific masks
    sizeU = size(mask); sizeU(2) = sizeU(2) + 2;
    MASK = zeros(sizeU);               % padded mask array
    MASK(:,2:end-1,:) = mask;                   
    
    MASK_fd = MASK(:,3:end,:) - MASK(:,2:end-1,:);      % FWD difference mask (-1 = not applicable; 0 = possible (if MASK == 0); 1 = applicable)
    MASK_fd(MASK_fd == 0 & mask == 1) = 1; MASK_fd(MASK_fd == -1) = 0;
    
    MASK_bd = MASK(:,2:end-1,:) - MASK(:,1:end-2,:);    % BWD difference mask (-1 = applicable; 0 = possible (if MASK == 1); 1 = not applicable) 
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
    dudx(MASK_fd == 1) = dudx_fd(MASK_fd == 1);
    dudx(MASK_bd == 1) = dudx_bd(MASK_bd == 1);
    dudx(MASK_cd == 1) = dudx_cd(MASK_cd == 1);
    dudx(mask == 0) = nan; 
    dudx(MASK_fd == 0 & MASK_bd == 0) = nan; 
    
%     [u; mask; dudx; dudx_cd; dudx_fd; dudx_bd];
end