% INPUT:
% umean
% RS
% ppb

function p = averagepressure2(rho,hx,hy,hz,umean,RS,ppb,Niter)

if numel(hx)>1; hx = hx(2)-hx(1); end
if numel(hy)>1; hy = hy(2)-hy(1); end
if numel(hz)>1; hz = hz(2)-hz(1); end

utemp = umean; clear umean; 
umean = utemp{1}; 
umean(:,:,:,2) = utemp{2};
umean(:,:,:,3) = utemp{3}; 

% Calculate required derivatives
umean_dx = ddx(hx,umean);
umean_dy = ddy(hy,umean);
umean_dz = ddz(hz,umean);

upup_dx = ddx(hx,RS.upup);
upvp_dy = ddy(hy,RS.upvp);
upwp_dz = ddz(hz,RS.upwp);

upvp_dx = ddx(hx,RS.upvp);
vpvp_dy = ddy(hy,RS.vpvp);
vpwp_dz = ddz(hz,RS.vpwp);

upwp_dx = ddx(hx,RS.upwp);
vpwp_dy = ddy(hy,RS.vpwp);
wpwp_dz = ddz(hz,RS.wpwp);

% g(:,:,:,1) = dpdx; 
% g(:,:,:,2) = dpdy; 
% g(:,:,:,3) = dpdz;

g(:,:,:,1) = -rho * ( ...
    umean(:,:,:,1).*umean_dx(:,:,:,1) + ...
    umean(:,:,:,2).*umean_dy(:,:,:,1) + ...
    umean(:,:,:,3).*umean_dz(:,:,:,1) + ...
    upup_dx + ...
    upvp_dy + ...
    upwp_dz );

g(:,:,:,2) = -rho * ( ...
    umean(:,:,:,1).*umean_dx(:,:,:,2) + ...
    umean(:,:,:,2).*umean_dy(:,:,:,2) + ...
    umean(:,:,:,3).*umean_dz(:,:,:,2) + ...
    upvp_dx + ...
    vpvp_dy + ...
    vpwp_dz );

g(:,:,:,3) = -rho * ( ...
    umean(:,:,:,1).*umean_dx(:,:,:,3) + ...
    umean(:,:,:,2).*umean_dy(:,:,:,3) + ...
    umean(:,:,:,3).*umean_dz(:,:,:,3) + ...
    upwp_dx + ...
    vpwp_dy + ...
    wpwp_dz );

keyboard
g(isnan(g)) = 0;
p = antigradient2Mod(g, ppb, 0, Niter, hx, hy, hz);

disp('done')




