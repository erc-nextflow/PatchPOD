%% Function to allow antigradient (Ebbers and Farneback, 2009, J Magn Reson Imag) 
%  to take on meshgrids with uniform mesh spacing hx
%  JFG Schneiders, j.f.g.schneiders@tudelft.nl , Spring 2014
%  
%  g(:,:,:,1) = dp/dx
%  g(:,:,:,2) = dp/dy
%  for 3d: g(:,:,:,3) = dp/dz
%  
%  mu = average value of the resulting pressure field
%  n  = number of iterations

function f = antigradient2Mod(g, mask, mu, n, hx, hy, hz)

go = g;

if length(size(g)) == 4
    disp('3d')
    g(:,:,:,1) = go(:,:,:,2);
    g(:,:,:,2) = go(:,:,:,1);
else
    disp('2d')
    g(:,:,1) = go(:,:,2);
    g(:,:,2) = go(:,:,1);
end

f = antigradient2(g, mask, mu, n);

if (hx - hy < 1e-5) && (hx - hz < 1e-5)
    f = f.*hx;
else
    error('uniform mesh required');
end


