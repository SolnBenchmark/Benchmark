% [SDV,SDVavg,FWHM,FWHMavg,F,F_]=CRLB_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) 
%
% Calculate Cramer-Rao lower bound (CRLB) of 2D emitter locations from a 
% data frame with a Gaussian PSF. 
% 
% Input:
% sigma   - SDV of Gaussian PSF 
%	Kx, Ky	- Frame size is Ky*Kx (pixels), specimen is located at [0,Kx*Dx]x[0,Ky*Dy]
%	Dx, Dy	- Pixel size is Dx*Dy (nm^2)
% Dt      - Frame time (s), frame rate = 1/Dt (frames/s) 
% Ih      - Mean number of detected photons (photons/s/emitter) 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xy      - ith colume is 2D coordinate (x,y)' of ith emitter location
%
% Output:
% SDV     - ith column of SDV is standard deviation of estimate for ith column of xy
% SDVavg	- Average SDV of (x,y)
% FWHM		- FWHM=sqrt(2*log(2))*SDV 
% FWHMavg	- FWHMavg=sqrt(2*log(2))*SDVavg 
% F       - Fisher information matrix F
% F_      - inverse of F
%
% Note: (1) All distances are in nm 
%       (2) Gaussian noise is approximated by Poisson noise
%       (3) Gaussian noise mean is ignored
%
% Modified from:  CRLB2DGauPSF.m 
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 11/16/2019,12/23/2019

function [SDV,SDVavg,FWHM,FWHMavg,F,F_]=CRLB_2DGauss(sigma,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) 

[~,M]=size(xy) ;
if M<1 
  fprintf(1,'The number of emitters is zero. \n') ;
  return ;
end
r=Ih/(b+G) ;  % total SNR (nm^2/emitter) 
Q=zeros(Ky,Kx) ; 
qx=zeros(M,Kx) ;    qy=zeros(M,Ky) ; 
DqyDy=zeros(M,Ky) ; DqxDx=zeros(M,Kx) ; 
kx=0:Kx-1 ; ky=0:Ky-1 ; 
for i=1:M
	Dxk1=(Dx*(kx+1)-xy(1,i))/sigma ; Dxk0=(Dx*kx-xy(1,i))/sigma ; 
	Dyk1=(Dy*(ky+1)-xy(2,i))/sigma ; Dyk0=(Dy*ky-xy(2,i))/sigma ; 
	qx(i,:)=(Qfunc(-Dxk1)-Qfunc(-Dxk0))/Dx ;
	qy(i,:)=(Qfunc(-Dyk1)-Qfunc(-Dyk0))/Dy ;
	Q=Q+qy(i,:)'*qx(i,:) ;
  DqyDy(i,:)=(1/Dy)*(-exp(-Dyk1.^2/2)+exp(-Dyk0.^2/2))/(sqrt(2*pi)*sigma) ;
  DqxDx(i,:)=(1/Dx)*(-exp(-Dxk1.^2/2)+exp(-Dxk0.^2/2))/(sqrt(2*pi)*sigma) ;
end
Qu=Q+1/r ;      % Gaussian noise is approximated as Poisson noise 
if r==inf 
  Qu=Qu+1e-10 ; % add 1e-10 to avoid 0/0=NaN 
end
F=zeros(2*M,2*M) ;	% Fisher information matrix of (x1,y1,x2,y2,...,xM,yM)' 
for i=1:M	% 
	qyDqxDxi=qy(i,:)'*DqxDx(i,:) ; 
	DqyDyqxi=DqyDy(i,:)'*qx(i,:) ;
	for j=i:M
		qyDqxDxj=qy(j,:)'*DqxDx(j,:) ;
		DqyDyqxj=DqyDy(j,:)'*qx(j,:) ;
% F(xi,:)
		F(2*(i-1)+1,2*(j-1)+1)=sum(sum(qyDqxDxi.*qyDqxDxj./Qu)) ;	% F(xi, xj)
		F(2*(j-1)+1,2*(i-1)+1)=F(2*(i-1)+1,2*(j-1)+1) ;						% F(xj, xi)
		F(2*(i-1)+1,2*(j-1)+2)=sum(sum(qyDqxDxi.*DqyDyqxj./Qu)) ;	% F(xi, yj)
		F(2*(j-1)+2,2*(i-1)+1)=F(2*(i-1)+1,2*(j-1)+2) ;						% F(yj, xi)
% F(yi,:)
		F(2*(i-1)+2,2*(j-1)+1)=sum(sum(DqyDyqxi.*qyDqxDxj./Qu)) ;	% F(yi, xj)
		F(2*(j-1)+1,2*(i-1)+2)=F(2*(i-1)+2,2*(j-1)+1) ;						% F(xj, yi)
		F(2*(i-1)+2,2*(j-1)+2)=sum(sum(DqyDyqxi.*DqyDyqxj./Qu)) ;	% F(yi, yj)
		F(2*(j-1)+2,2*(i-1)+2)=F(2*(i-1)+2,2*(j-1)+2) ;						% F(yj, yi)
	end
end
F=Ih*Dt*Dx*Dy*F ; F_=inv(F) ; 
var=diag(F_) ;
SDV=zeros(2,M) ;
for i=1:M
	SDV(1,i)=sqrt(var(2*(i-1)+1)) ;	% SDV for x
	SDV(2,i)=sqrt(var(2*(i-1)+2)) ;	% SDV for y	
end
SDVavg=zeros(2,1) ;
SDVavg(1)=sum(SDV(1,:))/M ;
SDVavg(2)=sum(SDV(2,:))/M ;
FWHM=2*sqrt(2*log(2))*SDV ;
FWHMavg=2*sqrt(2*log(2))*SDVavg ;

end
