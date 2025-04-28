function lam2 = lambda2(u,v,w,hx,hy,hz)

%get velocity gradient tensor
[dudy, dudx, dudz] = gradient(u);
[dvdy, dvdx, dvdz] = gradient(v);
[dwdy, dwdx, dwdz] = gradient(w);

%scale with grid size
dudx = dudx./hx;
dudy = dudy./hy;
dudz = dudz./hz;
dvdx = dvdx./hx;
dvdy = dvdy./hy;
dvdz = dvdz./hz;
dwdx = dwdx./hx;
dwdy = dwdy./hy;
dwdz = dwdz./hz;

for i=1:numel(u)
    J = [dudx(i) dudy(i) dudz(i); dvdx(i) dvdy(i) dvdz(i); dwdx(i) dwdy(i) dwdz(i)];
    S = (J+J')/2;
    O = (J-J')/2;
    eigenvalues = eig(S^2+O^2);
    eigenvalues = sort(eigenvalues);
    lam2(i) = eigenvalues(2);

end %every grid point

lam2 = reshape(lam2,size(u));

end %function