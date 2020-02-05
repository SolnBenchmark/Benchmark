% U=Frame_2DAiry(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,mu,xy)
%
% Produce a SOLN data frame with a 2D Airy PSF 
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
% mu      - Mean of Gaussian noise (photons/s/nm^2) 
% xy      - ith colume is 2D coordinate (x,y)' of ith emitter location
%           xy can be empty, i.e. xy=[]
%
% Output:
% U       - A data frame
%
% Note:   All distances are in nm
%
% Modified from:  CCDimage2DAiryPSF.m
%
% Reference
% [1] Sun, Y. Localization precision of stochastic optical localization
% nanoscopy using single frames. J. Biomed. Optics 18, 111418.1-15 (2013)
%
% Yi Sun
% 11/23/2019

function U=Frame_2DAiry(na,lambda,Kx,Ky,Dx,Dy,Dt,Ih,b,G,mu,xy) 

[~,M]=size(xy) ;
rp=Ih/b ; 
a=2*pi*na/lambda ; 
d=20 ;	% nm, As d increase, computation time decreases but error increases
xx=0.01+0:d:Dx-1 ; yy=(0.01+0:d:Dy-1)' ;	% start with 0.01 to avoid NaN
Q=zeros(Ky,Kx) ; 
for i=1:M
  if ~mod(i,10)
    fprintf(1,'M=%d i=%d: \n',M,i) ; 
  end
  xi=xy(1,i) ; yi=xy(2,i) ; 
	for ky=0:Ky-1
		yyi=(yy+(ky*Dy-yi))*ones(1,length(yy)) ;
		for kx=0:Kx-1
			xxi=ones(length(xx),1)*(xx+(kx*Dx-xi)) ; 
			r2=xxi.^2+yyi.^2 ; r2q=r2.^0.5 ;
			tmp=besselj(1,a*r2q).^2./(pi*r2) ;
      Q(ky+1,kx+1)=Q(ky+1,kx+1)+sum(sum(tmp)) ;
		end
	end
end
Q=(Dx*Dy)^(-1)*d^2*Q ;
v=Ih*Dt*Dx*Dy*(Q+1/rp) ;
V=poissrnd(v) ;
U=V+sqrt(Dt*Dx*Dy*G)*randn(size(V)) ;
U=U+Dt*Dx*Dy*mu ; 

end
