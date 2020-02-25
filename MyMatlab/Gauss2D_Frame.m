% U=Gauss2D_Frame(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xy)  
%
% Produce a SOLN data frame with a 2D Gaussian PSF 
% 
% Input:
% sigma   - SDV of Gaussian PSF 
%	Kx, Ky	- Frame size is Ky*Kx (pixels), specimen is located at [0,Kx*Dx]x[0,Ky*Dy]
%	Dx, Dy	- Pixel size is Dx*Dy (nm^2)
% Dt      - Frame time (s), frame rate = 1/Dt (frames/s) 
% Ih      - Mean number of detected photons (photons/s/emitter) 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% mu      - Mean of Gaussian noise (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xy      - ith colume is 2D coordinate (x,y)' of ith emitter location
%           xy can be empty, i.e. xy=[]
%
% Output:
% U       - A data frame
%
% Note:   All distances are in nm
%
% Modified from:  CCDimage2DGauPSF_V2.m
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 11/16/2019

function U=Gauss2D_Frame(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xy)

[~,M]=size(xy) ; 
if M<1
  fprintf(1,'# of emitters is zero. \n') ;
  return ;
end
rp=Ih/b ; 
Q=zeros(Ky,Kx) ;
qx=zeros(M,Kx) ; qy=zeros(M,Ky) ;
kx=0:Kx-1 ; ky=0:Ky-1 ;
for i=1:M
  if mod(i,100)==0
    fprintf(1,'M=%3d  m=%3d\n',M,i) ;
  end
  Dxk1=(Dx*(kx+1)-xy(1,i))/sigma ; Dxk0=(Dx*kx-xy(1,i))/sigma ;
  Dyk1=(Dy*(ky+1)-xy(2,i))/sigma ; Dyk0=(Dy*ky-xy(2,i))/sigma ;
  qx(i,:)=(Qfunc(-Dxk1)-Qfunc(-Dxk0)) ;
  qy(i,:)=(Qfunc(-Dyk1)-Qfunc(-Dyk0)) ;
  Q=Q+qy(i,:)'*qx(i,:) ;
end
Q=(Dx*Dy)^(-1)*Q ;
v=Ih*Dt*Dx*Dy*(Q+1/rp) ;
V=poissrnd(v) ;
U=V+sqrt(Dt*Dx*Dy*G)*randn(size(V)) ;
U=U+Dt*Dx*Dy*mu ; 

end
