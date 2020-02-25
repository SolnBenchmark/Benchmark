% U=AS3D_Frame(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xyz) 
%
% Produce a SOLN data frame with a 3D astigmatic PSF 
% 
% Input:
% c       - z offset when x or y reaches its own focal plane with minimum width
% d       - microscope depth
% sigmax0 - PSF average xy width (equal in x, y) at focal plane (z=-c). 
%						Note: sigma0=w0/2 in Zhuang's papers
% Ax, Bx	- coefficient of higher order of sigmax
% sigmay0 - PSF average xy width (equal in x, y) at focal plane (z=c). 
%							Note: sigma0=w0/2 in Zhuang's papers
% Ay, By	- coefficient of higher order of sigmay
%	Kx, Ky	- Image size is Ky*Kx in pixels
%     			sample is located at [0,Kx*Dx]x[0,Ky*Dy]x[-Lz,Lz] 
%	Dx, Dy	- Pixel size is Dx*Dy square nanometers (nm^2)
% Dt   		- imaging time in second
% Ih		  - Number of detected photons per second from one emitter 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% mu      - Mean of Gaussian noise (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xyz     - zero(3,M), ith colume of xyz is (x,y,z) coordinates of ith emitter
%           location out of M emitters
%
% Output:
% U       - A data frame
%
% Note: 	- All distances are in nm 
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 2/17/2020

function U=AS3D_Frame(c,d,sigmax0,Ax,Bx,sigmay0,Ay,By,Kx,Ky,Dx,Dy,Dt,Ih,b,mu,G,xyz) 

[~,M]=size(xyz) ;
if M<1
  fprintf(1,'# of emitters is zero. \n') ;
  return ;
end
rp=Ih/b ; 
Q=zeros(Kx,Ky) ; 
phix=zeros(M,Kx) ; phiy=zeros(M,Ky) ;	
kx=0:Kx-1 ; ky=0:Ky-1 ; 
for i=1:M
  if mod(i,100)==0
    fprintf(1,'M=%3d  m=%3d\n',M,i) ;
  end
  z=xyz(3,i) ;
  sigmax=sigmax0*(1+(z+c).^2/d^2+Ax*(z+c).^3/d^3+Bx*(z+c).^4/d^4).^0.5 ;  
	sigmay=sigmay0*(1+(z-c).^2/d^2+Ay*(z-c).^3/d^3+By*(z-c).^4/d^4).^0.5 ;
	Dxk1=(Dx*(kx+1)-xyz(1,i))/sigmax ; Dxk0=(Dx*kx-xyz(1,i))/sigmax ; 
	Dyk1=(Dy*(ky+1)-xyz(2,i))/sigmay ; Dyk0=(Dy*ky-xyz(2,i))/sigmay ; 
	phix(i,:)=(Qfunc(-Dxk1)-Qfunc(-Dxk0)) ;
	phiy(i,:)=(Qfunc(-Dyk1)-Qfunc(-Dyk0)) ;
	Q=Q+phiy(i,:)'*phix(i,:) ;
end
Q=(Dx*Dy)^(-1)*Q ;
v=Ih*Dt*Dx*Dy*(Q+1/rp) ; 
V=poissrnd(v) ;
U=V+sqrt(Dt*Dx*Dy*G)*randn(size(V)) ;
U=U+Dt*Dx*Dy*mu ; 

end
