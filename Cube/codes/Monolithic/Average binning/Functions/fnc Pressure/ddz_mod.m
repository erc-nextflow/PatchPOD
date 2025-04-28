% function: ddz
% cite: Schneiders, J.F.G. & Scarano, F. Exp Fluids (2016) 57:139. doi:10.1007/s00348-016-2225-6
% http://link.springer.com/article/10.1007/s00348-016-2225-6
 
function dudz = ddz_mod(dz,u,mask)
 
if nargin == 2
     
    dudz = zeros(size(u));
     
    % 1st order Upwind on boundaries
     
    dudz(:,:,1)  = 1/1/dz * (u(:,:,2) - u(:,:,1));
    dudz(:,:,end) = 1/1/dz * (u(:,:,end) - u(:,:,end-1));
     
    % 2nd order Central difference on 2nd cells
     
    dudz(:,:,2:end-1) = 1/2/dz * ( - u(:,:,1:end-2) + u(:,:,3:end) );
     
else
    dudz = zeros(size(u));
    
    dudz_cd = zeros(size(u));
    dudz_fd = zeros(size(u));
    dudz_bd = zeros(size(u));
    
    % 1st order FWD differences
    dudz_fd(:,:,1:end-1) = 1/1/dz * (u(:,:,2:end) - u(:,:,1:end-1)); 
    
    % 1st order BWD differences
    dudz_bd(:,:,2:end) = 1/1/dz * (u(:,:,2:end) - u(:,:,1:end-1));
    
    % 2nd order central differences
    dudz_cd(:,:,2:end-1) = 1/2/dz * ( - u(:,:,1:end-2) + u(:,:,3:end) );

    % Define specific masks
    sizeU = size(mask); sizeU(3) = sizeU(3) + 2;
    MASK = zeros(sizeU);               % padded mask array
    MASK(:,:,2:end-1) = mask;                   
    
    MASK_fd = MASK(:,:,3:end) - MASK(:,:,2:end-1);      % FWD difference mask (-1 = not applicable; 0 = possible (if MASK == 0); 1 = applicable)
    MASK_fd(MASK_fd == 0 & mask == 1) = 1; MASK_fd(MASK_fd == -1) = 0;
    
    MASK_bd = MASK(:,:,2:end-1) - MASK(:,:,1:end-2);    % BWD difference mask (-1 = applicable; 0 = possible (if MASK == 1); 1 = not applicable) 
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
    dudz(MASK_fd == 1) = dudz_fd(MASK_fd == 1);
    dudz(MASK_bd == 1) = dudz_bd(MASK_bd == 1);
    dudz(MASK_cd == 1) = dudz_cd(MASK_cd == 1);
    dudz(mask == 0) = nan; 
    dudz(MASK_fd == 0 & MASK_bd == 0) = nan; 
    
%     [u; mask; dudz; dudz_cd; dudz_fd; dudz_bd];
end