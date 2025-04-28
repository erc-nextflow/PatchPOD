% INPUT:
% umean
% RS
% ppb

function p = averagepressure3_mod(rho,hx,hy,hz,acc,mask,Niter)

if numel(hx)>1; hx = hx(2)-hx(1); end
if numel(hy)>1; hy = hy(2)-hy(1); end
if numel(hz)>1; hz = hz(2)-hz(1); end

atemp = acc; clear acc; 
amean = atemp{1}; 
amean(:,:,:,2) = atemp{2};
amean(:,:,:,3) = atemp{3}; 

% Calculate required derivatives
% amean_dx = ddx_mod(hx,amean,mask);
% amean_dy = ddy_mod(hy,amean,mask);
% amean_dz = ddz_mod(hz,amean,mask);

% upup_dx = ddx_mod(hx,RS.upup,mask);
% upvp_dy = ddy_mod(hy,RS.upvp,mask);
% upwp_dz = ddz_mod(hz,RS.upwp,mask);
% 
% upvp_dx = ddx_mod(hx,RS.upvp,mask);
% vpvp_dy = ddy_mod(hy,RS.vpvp,mask);
% vpwp_dz = ddz_mod(hz,RS.vpwp,mask);
% 
% upwp_dx = ddx_mod(hx,RS.upwp,mask);
% vpwp_dy = ddy_mod(hy,RS.vpwp,mask);
% wpwp_dz = ddz_mod(hz,RS.wpwp,mask);

g(:,:,:,1) = -rho * amean(:,:,:,1);
g(:,:,:,2) = -rho * amean(:,:,:,2);
g(:,:,:,3) = -rho * amean(:,:,:,3);

% g(:,:,:,1) = -rho * ( ...
%     amean(:,:,:,1).*umean_dx(:,:,:,1) + ...
%     amean(:,:,:,2).*umean_dy(:,:,:,1) + ...
%     amean(:,:,:,3).*umean_dz(:,:,:,1) + ...
%     upup_dx + ...
%     upvp_dy + ...
%     upwp_dz );

% g(:,:,:,2) = -rho * ( ...
%     amean(:,:,:,1).*umean_dx(:,:,:,2) + ...
%     amean(:,:,:,2).*umean_dy(:,:,:,2) + ...
%     amean(:,:,:,3).*umean_dz(:,:,:,2) + ...
%     upvp_dx + ...
%     vpvp_dy + ...
%     vpwp_dz );
% 
% g(:,:,:,3) = -rho * ( ...
%     amean(:,:,:,1).*umean_dx(:,:,:,3) + ...
%     amean(:,:,:,2).*umean_dy(:,:,:,3) + ...
%     amean(:,:,:,3).*umean_dz(:,:,:,3) + ...
%     upwp_dx + ...
%     vpwp_dy + ...
%     wpwp_dz );

% keyboard
g(isnan(g)) = 0;
p = antigradient2Mod(g, mask, 0, Niter, hx, hy, hz);

disp('done')




