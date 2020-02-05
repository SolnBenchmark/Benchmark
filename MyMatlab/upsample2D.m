% img1=upsample2D(dx,dy,img0) 
%
%       dx, dy    rates of upsampling in x, y
%       img0      original image
%       img1      image after upsampling
%
%       a pixel of img1 is the 1/dxdy partion of the pixel in a rectangle of size dx x dy
%
% Yi Sun
% 10/7/2012


function img1=upsample2D(dx,dy,img0) 

[Mx, My]=size(img0) ;
Nx=dx*Mx ; Ny=dy*My ; img1=zeros(Nx,Ny) ;
for kx=1:Mx,
  for ky=1:My,
    img1(dx*(kx-1)+1:dx*kx,dy*(ky-1)+1:dy*ky)=img0(kx,ky) ;
  end
end

end

