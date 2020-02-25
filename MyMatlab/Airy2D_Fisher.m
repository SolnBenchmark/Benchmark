% F=Airy2D_Fisher(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy)
% [SDV,SDVavg,FWHM,FWHMavg,F_]=CRLB_2DAiry(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy)
%
% Determine Fisher information matrix of 2D emitter from a data frame with 
% an Airy PSF. 
% 
% Input:
% na      - Numerical aperture
% lambda  - emission wavelength
%	Kx, Ky	- Frame size is Ky*Kx (pixels), specimen is located at [0,Kx*Dx]x[0,Ky*Dy]
%	Dx, Dy	- Pixel size is Dx*Dy (nm^2)
% Dt      - Frame time (s), frame rate = 1/Dt (frames/s) 
% Ih      - Mean number of detected photons (photons/s/emitter) 
% b       - Mean of Poisson noise (autofluorescence) (photons/s/nm^2) 
% G       - Variance of Gaussian noise (photons/s/nm^2)  
% xy      - ith colume is 2D coordinate (x,y)' of ith emitter location
%           xy can be empty, i.e. xy=[]
% 
% Output:
% F       - Fisher information matrix F for a data frame
%
% Note: (1) All distances are in nm 
%       (2) Gaussian noise is approximated by Poisson noise
%       (3) Gaussian noise mean is ignored
%
% Modified from: CRLB2DAiryPSF.m
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 02/22/2020 

function F=Airy2D_Fisher(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,xy) 

[~,M]=size(xy) ;
if M<1
  fprintf(1,'The number of emitter is zero. \n') ;
  return ;
end
r=Ih/(b+G) ;  % total SNR (nm^2/emitter) 
a=2*pi*na/lambda ; 
d=20 ;	% As d increases, computation time decreases but error increases
xx=0.01+0:d:Dx-1 ; yy=(0.01+0:d:Dy-1)' ;	% start with 0.01 to avoid NaN
Q=zeros(1,Ky,Kx) ; 
fprintf(1,'Step 1 ... \r') ;
for i=1:M
  xi=xy(1,i) ; yi=xy(2,i) ; 
	for ky=0:Ky-1
		yyi=(yy+(ky*Dy-yi))*ones(1,length(yy)) ;
		for kx=0:Kx-1
			xxi=ones(length(xx),1)*(xx+(kx*Dx-xi)) ; 
			r2=xxi.^2+yyi.^2 ; r2q=r2.^0.5 ;
			tmp=besselj(1,a*r2q).^2./(pi*r2) ;
      Q(1,ky+1,kx+1)=Q(1,ky+1,kx+1)+sum(sum(tmp)) ;
		end
	end
end
Q=(Dx*Dy)^(-1)*d^2*Q ; 
Qu=Q+1/r ;
if r==inf 
  Qu=Qu+1e-10 ; % add 1e-10 to avoid 0/0=NaN 
end
DqDy=zeros(M,Ky,Kx) ; DqDx=zeros(M,Ky,Kx) ; 
fprintf(1,'Step 2 ... \r') ;
for i=1:M
  xi=xy(1,i) ; yi=xy(2,i) ; 
	for ky=0:Ky-1
		yyi02=(Dy*(ky  )-yi)^2 ; yyi12=(Dy*(ky+1)-yi)^2 ;
		for kx=0:Kx-1
			xxi=xx+(kx*Dx-xi) ;
      r20=xxi.^2+yyi02 ; r20q=r20.^0.5 ;
			tmp=besselj(1,a*r20q).^2./(pi*r20) ; 
			DqDy(i,ky+1,kx+1)=DqDy(i,ky+1,kx+1)+sum(tmp) ;
      r21=xxi.^2+yyi12 ; r21q=r21.^0.5 ;
			tmp=besselj(1,a*r21q).^2./(pi*r21) ;
			DqDy(i,ky+1,kx+1)=DqDy(i,ky+1,kx+1)-sum(tmp) ;
		end
	end
	for kx=0:Kx-1,
		xxi02=(Dx*(kx  )-xi)^2 ; xxi12=(Dx*(kx+1)-xi)^2 ;
		for ky=0:Ky-1,
			yyi=yy+(ky*Dy-yi) ;
      r20=yyi.^2+xxi02 ; r20q=r20.^0.5 ;
			tmp=besselj(1,a*r20q).^2./(pi*r20) ;
			DqDx(i,ky+1,kx+1)=DqDx(i,ky+1,kx+1)+sum(tmp) ;
      r21=yyi.^2+xxi12 ; r21q=r21.^0.5 ;
			tmp=besselj(1,a*r21q).^2./(pi*r21) ;
			DqDx(i,ky+1,kx+1)=DqDx(i,ky+1,kx+1)-sum(tmp) ;
		end
	end
end
DqDy=(Dx*Dy)^(-1)*d*DqDy ; DqDx=(Dx*Dy)^(-1)*d*DqDx ;
F=zeros(2*M,2*M) ;	% Fisher information matrix: x1, y1, x2, y2, ...
for i=1:M
	for j=i:M
% F(xi,:)
		F(2*(i-1)+1,2*(j-1)+1)=sum(sum(DqDx(i,:,:).*DqDx(j,:,:)./Qu)) ;	% F(xi, xj)
		F(2*(j-1)+1,2*(i-1)+1)=F(2*(i-1)+1,2*(j-1)+1) ;                 % F(xj, xi)
		F(2*(i-1)+1,2*(j-1)+2)=sum(sum(DqDx(i,:,:).*DqDy(j,:,:)./Qu)) ;	% F(xi, yj)
		F(2*(j-1)+2,2*(i-1)+1)=F(2*(i-1)+1,2*(j-1)+2) ;                 % F(yj, xi)
% F(yi,:)
		F(2*(i-1)+2,2*(j-1)+1)=sum(sum(DqDy(i,:,:).*DqDx(j,:,:)./Qu)) ;	% F(yi, xj)
		F(2*(j-1)+1,2*(i-1)+2)=F(2*(i-1)+2,2*(j-1)+1) ;                 % F(xj, yi)
		F(2*(i-1)+2,2*(j-1)+2)=sum(sum(DqDy(i,:,:).*DqDy(j,:,:)./Qu)) ;	% F(yi, yj)
		F(2*(j-1)+2,2*(i-1)+2)=F(2*(i-1)+2,2*(j-1)+2) ;                 % F(yj, yi)
	end
end
F=Ih*Dt*Dx*Dy*F ; 

end
